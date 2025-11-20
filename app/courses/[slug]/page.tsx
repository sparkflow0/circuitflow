import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import { Button } from '@/components/ui/Button';
import { notFound } from 'next/navigation';
import EnrollButton from './EnrollButton'; // Client component for Stripe call

export default async function CourseDetail({ params }: { params: { slug: string } }) {
  const supabase = createClient();
  const { data: course } = await supabase
    .from('courses')
    .select('*, lessons(id, title, is_free_preview)')
    .eq('slug', params.slug)
    .single();

  if (!course) notFound();

  const { data: { user } } = await supabase.auth.getUser();
  
  // Check if enrolled
  let isEnrolled = false;
  if (user) {
    const { data: enrollment } = await supabase
      .from('course_enrollments')
      .select('id')
      .eq('user_id', user.id)
      .eq('course_id', course.id)
      .single();
    isEnrolled = !!enrollment;
  }

  return (
    <div className="min-h-screen bg-white">
      <Navbar />
      <div className="bg-slate-900 text-white py-16 px-4">
        <div className="container mx-auto max-w-4xl">
          <h1 className="text-4xl font-bold mb-4">{course.title}</h1>
          <p className="text-slate-300 text-lg mb-8">{course.short_description}</p>
          
          {isEnrolled ? (
            <Button size="lg" className="bg-green-600 hover:bg-green-500">Continue Learning</Button>
          ) : (
             <EnrollButton courseId={course.id} price={course.price} />
          )}
        </div>
      </div>

      <div className="container mx-auto px-4 py-12 grid md:grid-cols-3 gap-12">
        <div className="md:col-span-2">
          <h2 className="text-2xl font-bold mb-4">About this course</h2>
          <div className="prose max-w-none text-slate-600">
            {course.full_description || 'No description available.'}
          </div>

          <h2 className="text-2xl font-bold mt-12 mb-4">Curriculum</h2>
          <ul className="border border-slate-200 rounded-lg divide-y">
            {course.lessons?.map((lesson: any) => (
              <li key={lesson.id} className="p-4 flex items-center justify-between hover:bg-slate-50">
                <span className="flex items-center gap-3">
                  <span className="text-slate-400 text-sm">Lesson</span>
                  {lesson.title}
                </span>
                {lesson.is_free_preview && !isEnrolled && (
                  <span className="text-xs bg-green-100 text-green-700 px-2 py-1 rounded">Free Preview</span>
                )}
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}
