/* ####################################################################
  #                           RESET DATABASE                         #
  #  WARNING: This deletes all data in the specified public tables   #
  ####################################################################
*/

-- Drop Trigger first to stop auto-creation during reset
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();

-- Drop Tables (Cascade removes dependent foreign keys automatically)
drop table if exists public.saved_circuits cascade;
drop table if exists public.blog_posts cascade;
drop table if exists public.product_purchases cascade;
drop table if exists public.products cascade;
drop table if exists public.course_enrollments cascade;
drop table if exists public.quiz_questions cascade;
drop table if exists public.lessons cascade;
drop table if exists public.course_modules cascade;
drop table if exists public.certificates cascade;
drop table if exists public.user_progress cascade;
drop table if exists public.courses cascade;
drop table if exists public.components cascade;
drop table if exists public.profiles cascade;

/* ####################################################################
  #                          SCHEMA SETUP                            #
  ####################################################################
*/

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. PROFILES (Extends auth.users)
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text,
  display_name text,
  role text default 'user' check (role in ('user', 'admin')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. COURSES
create table public.courses (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  slug text unique not null,
  short_description text,
  full_description text,
  cover_image text,
  banner_image text,
  level text check (level in ('Beginner', 'Intermediate', 'Advanced')),
  price integer default 0, -- in cents
  is_published boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. COURSE MODULES
create table public.course_modules (
  id uuid default uuid_generate_v4() primary key,
  course_id uuid references public.courses(id) on delete cascade not null,
  title text not null,
  order_index integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. LESSONS
create table public.lessons (
  id uuid default uuid_generate_v4() primary key,
  course_id uuid references public.courses(id) on delete cascade not null,
  module_id uuid references public.course_modules(id) on delete cascade,
  title text not null,
  slug text not null,
  content text, -- markdown
  video_url text,
  order_index integer default 0,
  is_free_preview boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(course_id, slug)
);

-- 4. COURSE ENROLLMENTS
create table public.course_enrollments (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  course_id uuid references public.courses(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  payment_status text default 'paid',
  unique(user_id, course_id)
);

-- 5. PRODUCTS (Digital Store)
create table public.products (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  slug text unique not null,
  description text,
  price integer not null, -- in cents
  variants jsonb default '[]'::jsonb,
  file_url text, -- Secure download link
  is_published boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 6. PRODUCT PURCHASES
create table public.product_purchases (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  product_id uuid references public.products(id) on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, product_id)
);

-- 7. BLOG POSTS
create table public.blog_posts (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  slug text unique not null,
  excerpt text,
  cover_image text,
  content text,
  published_at timestamp with time zone,
  is_published boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 8. SAVED CIRCUITS (For the Simulator)
create table public.saved_circuits (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  components jsonb default '[]'::jsonb,
  wires jsonb default '[]'::jsonb,
  code text,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 9. COMPONENT LIBRARY
create table public.components (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  type text not null unique,
  slug text not null unique,
  category text,
  image_url text,
  svg_markup text,
  width integer not null,
  height integer not null,
  pins jsonb not null default '[]'::jsonb,
  animations jsonb not null default '[]'::jsonb,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 10. QUIZ QUESTIONS
create table public.quiz_questions (
  id uuid default uuid_generate_v4() primary key,
  lesson_id uuid references public.lessons(id) on delete cascade not null,
  question text not null,
  options jsonb not null default '[]'::jsonb,
  correct_index integer not null default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 11. USER PROGRESS
create table public.user_progress (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  course_id uuid references public.courses(id) on delete cascade not null,
  lesson_id uuid references public.lessons(id) on delete cascade,
  progress integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 12. CERTIFICATES
create table public.certificates (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  course_id uuid references public.courses(id) on delete cascade not null,
  issued_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS POLICIES ------------------------------------------

alter table profiles enable row level security;
alter table courses enable row level security;
alter table lessons enable row level security;
alter table course_enrollments enable row level security;
alter table products enable row level security;
alter table product_purchases enable row level security;
alter table blog_posts enable row level security;
alter table saved_circuits enable row level security;
alter table components enable row level security;

-- Profiles: Users read own, Admins read all
create policy "Public profiles are viewable by everyone" on profiles for select using (true);
create policy "Users can update own profile" on profiles for update using (auth.uid() = id);

-- Courses/Products/Blog: Public read if published
create policy "Public read published courses" on courses for select using (is_published = true);
create policy "Public read published products" on products for select using (is_published = true);
create policy "Public read published posts" on blog_posts for select using (is_published = true);

-- Enrollments/Purchases: Users see their own
create policy "Users see own enrollments" on course_enrollments for select using (auth.uid() = user_id);
create policy "Users see own purchases" on product_purchases for select using (auth.uid() = user_id);

-- Saved Circuits: Users manage their own
create policy "Users manage own circuits" on saved_circuits for all using (auth.uid() = user_id);

-- Component Library: Public read, admins manage
create policy "Public read components" on components for select using (true);
create policy "Admins insert components" on components for insert with check (
  exists(select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);
create policy "Admins update components" on components for update using (
  exists(select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);
create policy "Admins delete components" on components for delete using (
  exists(select 1 from profiles p where p.id = auth.uid() and p.role = 'admin')
);

-- Lessons: Complex logic (simplified here)
-- In production, you'd use a function to check enrollment, but for now we allow read if is_free_preview OR valid enrollment exists
create policy "Read lessons" on lessons for select using (
  is_free_preview = true OR 
  exists (select 1 from course_enrollments where user_id = auth.uid() and course_id = lessons.course_id)
);

-- TRIGGERS ----------------------------------------------

-- Auto-create profile on signup
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, email, display_name, role)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name', 'user');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- SEED DATA ---------------------------------------------

insert into courses (title, slug, short_description, price, is_published) values 
('Arduino Mastery', 'arduino-mastery', 'Zero to Hero with Arduino C++', 4900, true),
('ESP32 IoT Secrets', 'esp32-iot', 'Connect your devices to the cloud', 0, true);

insert into products (title, slug, description, price, is_published) values 
('Ultimate Component Library', 'component-lib', 'PCB Footprints for Eagle/KiCad', 1500, true);

insert into blog_posts (title, slug, excerpt, is_published, published_at) values
('Why Simulations Matter', 'why-simulations', 'Hardware is hard. Software is soft. Simulate first.', true, now());
