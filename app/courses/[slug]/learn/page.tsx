import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';
import CoursePlayer from './CoursePlayer';

export default async function CourseLearnPage({ params }: { params: { slug: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) redirect('/auth/signin');

  // 1. Fetch Course & Modules & Lessons
  const { data: course } = await supabase
    .from('courses')
    .select(`
        id, 
        title, 
        slug,
        course_modules (
            id, 
            title, 
            order_index,
            lessons (
                id, 
                title, 
                type, 
                content, 
                video_url, 
                duration,
                order_index,
                quiz_questions (id, question, options, correct_index)
            )
        )
    `)
    .eq('slug', params.slug)
    .single();

  if (!course) redirect('/courses');

  // 2. Verify Enrollment
  const { data: enrollment } = await supabase
    .from('course_enrollments')
    .select('id')
    .eq('user_id', user.id)
    .eq('course_id', course.id)
    .single();

  if (!enrollment) redirect(`/courses/${params.slug}`); // Redirect to sales page if not enrolled

  // 3. Fetch User Progress
  const { data: progress } = await supabase
    .from('user_progress')
    .select('*')
    .eq('user_id', user.id);

  // Sort data
  const modules = course.course_modules.sort((a:any, b:any) => a.order_index - b.order_index);
  modules.forEach((m: any) => m.lessons.sort((a:any, b:any) => a.order_index - b.order_index));

  return (
    <CoursePlayer 
        course={course} 
        modules={modules} 
        progress={progress || []} 
        userProfile={user}
    />
  );
}
