-- Location: supabase/migrations/20250722020944_homesnap_pro_auth_and_users.sql
-- HomeSnap Pro - Authentication and User Management Module

-- 1. Enable necessary extensions
-- These extensions are already available in Supabase, so we skip CREATE EXTENSION

-- 2. Create custom types for the application
CREATE TYPE public.user_role AS ENUM ('admin', 'agent', 'fsbo', 'host');
CREATE TYPE public.subscription_tier AS ENUM ('basic', 'pro', 'premium');
CREATE TYPE public.job_status AS ENUM ('pending', 'in_progress', 'processing', 'completed', 'delivered', 'cancelled');
CREATE TYPE public.service_type AS ENUM ('basic_photos', 'virtual_staging', 'object_removal', 'hdr_enhancement', 'drone_photos', 'floor_plan');

-- 3. Create user profiles table (Critical intermediary for auth relationships)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role public.user_role DEFAULT 'agent'::public.user_role,
    subscription_tier public.subscription_tier DEFAULT 'basic'::public.subscription_tier,
    phone TEXT,
    company_name TEXT,
    profile_image_url TEXT,
    total_jobs INTEGER DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- 4. Create properties table
CREATE TABLE public.properties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    zip_code TEXT NOT NULL,
    property_type TEXT DEFAULT 'residential',
    square_feet INTEGER,
    bedrooms INTEGER,
    bathrooms DECIMAL(3,1),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Create jobs table
CREATE TABLE public.jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    property_id UUID REFERENCES public.properties(id) ON DELETE SET NULL,
    status public.job_status DEFAULT 'pending'::public.job_status,
    total_photos INTEGER DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    special_instructions TEXT,
    turnaround_time INTEGER DEFAULT 16, -- hours
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ
);

-- 6. Create job services table (many-to-many relationship)
CREATE TABLE public.job_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES public.jobs(id) ON DELETE CASCADE,
    service_type public.service_type NOT NULL,
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Create photos table
CREATE TABLE public.photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES public.jobs(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    original_url TEXT,
    processed_url TEXT,
    thumbnail_url TEXT,
    file_size BIGINT,
    width INTEGER,
    height INTEGER,
    is_processed BOOLEAN DEFAULT false,
    room_type TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMPTZ
);

-- 8. Create payments table
CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES public.jobs(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    stripe_payment_intent_id TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ
);

-- 9. Essential indexes for performance
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_properties_owner_id ON public.properties(owner_id);
CREATE INDEX idx_jobs_user_id ON public.jobs(user_id);
CREATE INDEX idx_jobs_status ON public.jobs(status);
CREATE INDEX idx_jobs_created_at ON public.jobs(created_at DESC);
CREATE INDEX idx_job_services_job_id ON public.job_services(job_id);
CREATE INDEX idx_photos_job_id ON public.photos(job_id);
CREATE INDEX idx_payments_user_id ON public.payments(user_id);
CREATE INDEX idx_payments_job_id ON public.payments(job_id);

-- 10. Enable RLS on all tables
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.job_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- 11. Helper functions for RLS policies
CREATE OR REPLACE FUNCTION public.is_profile_owner(profile_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = profile_id AND up.id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.has_role(required_role TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role::TEXT = required_role
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_job(job_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.jobs j
    WHERE j.id = job_uuid AND (
        j.user_id = auth.uid() OR
        public.has_role('admin')
    )
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_property(property_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.properties p
    WHERE p.id = property_uuid AND (
        p.owner_id = auth.uid() OR
        public.has_role('admin')
    )
)
$$;

-- 12. RLS Policies
-- User profiles policies
CREATE POLICY "users_manage_own_profile"
ON public.user_profiles
FOR ALL
TO authenticated
USING (public.is_profile_owner(id))
WITH CHECK (public.is_profile_owner(id));

CREATE POLICY "admins_manage_all_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (public.has_role('admin'))
WITH CHECK (public.has_role('admin'));

-- Properties policies
CREATE POLICY "users_manage_own_properties"
ON public.properties
FOR ALL
TO authenticated
USING (public.can_access_property(id))
WITH CHECK (public.can_access_property(id));

-- Jobs policies
CREATE POLICY "users_access_own_jobs"
ON public.jobs
FOR ALL
TO authenticated
USING (public.can_access_job(id))
WITH CHECK (public.can_access_job(id));

-- Job services policies
CREATE POLICY "job_services_access"
ON public.job_services
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.jobs j
        WHERE j.id = job_id AND public.can_access_job(j.id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.jobs j
        WHERE j.id = job_id AND public.can_access_job(j.id)
    )
);

-- Photos policies
CREATE POLICY "photos_access"
ON public.photos
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.jobs j
        WHERE j.id = job_id AND public.can_access_job(j.id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.jobs j
        WHERE j.id = job_id AND public.can_access_job(j.id)
    )
);

-- Payments policies
CREATE POLICY "payments_access"
ON public.payments
FOR ALL
TO authenticated
USING (
    user_id = auth.uid() OR
    public.has_role('admin')
)
WITH CHECK (
    user_id = auth.uid() OR
    public.has_role('admin')
);

-- 13. Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'agent')::public.user_role
  );
  RETURN NEW;
END;
$$;

-- 14. Trigger for new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 15. Functions for updated_at timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Apply updated_at triggers
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_jobs_updated_at
    BEFORE UPDATE ON public.jobs
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 16. Sample data for development
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    agent_uuid UUID := gen_random_uuid();
    fsbo_uuid UUID := gen_random_uuid();
    property1_uuid UUID := gen_random_uuid();
    property2_uuid UUID := gen_random_uuid();
    job1_uuid UUID := gen_random_uuid();
    job2_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with complete field structure
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@homesnappro.com', crypt('HomeSnap2025!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "HomeSnap Admin", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (agent_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'sarah.agent@realestate.com', crypt('Agent2025!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Johnson", "role": "agent"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (fsbo_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'john.homeowner@gmail.com', crypt('Owner2025!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "John Smith", "role": "fsbo"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create sample properties
    INSERT INTO public.properties (id, owner_id, address, city, state, zip_code, property_type, square_feet, bedrooms, bathrooms)
    VALUES
        (property1_uuid, agent_uuid, '123 Sunset Boulevard', 'Beverly Hills', 'CA', '90210', 'residential', 2500, 4, 3.5),
        (property2_uuid, fsbo_uuid, '456 Ocean Drive', 'Miami Beach', 'FL', '33139', 'residential', 1800, 3, 2.0);

    -- Create sample jobs
    INSERT INTO public.jobs (id, user_id, property_id, status, total_photos, total_amount, special_instructions)
    VALUES
        (job1_uuid, agent_uuid, property1_uuid, 'completed'::public.job_status, 24, 149.99, 'Focus on natural lighting, especially in the living room'),
        (job2_uuid, fsbo_uuid, property2_uuid, 'processing'::public.job_status, 18, 199.99, 'Need virtual staging for master bedroom');

    -- Create sample job services
    INSERT INTO public.job_services (job_id, service_type, quantity, unit_price, total_price)
    VALUES
        (job1_uuid, 'basic_photos'::public.service_type, 24, 5.99, 143.76),
        (job1_uuid, 'hdr_enhancement'::public.service_type, 6, 1.00, 6.00),
        (job2_uuid, 'basic_photos'::public.service_type, 18, 5.99, 107.82),
        (job2_uuid, 'virtual_staging'::public.service_type, 1, 92.17, 92.17);

    -- Create sample photos
    INSERT INTO public.photos (job_id, file_name, original_url, thumbnail_url, room_type, is_processed)
    VALUES
        (job1_uuid, 'living_room_01.jpg', 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6', 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300', 'living_room', true),
        (job1_uuid, 'kitchen_01.jpg', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300', 'kitchen', true),
        (job2_uuid, 'master_bedroom_01.jpg', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300', 'bedroom', false);

    -- Create sample payments
    INSERT INTO public.payments (job_id, user_id, amount, status, completed_at)
    VALUES
        (job1_uuid, agent_uuid, 149.99, 'completed', now() - INTERVAL '1 day'),
        (job2_uuid, fsbo_uuid, 199.99, 'pending', null);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- 17. Cleanup function for development
CREATE OR REPLACE FUNCTION public.cleanup_sample_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    sample_user_ids UUID[];
BEGIN
    -- Get sample user IDs
    SELECT ARRAY_AGG(id) INTO sample_user_ids
    FROM auth.users
    WHERE email LIKE '%homesnappro.com' OR email LIKE '%realestate.com' OR email LIKE '%gmail.com';
    
    -- Delete in dependency order
    DELETE FROM public.payments WHERE user_id = ANY(sample_user_ids);
    DELETE FROM public.photos WHERE job_id IN (SELECT id FROM public.jobs WHERE user_id = ANY(sample_user_ids));
    DELETE FROM public.job_services WHERE job_id IN (SELECT id FROM public.jobs WHERE user_id = ANY(sample_user_ids));
    DELETE FROM public.jobs WHERE user_id = ANY(sample_user_ids);
    DELETE FROM public.properties WHERE owner_id = ANY(sample_user_ids);
    DELETE FROM public.user_profiles WHERE id = ANY(sample_user_ids);
    DELETE FROM auth.users WHERE id = ANY(sample_user_ids);
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;