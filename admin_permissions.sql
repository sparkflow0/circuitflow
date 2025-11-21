
-- Allow Admins to ALL operations on Courses
create policy "Admins can all courses" 
on public.courses for all 
using ( exists (select 1 from profiles where id = auth.uid() and role = 'admin') );

-- Allow Admins to ALL operations on Products
create policy "Admins can all products" 
on public.products for all 
using ( exists (select 1 from profiles where id = auth.uid() and role = 'admin') );

-- Allow Admins to ALL operations on Blog Posts
create policy "Admins can all blog_posts" 
on public.blog_posts for all 
using ( exists (select 1 from profiles where id = auth.uid() and role = 'admin') );

-- Allow Admins to ALL operations on Modules/Lessons
create policy "Admins can all modules" 
on public.course_modules for all 
using ( exists (select 1 from profiles where id = auth.uid() and role = 'admin') );

create policy "Admins can all lessons" 
on public.lessons for all 
using ( exists (select 1 from profiles where id = auth.uid() and role = 'admin') );
