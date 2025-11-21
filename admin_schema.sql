
-- 1. Add Variants to Products
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS variants jsonb DEFAULT '[]'::jsonb;

-- 2. Storage Policies (Run these if you created a bucket named 'images')
-- Allow public read access
create policy "Public Access"
  on storage.objects for select
  using ( bucket_id = 'images' );

-- Allow authenticated users to upload (In a real app, restrict to admin)
create policy "Authenticated Upload"
  on storage.objects for insert
  with check ( bucket_id = 'images' and auth.role() = 'authenticated' );
  
-- 3. Ensure Admin Role exists (Manual update required for your user)
-- UPDATE public.profiles SET role = 'admin' WHERE email = 'your-email@example.com';
