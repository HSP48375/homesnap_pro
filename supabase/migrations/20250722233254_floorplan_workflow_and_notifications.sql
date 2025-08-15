-- Location: supabase/migrations/20250722233254_floorplan_workflow_and_notifications.sql
-- HomeSnap Pro - 2D Floorplan Workflow and Real-time Notifications Module

-- 1. Create additional types for floorplan workflow
CREATE TYPE public.floorplan_status AS ENUM ('recording', 'uploaded', 'processing', 'completed', 'failed');
CREATE TYPE public.room_type AS ENUM ('living_room', 'kitchen', 'bedroom', 'bathroom', 'dining_room', 'office', 'hallway', 'other');
CREATE TYPE public.notification_type AS ENUM ('job_status', 'payment_failed', 'new_job', 'system_alert', 'floorplan_ready');

-- 2. Create service pricing table for admin management
CREATE TABLE public.service_pricing (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    unit_type TEXT NOT NULL,
    description TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_modified_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL
);

-- 3. Create floorplan requests table
CREATE TABLE public.floorplan_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES public.jobs(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    status public.floorplan_status DEFAULT 'recording'::public.floorplan_status,
    video_file_path TEXT,
    video_file_size BIGINT,
    recording_duration INTEGER, -- in seconds
    rooms_recorded INTEGER DEFAULT 0,
    total_rooms_planned INTEGER DEFAULT 8,
    processing_started_at TIMESTAMPTZ,
    estimated_completion_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    floorplan_image_url TEXT,
    special_instructions TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Create room recordings table
CREATE TABLE public.room_recordings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    floorplan_request_id UUID REFERENCES public.floorplan_requests(id) ON DELETE CASCADE,
    room_type public.room_type NOT NULL,
    room_name TEXT,
    recording_order INTEGER,
    video_segment_path TEXT,
    duration_seconds INTEGER,
    is_completed BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Create notifications table
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    type public.notification_type NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    data JSONB,
    is_read BOOLEAN DEFAULT false,
    is_admin_notification BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMPTZ
);

-- 6. Create feature updates table for "New!" badges
CREATE TABLE public.feature_updates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feature_name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    is_new BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    hide_after TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP + INTERVAL '30 days')
);

-- 7. Essential indexes for performance
CREATE INDEX idx_service_pricing_service_id ON public.service_pricing(service_id);
CREATE INDEX idx_service_pricing_active ON public.service_pricing(is_active);
CREATE INDEX idx_floorplan_requests_user_id ON public.floorplan_requests(user_id);
CREATE INDEX idx_floorplan_requests_job_id ON public.floorplan_requests(job_id);
CREATE INDEX idx_floorplan_requests_status ON public.floorplan_requests(status);
CREATE INDEX idx_room_recordings_request_id ON public.room_recordings(floorplan_request_id);
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX idx_notifications_admin ON public.notifications(is_admin_notification);
CREATE INDEX idx_notifications_created_at ON public.notifications(created_at DESC);
CREATE INDEX idx_feature_updates_is_new ON public.feature_updates(is_new);

-- 8. Enable RLS on all new tables
ALTER TABLE public.service_pricing ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.floorplan_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.room_recordings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feature_updates ENABLE ROW LEVEL SECURITY;

-- 9. Helper functions for RLS policies
CREATE OR REPLACE FUNCTION public.can_manage_pricing(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = user_uuid AND up.role = 'admin'
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_floorplan_request(request_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.floorplan_requests fr
    WHERE fr.id = request_uuid AND (
        fr.user_id = auth.uid() OR
        public.has_role('admin')
    )
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_notification(notification_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.notifications n
    WHERE n.id = notification_uuid AND (
        n.user_id = auth.uid() OR
        (n.is_admin_notification = true AND public.has_role('admin'))
    )
)
$$;

-- 10. RLS Policies for service pricing (admin only)
CREATE POLICY "admin_manage_service_pricing"
ON public.service_pricing
FOR ALL
TO authenticated
USING (public.has_role('admin'))
WITH CHECK (public.has_role('admin'));

-- Public can read active pricing for display
CREATE POLICY "public_read_active_pricing"
ON public.service_pricing
FOR SELECT
TO authenticated
USING (is_active = true);

-- 11. RLS Policies for floorplan requests
CREATE POLICY "users_manage_own_floorplan_requests"
ON public.floorplan_requests
FOR ALL
TO authenticated
USING (public.can_access_floorplan_request(id))
WITH CHECK (public.can_access_floorplan_request(id));

-- 12. RLS Policies for room recordings
CREATE POLICY "room_recordings_access"
ON public.room_recordings
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.floorplan_requests fr
        WHERE fr.id = floorplan_request_id AND public.can_access_floorplan_request(fr.id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.floorplan_requests fr
        WHERE fr.id = floorplan_request_id AND public.can_access_floorplan_request(fr.id)
    )
);

-- 13. RLS Policies for notifications
CREATE POLICY "users_access_own_notifications"
ON public.notifications
FOR ALL
TO authenticated
USING (public.can_access_notification(id))
WITH CHECK (public.can_access_notification(id));

-- 14. RLS Policies for feature updates (public read)
CREATE POLICY "public_read_feature_updates"
ON public.feature_updates
FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "admin_manage_feature_updates"
ON public.feature_updates
FOR ALL
TO authenticated
USING (public.has_role('admin'))
WITH CHECK (public.has_role('admin'));

-- 15. Apply updated_at triggers to new tables
CREATE TRIGGER update_service_pricing_updated_at
    BEFORE UPDATE ON public.service_pricing
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_floorplan_requests_updated_at
    BEFORE UPDATE ON public.floorplan_requests
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 16. Function to create notifications
CREATE OR REPLACE FUNCTION public.create_notification(
    target_user_id UUID,
    notification_type public.notification_type,
    title TEXT,
    message TEXT,
    data JSONB DEFAULT NULL,
    is_admin BOOLEAN DEFAULT false
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO public.notifications (
        user_id, type, title, message, data, is_admin_notification
    ) VALUES (
        target_user_id, notification_type, title, message, data, is_admin
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$;

-- 17. Function to update floorplan status with notifications
CREATE OR REPLACE FUNCTION public.update_floorplan_status(
    request_id UUID,
    new_status public.floorplan_status,
    completion_message TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    request_user_id UUID;
    notification_title TEXT;
    notification_message TEXT;
BEGIN
    -- Get user_id for the request
    SELECT user_id INTO request_user_id
    FROM public.floorplan_requests
    WHERE id = request_id;
    
    -- Update the status
    UPDATE public.floorplan_requests
    SET status = new_status,
        completed_at = CASE WHEN new_status = 'completed' THEN CURRENT_TIMESTAMP ELSE completed_at END,
        processing_started_at = CASE WHEN new_status = 'processing' THEN CURRENT_TIMESTAMP ELSE processing_started_at END,
        estimated_completion_at = CASE WHEN new_status = 'processing' THEN CURRENT_TIMESTAMP + INTERVAL '14 hours' ELSE estimated_completion_at END
    WHERE id = request_id;
    
    -- Create appropriate notification
    CASE new_status
        WHEN 'processing' THEN
            notification_title := '2D Floorplan Processing Started';
            notification_message := 'Your floorplan will be ready in 12-14 hours. You will receive a notification when it is complete.';
        WHEN 'completed' THEN
            notification_title := 'Floorplan Ready!';
            notification_message := COALESCE(completion_message, 'Your 2D floorplan has been completed and is ready for download.');
        WHEN 'failed' THEN
            notification_title := 'Floorplan Processing Failed';
            notification_message := 'There was an issue processing your floorplan. Please contact support for assistance.';
        ELSE
            notification_title := 'Floorplan Status Update';
            notification_message := 'Your floorplan status has been updated to ' || new_status::TEXT;
    END CASE;
    
    -- Create notification for user
    PERFORM public.create_notification(
        request_user_id,
        'floorplan_ready'::public.notification_type,
        notification_title,
        notification_message,
        jsonb_build_object('floorplan_request_id', request_id, 'status', new_status)
    );
    
    -- Create admin notification for processing status changes
    IF new_status IN ('processing', 'completed', 'failed') THEN
        PERFORM public.create_notification(
            request_user_id, -- Admin notifications use the same user system
            'system_alert'::public.notification_type,
            'Floorplan Status: ' || new_status::TEXT,
            'Floorplan request ' || request_id::TEXT || ' status changed to ' || new_status::TEXT,
            jsonb_build_object('floorplan_request_id', request_id, 'status', new_status),
            true
        );
    END IF;
END;
$$;

-- 18. Sample data for development
DO $$
DECLARE
    admin_user_id UUID;
    agent_user_id UUID;
BEGIN
    -- Get existing user IDs
    SELECT id INTO admin_user_id FROM public.user_profiles WHERE email = 'admin@homesnappro.com' LIMIT 1;
    SELECT id INTO agent_user_id FROM public.user_profiles WHERE email = 'sarah.agent@realestate.com' LIMIT 1;
    
    -- Insert service pricing data
    INSERT INTO public.service_pricing (service_id, name, base_price, unit_type, description, last_modified_by)
    VALUES
        ('basic_photos', 'Professional Photo Editing', 5.99, 'per photo', 'HDR processing, color correction, and professional enhancement', admin_user_id),
        ('virtual_staging', 'Virtual Staging', 25.00, 'per room', 'Digitally furnish empty rooms with modern furniture', admin_user_id),
        ('object_removal', 'Object Removal', 15.00, 'per photo', 'Remove unwanted objects, personal items, or clutter', admin_user_id),
        ('sky_replacement', 'Sky Replacement', 20.00, 'per photo', 'Replace dull skies with beautiful blue skies and clouds', admin_user_id),
        ('hdr_enhancement', 'HDR Enhancement', 10.00, 'per photo', 'Advanced HDR processing for perfect lighting balance', admin_user_id),
        ('floorplan_2d', '2D Floorplan Creation', 45.00, 'per floorplan', 'Professional 2D floorplan created from video walkthrough (12-14 hour delivery)', admin_user_id);
    
    -- Insert feature updates for "New!" badges
    INSERT INTO public.feature_updates (feature_name, description)
    VALUES
        ('2d_floorplan_creator', '2D Floorplan Creator with video recording and CubiCasa-style guidance'),
        ('admin_pricing_editor', 'Real-time pricing and service description editing for administrators'),
        ('real_time_notifications', 'Instant notifications for job status updates, payments, and system alerts'),
        ('job_progress_tracking', 'Visual progress bars and detailed tracking for all orders');
    
    -- Create sample floorplan request if agent exists
    IF agent_user_id IS NOT NULL THEN
        INSERT INTO public.floorplan_requests (user_id, status, rooms_recorded, total_rooms_planned, special_instructions)
        VALUES (
            agent_user_id,
            'processing'::public.floorplan_status,
            8,
            8,
            'Focus on open floor plan layout, include measurements for kitchen island'
        );
        
        -- Create sample notifications
        PERFORM public.create_notification(
            agent_user_id,
            'floorplan_ready'::public.notification_type,
            'Floorplan Processing Started',
            'Your 2D floorplan will be ready in 12-14 hours',
            jsonb_build_object('delivery_time', '12-14 hours')
        );
        
        PERFORM public.create_notification(
            admin_user_id,
            'new_job'::public.notification_type,
            'New Floorplan Request',
            'New 2D floorplan request from Sarah Johnson',
            jsonb_build_object('user_name', 'Sarah Johnson'),
            true
        );
    END IF;
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;