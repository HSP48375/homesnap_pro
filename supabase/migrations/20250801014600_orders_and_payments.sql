-- Location: supabase/migrations/20250801014600_orders_and_payments.sql
-- Schema Analysis: Extending existing schema with orders and payment functionality
-- Integration Type: addition
-- Dependencies: user_profiles table (from existing schema)

-- Create order status enum
CREATE TYPE public.order_status AS ENUM ('Pending', 'Processing', 'Completed', 'Cancelled', 'Refunded');

-- Create orders table
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    job_type TEXT NOT NULL,
    property_address TEXT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_intent_id TEXT UNIQUE,
    status public.order_status DEFAULT 'Pending'::public.order_status,
    photo_count INTEGER DEFAULT 0,
    special_instructions TEXT,
    delivery_timeline TEXT DEFAULT '12-16 hours',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ
);

-- Create order_photos table
CREATE TABLE public.order_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id TEXT NOT NULL, -- References payment_intent_id from orders
    photo_path TEXT NOT NULL,
    photo_index INTEGER NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create order_services table for add-on services
CREATE TABLE public.order_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    service_name TEXT NOT NULL,
    service_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_orders_user_id ON public.orders(user_id);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_orders_created_at ON public.orders(created_at);
CREATE INDEX idx_order_photos_order_id ON public.order_photos(order_id);
CREATE INDEX idx_order_services_order_id ON public.order_services(order_id);

-- Enable RLS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_services ENABLE ROW LEVEL SECURITY;

-- Helper functions for RLS
CREATE OR REPLACE FUNCTION public.is_order_owner(order_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.orders o
    WHERE o.id = order_uuid AND o.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.can_access_order_photo(photo_order_id TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.orders o
    WHERE o.payment_intent_id = photo_order_id AND o.user_id = auth.uid()
)
$$;

-- RLS Policies
CREATE POLICY "users_manage_own_orders"
ON public.orders
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_access_own_order_photos"
ON public.order_photos
FOR ALL
TO authenticated
USING (public.can_access_order_photo(order_id))
WITH CHECK (public.can_access_order_photo(order_id));

CREATE POLICY "users_access_own_order_services"
ON public.order_services
FOR ALL
TO authenticated
USING (public.is_order_owner(order_id))
WITH CHECK (public.is_order_owner(order_id));

-- Function to update order timestamp
CREATE OR REPLACE FUNCTION public.update_order_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Trigger for order updates
CREATE TRIGGER update_orders_timestamp
    BEFORE UPDATE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.update_order_timestamp();

-- Mock data for testing
DO $$
DECLARE
    test_user_id UUID;
    test_order_id UUID := gen_random_uuid();
    test_payment_intent TEXT := 'pi_demo_' || extract(epoch from now())::text;
BEGIN
    -- Get an existing user ID
    SELECT id INTO test_user_id FROM public.user_profiles LIMIT 1;
    
    IF test_user_id IS NOT NULL THEN
        -- Create sample order
        INSERT INTO public.orders (
            id, user_id, job_type, property_address, total_amount, 
            payment_intent_id, status, photo_count, special_instructions
        ) VALUES (
            test_order_id, test_user_id, 'Floor Plan Creation', 
            '123 Main St, Anytown, USA', 299.99, test_payment_intent, 
            'Processing'::public.order_status, 15, 'Please include room dimensions'
        );

        -- Create sample order services
        INSERT INTO public.order_services (order_id, service_name, service_price) VALUES
            (test_order_id, '3D Virtual Tour', 99.99),
            (test_order_id, 'Professional Photography Enhancement', 49.99);

        -- Create sample order photos
        INSERT INTO public.order_photos (order_id, photo_path, photo_index) VALUES
            (test_payment_intent, '/path/to/photo1.jpg', 1),
            (test_payment_intent, '/path/to/photo2.jpg', 2),
            (test_payment_intent, '/path/to/photo3.jpg', 3);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Mock data creation failed: %', SQLERRM;
END $$;