
-- Update Courses Table
alter table public.courses add column if not exists cover_image text;

-- Create Modules Table (Accordion Sections)
create table if not exists public.course_modules (
  id uuid default uuid_generate_v4() primary key,
  course_id uuid references public.courses(id) on delete cascade not null,
  title text not null,
  order_index integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Update Lessons Table (Link to Modules + New Fields)
alter table public.lessons add column if not exists module_id uuid references public.course_modules(id) on delete cascade;
alter table public.lessons add column if not exists type text check (type in ('video', 'text', 'quiz')) default 'text';
alter table public.lessons add column if not exists duration integer; -- minutes

-- Create Quizzes Table
create table if not exists public.quiz_questions (
  id uuid default uuid_generate_v4() primary key,
  lesson_id uuid references public.lessons(id) on delete cascade not null,
  question text not null,
  options jsonb not null, -- Array of strings
  correct_index integer not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create User Progress Table
create table if not exists public.user_progress (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  lesson_id uuid references public.lessons(id) on delete cascade not null,
  is_completed boolean default false,
  quiz_score integer, -- Percentage
  completed_at timestamp with time zone,
  unique(user_id, lesson_id)
);

-- Create Certificates Table
create table if not exists public.certificates (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  course_id uuid references public.courses(id) on delete cascade not null,
  issued_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, course_id)
);

-- RLS Updates
alter table course_modules enable row level security;
alter table quiz_questions enable row level security;
alter table user_progress enable row level security;
alter table certificates enable row level security;

create policy "Public read modules" on course_modules for select using (true);
create policy "Public read quiz questions" on quiz_questions for select using (true);

create policy "Users manage own progress" on user_progress for all using (auth.uid() = user_id);
create policy "Users view own certificates" on certificates for select using (auth.uid() = user_id);
