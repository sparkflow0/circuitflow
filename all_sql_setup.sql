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
drop table if exists public.comments cascade;
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
  type text,
  content text, -- markdown
  video_url text,
  duration integer default 0,
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

-- 8. COMMENTS (For Blog Posts)
create table public.comments (
  id uuid default uuid_generate_v4() primary key,
  post_id uuid references public.blog_posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  content text not null,
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
alter table comments enable row level security;

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

-- Comments: Public read, authenticated create
create policy "Comments are viewable by everyone" on comments for select using (true);
create policy "Users can insert their own comments" on comments for insert with check (auth.uid() = user_id);

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
insert into public.components (name, type, slug, category, image_url, width, height, pins, animations, metadata) values
('Arduino Uno R3', 'ARDUINO', 'arduino-uno-r3', 'microcontroller', null, 320, 210, '[
  {"id":"0","label":"0 / RX","x":22,"y":12,"voltage":"5V"},
  {"id":"1","label":"1 / TX","x":38,"y":12,"voltage":"5V"},
  {"id":"2","label":"2","x":54,"y":12,"voltage":"5V"},
  {"id":"3","label":"3 ~","x":70,"y":12,"voltage":"5V"},
  {"id":"4","label":"4","x":86,"y":12,"voltage":"5V"},
  {"id":"5","label":"5 ~","x":102,"y":12,"voltage":"5V"},
  {"id":"6","label":"6 ~","x":118,"y":12,"voltage":"5V"},
  {"id":"7","label":"7","x":134,"y":12,"voltage":"5V"},
  {"id":"8","label":"8","x":150,"y":12,"voltage":"5V"},
  {"id":"9","label":"9 ~","x":166,"y":12,"voltage":"5V"},
  {"id":"10","label":"10 ~","x":182,"y":12,"voltage":"5V"},
  {"id":"11","label":"11 ~","x":198,"y":12,"voltage":"5V"},
  {"id":"12","label":"12","x":214,"y":12,"voltage":"5V"},
  {"id":"13","label":"13","x":230,"y":12,"voltage":"5V"},
  {"id":"GND1","label":"GND","x":246,"y":12,"voltage":"GND"},
  {"id":"AREF","label":"AREF","x":262,"y":12,"voltage":"REF"},
  {"id":"SDA","label":"SDA","x":278,"y":12,"voltage":"5V"},
  {"id":"SCL","label":"SCL","x":294,"y":12,"voltage":"5V"},
  {"id":"IOREF","label":"IOREF","x":30,"y":194,"voltage":"5V"},
  {"id":"RESET","label":"RESET","x":46,"y":194,"voltage":"5V"},
  {"id":"3.3V","label":"3.3V","x":62,"y":194,"voltage":"3V3"},
  {"id":"5V","label":"5V","x":78,"y":194,"voltage":"5V"},
  {"id":"GND2","label":"GND","x":94,"y":194,"voltage":"GND"},
  {"id":"GND3","label":"GND","x":110,"y":194,"voltage":"GND"},
  {"id":"VIN","label":"VIN","x":126,"y":194,"voltage":"VIN"},
  {"id":"A0","label":"A0","x":160,"y":194,"voltage":"ANALOG"},
  {"id":"A1","label":"A1","x":176,"y":194,"voltage":"ANALOG"},
  {"id":"A2","label":"A2","x":192,"y":194,"voltage":"ANALOG"},
  {"id":"A3","label":"A3","x":208,"y":194,"voltage":"ANALOG"},
  {"id":"A4","label":"A4","x":224,"y":194,"voltage":"ANALOG"},
  {"id":"A5","label":"A5","x":240,"y":194,"voltage":"ANALOG"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"5V","platform":"avr"}'::jsonb),
('ESP32 DevKit', 'ESP32', 'esp32-devkit', 'microcontroller', null, 180, 260, '[
  {"id":"EN","label":"EN","x":12,"y":28,"voltage":"3V3"},
  {"id":"VP","label":"VP","x":12,"y":44,"voltage":"3V3"},
  {"id":"VN","label":"VN","x":12,"y":60,"voltage":"3V3"},
  {"id":"34","label":"34","x":12,"y":76,"voltage":"3V3"},
  {"id":"35","label":"35","x":12,"y":92,"voltage":"3V3"},
  {"id":"32","label":"32","x":12,"y":108,"voltage":"3V3"},
  {"id":"33","label":"33","x":12,"y":124,"voltage":"3V3"},
  {"id":"25","label":"25","x":12,"y":140,"voltage":"3V3"},
  {"id":"26","label":"26","x":12,"y":156,"voltage":"3V3"},
  {"id":"27","label":"27","x":12,"y":172,"voltage":"3V3"},
  {"id":"14","label":"14","x":12,"y":188,"voltage":"3V3"},
  {"id":"12","label":"12","x":12,"y":204,"voltage":"3V3"},
  {"id":"GND","label":"GND","x":12,"y":220,"voltage":"GND"},
  {"id":"VIN","label":"VIN","x":12,"y":236,"voltage":"VIN"},
  {"id":"23","label":"23","x":168,"y":28,"voltage":"3V3"},
  {"id":"22","label":"22","x":168,"y":44,"voltage":"3V3"},
  {"id":"1","label":"TX0","x":168,"y":60,"voltage":"3V3"},
  {"id":"3","label":"RX0","x":168,"y":76,"voltage":"3V3"},
  {"id":"21","label":"21","x":168,"y":92,"voltage":"3V3"},
  {"id":"GND2","label":"GND","x":168,"y":108,"voltage":"GND"},
  {"id":"19","label":"19","x":168,"y":124,"voltage":"3V3"},
  {"id":"18","label":"18","x":168,"y":140,"voltage":"3V3"},
  {"id":"5","label":"5","x":168,"y":156,"voltage":"3V3"},
  {"id":"17","label":"17","x":168,"y":172,"voltage":"3V3"},
  {"id":"16","label":"16","x":168,"y":188,"voltage":"3V3"},
  {"id":"4","label":"4","x":168,"y":204,"voltage":"3V3"},
  {"id":"2","label":"2","x":168,"y":220,"voltage":"3V3"},
  {"id":"15","label":"15","x":168,"y":236,"voltage":"3V3"},
  {"id":"13","label":"13","x":168,"y":252,"voltage":"3V3"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"3V3","platform":"esp32"}'::jsonb),
('LED 5mm', 'LED', 'led-5mm', 'passive', null, 36, 80, '[
  {"id":"anode","label":"Anode","x":26,"y":72,"voltage":"VCC"},
  {"id":"cathode","label":"Cathode","x":10,"y":72,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"forward"}'::jsonb),
('RGB LED', 'RGB_LED', 'rgb-led', 'passive', null, 44, 86, '[
  {"id":"R","label":"Red","x":8,"y":78,"voltage":"VCC"},
  {"id":"cathode","label":"Common","x":18,"y":78,"voltage":"GND"},
  {"id":"G","label":"Green","x":28,"y":78,"voltage":"VCC"},
  {"id":"B","label":"Blue","x":38,"y":78,"voltage":"VCC"}
]'::jsonb, '[]'::jsonb, '{"default_voltage":"forward"}'::jsonb),
('Resistor', 'RESISTOR', 'resistor', 'passive', null, 90, 24, '[
  {"id":"t1","label":"Terminal 1","x":6,"y":12,"voltage":"passive"},
  {"id":"t2","label":"Terminal 2","x":84,"y":12,"voltage":"passive"}
]'::jsonb, '[]'::jsonb, '{}'),
('Push Button', 'BUTTON', 'push-button', 'input', null, 60, 60, '[
  {"id":"1a","x":6,"y":6,"voltage":"passive"},
  {"id":"1b","x":6,"y":54,"voltage":"passive"},
  {"id":"2a","x":54,"y":6,"voltage":"passive"},
  {"id":"2b","x":54,"y":54,"voltage":"passive"}
]'::jsonb, '[]'::jsonb, '{}'),
('Micro Servo', 'SERVO', 'micro-servo', 'actuator', null, 90, 110, '[
  {"id":"GND","x":22,"y":104,"voltage":"GND"},
  {"id":"VCC","x":45,"y":104,"voltage":"5V"},
  {"id":"SIG","x":68,"y":104,"voltage":"PWM"}
]'::jsonb, '[]'::jsonb, '{}'),
('DC Motor', 'MOTOR', 'dc-motor', 'actuator', null, 90, 90, '[
  {"id":"pos","x":14,"y":78,"voltage":"VCC"},
  {"id":"neg","x":76,"y":78,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{}'),
('Buzzer', 'BUZZER', 'buzzer', 'actuator', null, 60, 60, '[
  {"id":"pos","x":12,"y":52,"voltage":"VCC"},
  {"id":"neg","x":48,"y":52,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{}'),
('Potentiometer', 'POT', 'potentiometer', 'input', null, 70, 70, '[
  {"id":"GND","x":12,"y":64,"voltage":"GND"},
  {"id":"SIG","x":35,"y":64,"voltage":"ANALOG"},
  {"id":"VCC","x":58,"y":64,"voltage":"VCC"}
]'::jsonb, '[]'::jsonb, '{}'),
('Photoresistor', 'LDR', 'photoresistor', 'input', null, 60, 60, '[
  {"id":"t1","x":12,"y":54,"voltage":"passive"},
  {"id":"t2","x":48,"y":54,"voltage":"passive"}
]'::jsonb, '[]'::jsonb, '{}'),
('Ultrasonic HC-SR04', 'ULTRASONIC', 'ultrasonic-hcsr04', 'sensor', null, 120, 60, '[
  {"id":"VCC","x":20,"y":54,"voltage":"5V"},
  {"id":"TRIG","x":44,"y":54,"voltage":"5V"},
  {"id":"ECHO","x":68,"y":54,"voltage":"5V"},
  {"id":"GND","x":92,"y":54,"voltage":"GND"}
]'::jsonb, '[]'::jsonb, '{}'),
('7-Segment', 'SEVEN_SEG', 'seven-seg', 'display', null, 80, 100, '[
  {"id":"e","x":12,"y":94,"voltage":"5V"},
  {"id":"d","x":22,"y":94,"voltage":"5V"},
  {"id":"com","x":38,"y":94,"voltage":"5V"},
  {"id":"c","x":54,"y":94,"voltage":"5V"},
  {"id":"dp","x":68,"y":94,"voltage":"5V"},
  {"id":"b","x":68,"y":6,"voltage":"5V"},
  {"id":"a","x":54,"y":6,"voltage":"5V"},
  {"id":"com2","x":38,"y":6,"voltage":"5V"},
  {"id":"f","x":22,"y":6,"voltage":"5V"},
  {"id":"g","x":12,"y":6,"voltage":"5V"}
]'::jsonb, '[]'::jsonb, '{}');

    -- 1. Ensure Columns Exist
    DO $$ 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='courses' AND column_name='banner_image') THEN
            ALTER TABLE public.courses ADD COLUMN banner_image text;
        END IF;
    END $$;

    -- 2. Cleanup Old Data
    TRUNCATE TABLE public.user_progress CASCADE;
    TRUNCATE TABLE public.certificates CASCADE;
    DELETE FROM public.quiz_questions;
    DELETE FROM public.lessons;
    DELETE FROM public.course_modules;
    DELETE FROM public.courses;
    
    -- 3. Variables for IDs
    DO $$
    DECLARE
        c_id uuid;
        m_id uuid;
        l_id uuid;
    BEGIN
    
        -- Course: Arduino Zero to Hero
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Arduino Zero to Hero', 'arduino-zero-to-hero', 'دورة شاملة من الصفر حتى الاحتراف في برمجة المتحكمات الدقيقة أردوينو.', 'دورة شاملة من الصفر حتى الاحتراف في برمجة المتحكمات الدقيقة أردوينو.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-7c5lej', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-9cddlw', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-1m3ddt', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-9wglo3', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-wz82wr', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-ycdvou', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-yrnj4h', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-m8v5o5', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-i9n2ie', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: ESP32 IoT Masterclass
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('ESP32 IoT Masterclass', 'esp32-iot-masterclass', 'احتراف إنترنت الأشياء باستخدام شريحة ESP32 القوية.', 'احتراف إنترنت الأشياء باستخدام شريحة ESP32 القوية.', 'Advanced', 4900, true, 'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-3sael9', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-86rljs', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-2dzuxg', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-yjrfr2', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-vikmlq', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-bo6pok', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-hnmx26', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-2botqd', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-kicvkg', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Understanding IoT Protocols
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Understanding IoT Protocols', 'iot-protocols', 'فهم عميق لبروتوكولات MQTT, HTTP, CoAP وغيرها.', 'فهم عميق لبروتوكولات MQTT, HTTP, CoAP وغيرها.', 'Intermediate', 0, true, 'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-2tfnsr', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-2ulhzz', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-t34il1', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-wa32t0', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-5rxqhn', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-hwttf5', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-xw44xw', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-d8gi6i', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-8fm2lr', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Circuit Design Fundamentals
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Circuit Design Fundamentals', 'circuit-design', 'أسس تصميم الدوائر الإلكترونية وقراءة المخططات.', 'أسس تصميم الدوائر الإلكترونية وقراءة المخططات.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-hxadcy', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-c1ez13', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-d7imis', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-yxnxza', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-7yjxpt', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-ie1iks', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-z77uz9', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-37thqt', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-o61wkv', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Python for Beginners
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Python for Beginners', 'python-beginners', 'تعلم لغة بايثون من الأساسيات.', 'تعلم لغة بايثون من الأساسيات.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-gnwu94', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-yiv8bf', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-9jfcyf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-jdj6aw', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-xjo7un', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-f2xvgq', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-dxayth', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-xpyffo', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-oi0d9p', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: AI with Python
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('AI with Python', 'ai-python', 'بناء نماذج ذكاء اصطناعي باستخدام بايثون.', 'بناء نماذج ذكاء اصطناعي باستخدام بايثون.', 'Advanced', 9900, true, 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-252hzb', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-wve3xa', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-vmvcb4', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-608kou', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-vvugge', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-w3v7vf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-1l7amq', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-e379e5', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-win0vr', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Computer Vision: Beginner
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Computer Vision: Beginner', 'cv-beginner', 'المدخل إلى معالجة الصور والرؤية الحاسوبية.', 'المدخل إلى معالجة الصور والرؤية الحاسوبية.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1507146153580-69a1fe6d8aa1?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1507146153580-69a1fe6d8aa1?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-x1fwh5', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-2dpqly', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-y5rhx8', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-nbmrny', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-diim4t', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-zux3m9', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-u15fg6', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-kxdvpt', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-rn4aes', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Computer Vision: Intermediate
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Computer Vision: Intermediate', 'cv-intermediate', 'خوارزميات كشف الكائنات والوجه.', 'خوارزميات كشف الكائنات والوجه.', 'Intermediate', 5900, true, 'https://images.unsplash.com/photo-1555255707-c07966088b7b?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1555255707-c07966088b7b?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-kpjrr8', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-78yn5b', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-x0qr9h', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-myev87', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-eumx21', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-sfx8lf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-emese6', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-hjxwdu', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-5mcamx', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Computer Vision: Advanced
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Computer Vision: Advanced', 'cv-advanced', 'الشبكات العصبية العميقة للرؤية الحاسوبية.', 'الشبكات العصبية العميقة للرؤية الحاسوبية.', 'Advanced', 12000, true, 'https://images.unsplash.com/photo-1527430253228-e93688616381?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1527430253228-e93688616381?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-jos5a8', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-1zcskv', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-s4vipe', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-0fxkaf', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-4sg623', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-e2yaum', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-0fyqim', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-crli0c', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-onlbbj', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Prompt Engineering Mastery
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Prompt Engineering Mastery', 'prompt-engineering', 'كيفية التحدث مع الذكاء الاصطناعي للحصول على أفضل النتائج.', 'كيفية التحدث مع الذكاء الاصطناعي للحصول على أفضل النتائج.', 'Intermediate', 3900, true, 'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-q1c2si', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-h0xef8', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-grqc70', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-tj3zvj', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-ybpvr7', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-eypzlb', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-wx91u5', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-3ldib2', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-ocjf6g', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
END $$;
    -- CLEANUP (Reset products to avoid duplicates)
    TRUNCATE TABLE public.product_purchases CASCADE;
    DELETE FROM public.products;
    
    -- INSERT PRODUCTS
    
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Edge-AI Voice Command Controller', 
            'edge-ai-voice-command-controller-vfaf', 
            'لوحة مدمجة تعتمد على ESP32 وميكروفون I2S MEMS. تتيح التعرف على الأوامر الصوتية محلياً باستخدام TensorFlow Lite Micro دون الحاجة للإنترنت. مثالية للتحكم في المنزل الذكي.', 
            2500, 
            'https://images.unsplash.com/photo-1589254065878-42c9da997008?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Based Image Detection Sensor', 
            'ai-based-image-detection-sensor-rtez', 
            'نظام رؤية حاسوبية منخفض الدقة باستخدام ESP32-S3 وكاميرا. يكتشف الحركة والإيماءات والأشخاص محلياً. ممتاز لأنظمة الحضور والأمن الذكي.', 
            3000, 
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Predictive Maintenance Sensor Node', 
            'predictive-maintenance-sensor-node-nysp', 
            'PCB يدمج ESP32 مع مقياس تسارع للكشف عن شذوذ الاهتزازات في المحركات والمضخات باستخدام الذكاء الاصطناعي. يمنع الأعطال قبل حدوثها.', 
            4500, 
            'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Smart Energy Usage Classifier', 
            'smart-energy-usage-classifier-fggp', 
            'راقب استهلاك الطاقة بذكاء. يستخدم ESP32 وحساسات التيار لتحديد نوع الجهاز المشغل بناءً على بصمة استهلاكه الكهربائي.', 
            2000, 
            'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Powered Environmental Monitor', 
            'ai-powered-environmental-monitor-bksk', 
            'راقب جودة الهواء (CO2, PM2.5) وتوقع الاتجاهات البيئية باستخدام نماذج ML مدمجة. مثالي للمباني الخضراء والمدارس.', 
            3500, 
            'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Assisted Smart Door Lock', 
            'ai-assisted-smart-door-lock-lpwn', 
            'قفل ذكي متكامل (لوحة مفاتيح، بصمة، NFC) يتعلم أنماط الاستخدام ليقوم بالقفل التلقائي بذكاء وتوفير أمان تكيفي.', 
            4000, 
            'https://images.unsplash.com/photo-1558002038-1091a16627a3?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'License-Plate Edge Detector', 
            'license-plate-edge-detector-phwv', 
            'نظام خفيف جداً للتعرف على لوحات السيارات ورموز QR باستخدام ESP32-S3. حل مثالي ومنخفض التكلفة لمواقف السيارات والبوابات.', 
            5000, 
            'https://images.unsplash.com/photo-1597733336794-12d05021d510?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Intelligent Classroom Sensor Hub', 
            'intelligent-classroom-sensor-hub-jgap', 
            'محطة استشعار للفصول الذكية تقيس الحضور، ومستوى الضوضاء، وجودة الهواء لتهيئة بيئة تعليمية مثالية تلقائياً.', 
            3500, 
            'https://images.unsplash.com/photo-1509062522246-37559cc792f9?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Smart Agriculture Node', 
            'smart-agriculture-node-phgt', 
            'عقدة زراعية ذكية تتنبأ باحتياجات الري بناءً على رطوبة التربة والعوامل الجوية باستخدام خوارزميات تعلم الآلة.', 
            2800, 
            'https://images.unsplash.com/photo-1530836369250-ef720383e600?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Based Traffic Counter', 
            'ai-based-traffic-counter-iaqu', 
            'محلل حركة مرور باستخدام ESP32-CAM. يميز بين السيارات والدراجات والمشاة للمساعدة في تخطيط المدن الذكية.', 
            3200, 
            'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Gesture-Control Pad', 
            'gesture-control-pad-qtoy', 
            'لوحة تحكم بالإيماءات تعتمد على حساس APDS-9960 ونماذج ML لتصنيف حركات اليد المخصصة. رائعة للألعاب والأجهزة التفاعلية.', 
            2200, 
            'https://images.unsplash.com/photo-1616469829941-c7200edec809?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Powered Sound Classifier', 
            'ai-powered-sound-classifier-oyna', 
            'جهاز استماع ذكي يصنف الأصوات المحيطة (مثل تكسر الزجاج، بكاء الطفل، نباح الكلب) ويرسل تنبيهات فورية.', 
            2900, 
            'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Occupancy Radar Detector', 
            'occupancy-radar-detector-hbzd', 
            'كاشف حضور فائق الدقة باستخدام رادار mmWave والذكاء الاصطناعي للتنبؤ بأنماط الإشغال وتحسين الإضاءة والتكييف.', 
            4200, 
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Driven Smart Relay Board', 
            'ai-driven-smart-relay-board-mpaj', 
            'لوحة تحكم بـ 16 مرحل (Relay) تتنبأ بمواعيد التشغيل والإيقاف المثلى للأحمال الكهربائية بناءً على البيانات التاريخية.', 
            3800, 
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI Audio Control for Mosques', 
            'ai-audio-control-for-mosques-jmlj', 
            'نظام ذكي لإدارة الصوتيات في المساجد والقاعات. يضبط مستويات الصوت تلقائياً بناءً على الضجيج المحيط وعدد الحضور.', 
            5500, 
            'https://images.unsplash.com/photo-1564121211835-e88c852648ab?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Predictive Water Tank Controller', 
            'ai-predictive-water-tank-controller-bryc', 
            'وحدة تحكم في المضخات تتنبأ بمعدلات استهلاك المياه وجداول الملء التلقائي لضمان توفر المياه وكفاءة الطاقة.', 
            2400, 
            'https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI Camera Trap for Wildlife', 
            'ai-camera-trap-for-wildlife-zlac', 
            'كاميرا ذكية للمحميات والمزارع تعمل بـ ESP32. تميز بين الحيوانات والبشر لتقليل الإنذارات الكاذبة.', 
            3100, 
            'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Smart Inventory Shelf', 
            'smart-inventory-shelf-ciiz', 
            'رف ذكي مزود بخلايا وزن (Load Cells) يتنبأ بنفاذ المخزون ويرسل طلبات إعادة التعبئة تلقائياً.', 
            4600, 
            'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Motion for Physiotherapy', 
            'ai-motion-for-physiotherapy-ziqp', 
            'جهاز قابل للارتداء يصنف التمارين الرياضية ويعد التكرارات بدقة باستخدام حساسات IMU ونماذج تعلم الآلة.', 
            3300, 
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Edge Safety System', 
            'ai-edge-safety-system-wckq', 
            'نظام أمان للورش والمصانع يكتشف الأحداث الخطرة (سقوط، تشغيل مفاجئ للآلات) باستخدام الصوت والاهتزاز.', 
            4800, 
            'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
    -- CLEANUP
    TRUNCATE TABLE public.comments CASCADE;
    DELETE FROM public.blog_posts;

    -- INSERT POSTS
    
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'البداية مع الأردوينو: وميض LED',
            'arduino-blink',
            'تعلم كل ما يخص البداية مع الأردوينو: وميض LED في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>البداية مع الأردوينو: وميض LED</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-01 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استخدام الزر الانضغاطي مع الأردوينو',
            'arduino-button',
            'تعلم كل ما يخص استخدام الزر الانضغاطي مع الأردوينو في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استخدام الزر الانضغاطي مع الأردوينو</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-02 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قراءة الجهد المتغير (Potentiometer)',
            'arduino-potentiometer',
            'تعلم كل ما يخص قراءة الجهد المتغير (Potentiometer) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قراءة الجهد المتغير (Potentiometer)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-03 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في سطوع LED باستخدام PWM',
            'arduino-pwm',
            'تعلم كل ما يخص التحكم في سطوع LED باستخدام PWM في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في سطوع LED باستخدام PWM</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-04 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في ألوان RGB LED',
            'arduino-rgb',
            'تعلم كل ما يخص التحكم في ألوان RGB LED في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في ألوان RGB LED</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-05 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قياس الحرارة والرطوبة بـ DHT11',
            'arduino-dht11',
            'تعلم كل ما يخص قياس الحرارة والرطوبة بـ DHT11 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قياس الحرارة والرطوبة بـ DHT11</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-06 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قياس المسافة بحساس الموجات فوق الصوتية',
            'arduino-ultrasonic',
            'تعلم كل ما يخص قياس المسافة بحساس الموجات فوق الصوتية في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قياس المسافة بحساس الموجات فوق الصوتية</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-07 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'كشف الحركة باستخدام حساس PIR',
            'arduino-pir',
            'تعلم كل ما يخص كشف الحركة باستخدام حساس PIR في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>كشف الحركة باستخدام حساس PIR</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-08 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'نظام الإضاءة التلقائي باستخدام LDR',
            'arduino-ldr',
            'تعلم كل ما يخص نظام الإضاءة التلقائي باستخدام LDR في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>نظام الإضاءة التلقائي باستخدام LDR</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-09 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استشعار الصوت باستخدام الميكروفون',
            'arduino-sound',
            'تعلم كل ما يخص استشعار الصوت باستخدام الميكروفون في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استشعار الصوت باستخدام الميكروفون</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-10 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قياس رطوبة التربة للزراعة الذكية',
            'arduino-soil',
            'تعلم كل ما يخص قياس رطوبة التربة للزراعة الذكية في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قياس رطوبة التربة للزراعة الذكية</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-11 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'كشف المطر باستخدام حساس Rain Sensor',
            'arduino-rain',
            'تعلم كل ما يخص كشف المطر باستخدام حساس Rain Sensor في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>كشف المطر باستخدام حساس Rain Sensor</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-12 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استخدام حساس الميل (Tilt Switch)',
            'arduino-tilt',
            'تعلم كل ما يخص استخدام حساس الميل (Tilt Switch) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استخدام حساس الميل (Tilt Switch)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-13 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'حساس الحرارة التماثلي LM35',
            'arduino-lm35',
            'تعلم كل ما يخص حساس الحرارة التماثلي LM35 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>حساس الحرارة التماثلي LM35</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-14 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'عرض النصوص على شاشة LCD 16x2',
            'arduino-lcd',
            'تعلم كل ما يخص عرض النصوص على شاشة LCD 16x2 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>عرض النصوص على شاشة LCD 16x2</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Displays</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-15 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'الرسومات المتقدمة على شاشة OLED',
            'arduino-oled',
            'تعلم كل ما يخص الرسومات المتقدمة على شاشة OLED في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>الرسومات المتقدمة على شاشة OLED</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Displays</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-16 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'العد التنازلي باستخدام 7-Segment',
            'arduino-7segment',
            'تعلم كل ما يخص العد التنازلي باستخدام 7-Segment في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>العد التنازلي باستخدام 7-Segment</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Displays</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-17 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم الدقيق بمحرك سيرفو',
            'arduino-servo',
            'تعلم كل ما يخص التحكم الدقيق بمحرك سيرفو في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم الدقيق بمحرك سيرفو</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Motors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-18 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في سرعة واتجاه محرك DC',
            'arduino-dc-motor',
            'تعلم كل ما يخص التحكم في سرعة واتجاه محرك DC في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في سرعة واتجاه محرك DC</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Motors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-19 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'دقة الحركة مع المحركات الخطوية (Stepper)',
            'arduino-stepper',
            'تعلم كل ما يخص دقة الحركة مع المحركات الخطوية (Stepper) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>دقة الحركة مع المحركات الخطوية (Stepper)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Motors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-20 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'لوحة المفاتيح الرقمية (Keypad 4x4)',
            'arduino-keypad',
            'تعلم كل ما يخص لوحة المفاتيح الرقمية (Keypad 4x4) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>لوحة المفاتيح الرقمية (Keypad 4x4)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-21 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم بالألعاب باستخدام Joystick',
            'arduino-joystick',
            'تعلم كل ما يخص التحكم بالألعاب باستخدام Joystick في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم بالألعاب باستخدام Joystick</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-22 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'أنظمة الأمان باستخدام بطاقات RFID',
            'arduino-rfid',
            'تعلم كل ما يخص أنظمة الأمان باستخدام بطاقات RFID في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>أنظمة الأمان باستخدام بطاقات RFID</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-23 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'توليد النغمات والموسيقى (Piezo Buzzer)',
            'arduino-buzzer',
            'تعلم كل ما يخص توليد النغمات والموسيقى (Piezo Buzzer) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>توليد النغمات والموسيقى (Piezo Buzzer)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-24 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في الأجهزة المنزلية باستخدام Relay',
            'arduino-relay',
            'تعلم كل ما يخص التحكم في الأجهزة المنزلية باستخدام Relay في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في الأجهزة المنزلية باستخدام Relay</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-25 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'مقدمة إلى شريحة ESP32 الخارقة',
            'esp32-intro',
            'تعلم كل ما يخص مقدمة إلى شريحة ESP32 الخارقة في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>مقدمة إلى شريحة ESP32 الخارقة</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-26 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'بناء خادم ويب للتحكم عبر الواي فاي',
            'esp32-web-server',
            'تعلم كل ما يخص بناء خادم ويب للتحكم عبر الواي فاي في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>بناء خادم ويب للتحكم عبر الواي فاي</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-27 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'ربط ESP32 بشبكة المنزل (Station Mode)',
            'esp32-station-mode',
            'تعلم كل ما يخص ربط ESP32 بشبكة المنزل (Station Mode) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>ربط ESP32 بشبكة المنزل (Station Mode)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-28 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'جعل ESP32 نقطة اتصال (Access Point)',
            'esp32-access-point',
            'تعلم كل ما يخص جعل ESP32 نقطة اتصال (Access Point) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>جعل ESP32 نقطة اتصال (Access Point)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-29 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم عبر البلوتوث (Bluetooth Classic)',
            'esp32-bluetooth',
            'تعلم كل ما يخص التحكم عبر البلوتوث (Bluetooth Classic) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم عبر البلوتوث (Bluetooth Classic)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-30 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تقنية البلوتوث منخفض الطاقة (BLE)',
            'esp32-ble',
            'تعلم كل ما يخص تقنية البلوتوث منخفض الطاقة (BLE) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تقنية البلوتوث منخفض الطاقة (BLE)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-31 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استخدام دبابيس اللمس (Touch Pins)',
            'esp32-touch',
            'تعلم كل ما يخص استخدام دبابيس اللمس (Touch Pins) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استخدام دبابيس اللمس (Touch Pins)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-01 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'مستشعر المجال المغناطيسي المدمج',
            'esp32-hall-effect',
            'تعلم كل ما يخص مستشعر المجال المغناطيسي المدمج في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>مستشعر المجال المغناطيسي المدمج</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-02 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'توفير الطاقة باستخدام وضع النوم العميق',
            'esp32-deep-sleep',
            'تعلم كل ما يخص توفير الطاقة باستخدام وضع النوم العميق في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>توفير الطاقة باستخدام وضع النوم العميق</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-03 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'حفظ البيانات في الذاكرة الدائمة (Preferences)',
            'esp32-preferences',
            'تعلم كل ما يخص حفظ البيانات في الذاكرة الدائمة (Preferences) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>حفظ البيانات في الذاكرة الدائمة (Preferences)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-04 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'نظام الملفات SPIFFS في ESP32',
            'esp32-spiffs',
            'تعلم كل ما يخص نظام الملفات SPIFFS في ESP32 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>نظام الملفات SPIFFS في ESP32</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-05 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'بروتوكول MQTT لإنترنت الأشياء',
            'esp32-mqtt',
            'تعلم كل ما يخص بروتوكول MQTT لإنترنت الأشياء في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>بروتوكول MQTT لإنترنت الأشياء</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-06 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'إرسال رسائل تنبيه إلى تيليجرام',
            'esp32-telegram',
            'تعلم كل ما يخص إرسال رسائل تنبيه إلى تيليجرام في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>إرسال رسائل تنبيه إلى تيليجرام</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-07 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'إرسال بريد إلكتروني عند كشف الحركة',
            'esp32-email',
            'تعلم كل ما يخص إرسال بريد إلكتروني عند كشف الحركة في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>إرسال بريد إلكتروني عند كشف الحركة</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-08 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'رسم المخططات البيانية لحظياً على الويب',
            'esp32-web-plotter',
            'تعلم كل ما يخص رسم المخططات البيانية لحظياً على الويب في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>رسم المخططات البيانية لحظياً على الويب</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-09 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تحديث الكود عن بعد (OTA Updates)',
            'esp32-ota',
            'تعلم كل ما يخص تحديث الكود عن بعد (OTA Updates) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تحديث الكود عن بعد (OTA Updates)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-10 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'بث الفيديو باستخدام ESP32-CAM',
            'esp32-cam',
            'تعلم كل ما يخص بث الفيديو باستخدام ESP32-CAM في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>بث الفيديو باستخدام ESP32-CAM</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-11 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'فهم المقاطعات (Interrupts) في الأردوينو',
            'arduino-interrupts',
            'تعلم كل ما يخص فهم المقاطعات (Interrupts) في الأردوينو في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>فهم المقاطعات (Interrupts) في الأردوينو</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Advanced</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-12 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تعدد المهام باستخدام millis()',
            'arduino-millis',
            'تعلم كل ما يخص تعدد المهام باستخدام millis() في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تعدد المهام باستخدام millis()</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Advanced</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-13 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تخزين الإعدادات في EEPROM',
            'arduino-eeprom',
            'تعلم كل ما يخص تخزين الإعدادات في EEPROM في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تخزين الإعدادات في EEPROM</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Advanced</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-14 22:36:10'
        );
        
-- 2. Add Cover Image Column to Blog Posts if missing
do $$ 
begin
    if not exists (select 1 from information_schema.columns where table_name='blog_posts' and column_name='cover_image') then
        alter table public.blog_posts add column cover_image text;
    end if;
end $$;

-- 3. Clear existing posts to avoid duplicates during testing
truncate table public.comments;
delete from public.blog_posts;

-- 4. Insert Arabic Blog Posts (Inspired by Random Nerd Tutorials)

-- Post 1: ESP32 Web Server
insert into public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
values (
  'إنشاء خادم ويب للتحكم في المخرجات باستخدام ESP32',
  'esp32-web-server-arabic',
  'تعلم كيفية بناء خادم ويب بسيط باستخدام لوحة ESP32 للتحكم في مصابيح LED عن بُعد عبر شبكة الواي فاي.',
  'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
  '
  <h2>المقدمة</h2>
  <p>في هذا الدرس التعليمي، سنقوم بإنشاء خادم ويب مستقل باستخدام لوحة ESP32 للتحكم في المخرجات (مثل مصابيح LED) عبر أي جهاز متصل بالشبكة المحلية.</p>
  
  <img src="https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80" alt="ESP32" class="rounded-lg my-4 w-full object-cover h-64"/>

  <h3>الأدوات المطلوبة:</h3>
  <ul class="list-disc list-inside mb-4">
    <li>لوحة ESP32 Development Board</li>
    <li>2x مصابيح LED (أحمر وأخضر)</li>
    <li>2x مقاومات 220 أوم</li>
    <li>لوحة تجارب (Breadboard) وأسلاك توصيل</li>
  </ul>

  <h3>الدائرة الكهربائية</h3>
  <p>قم بتوصيل مصابيح LED بالأرجل رقم 26 و 27 في لوحة ESP32. تأكد من توصيل المقاومات على التوالي لحماية المصابيح.</p>

  <h3>الكود البرمجي</h3>
  <pre class="bg-gray-900 text-gray-100 p-4 rounded overflow-x-auto">
#include <WiFi.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

WiFiServer server(80);

void setup() {
  Serial.begin(115200);
  pinMode(26, OUTPUT);
  pinMode(27, OUTPUT);
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  server.begin();
}

void loop() {
  // logic code here
}
  </pre>
  <p>بعد رفع الكود، افتح الشاشة التسلسلية (Serial Monitor) لمعرفة عنوان IP الخاص بـ ESP32، ثم افتحه في المتصفح.</p>
  ',
  true,
  now()
);

-- Post 2: DHT11/DHT22 Web Server
insert into public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
values (
  'قراءة درجة الحرارة والرطوبة وعرضها على الويب باستخدام ESP32',
  'esp32-dht11-dht22-web-server',
  'مشروع متكامل لبناء محطة أرصاد جوية مصغرة باستخدام مستشعر DHT وعرض البيانات لحظياً.',
  'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
  '
  <h2>نظرة عامة</h2>
  <p>يعد مستشعر DHT11 أو DHT22 من أشهر المستشعرات لقياس الرطوبة ودرجة الحرارة. سنقوم بربطه مع ESP32 وعرض القراءات على واجهة ويب جذابة.</p>

  <h3>المكونات:</h3>
  <ul class="list-disc list-inside mb-4">
    <li>ESP32</li>
    <li>مستشعر DHT11 أو DHT22</li>
    <li>مقاومة 4.7k أوم</li>
  </ul>

  <h3>طريقة العمل</h3>
  <p>يستخدم المستشعر بروتوكول اتصال خاص بسلك واحد. سنستخدم مكتبة <code>DHT.h</code> لقراءة البيانات.</p>
  
  <div class="bg-blue-50 p-4 border-l-4 border-blue-500 my-4">
    <strong>ملاحظة:</strong> مستشعر DHT22 أكثر دقة من DHT11، ولكنه أغلى قليلاً. الكود يعمل مع الاثنين بتغيير بسيط.
  </div>

  <h3>تحديث صفحة الويب تلقائياً</h3>
  <p>لجعل الصفحة تعرض درجات الحرارة الجديدة دون الحاجة لتحديث الصفحة يدوياً، سنستخدم تقنية AJAX في كود HTML/JavaScript المضمن داخل الأردوينو.</p>
  ',
  true,
  now()
);

-- Post 3: PWM LED Control
insert into public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
values (
  'التحكم في سطوع LED باستخدام تقنية PWM في الأردوينو',
  'arduino-pwm-led-control',
  'دليل للمبتدئين لفهم إشارات التماثلية (Analog) وكيفية محاكاتها باستخدام PWM للتحكم في الإضاءة.',
  'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
  '
  <h2>ما هو PWM؟</h2>
  <p>تقنية تعديل عرض النبضة (Pulse Width Modulation) هي طريقة للحصول على نتائج تماثلية (Analog) باستخدام وسائل رقمية (Digital). من خلال تشغيل وإيقاف الإشارة بسرعة كبيرة، يمكننا التحكم في كمية الطاقة المرسلة إلى LED.</p>

  <img src="https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80" alt="Arduino Board" class="rounded-lg my-4 w-full object-cover h-64"/>

  <h3>التطبيق العملي</h3>
  <p>سنستخدم الدالة <code>analogWrite()</code> في بيئة Arduino IDE. هذه الدالة تأخذ قيماً من 0 (مطفأ تماماً) إلى 255 (إضاءة كاملة).</p>

  <h3>الكود: تأثير التنفس (Fading)</h3>
  <pre class="bg-gray-900 text-gray-100 p-4 rounded overflow-x-auto">
int ledPin = 9;    // LED connected to digital pin 9

void setup() {
  // nothing happens in setup
}

void loop() {
  // fade in from min to max in increments of 5 points:
  for (int fadeValue = 0 ; fadeValue <= 255; fadeValue += 5) {
    analogWrite(ledPin, fadeValue);
    delay(30);
  }

  // fade out from max to min in increments of 5 points:
  for (int fadeValue = 255 ; fadeValue >= 0; fadeValue -= 5) {
    analogWrite(ledPin, fadeValue);
    delay(30);
  }
}
  </pre>
  ',
  true,
  now()
);
