import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import { Button } from '@/components/ui/Button';
import { notFound } from 'next/navigation';
import EnrollButton from './EnrollButton'; 
import { PlayCircle, CheckCircle, Lock } from 'lucide-react';

export default async function CourseDetail({ params }: { params: { slug: string } }) {
  const supabase = createClient();
  const { data: course } = await supabase
    .from('courses')
    .select('*, lessons(id, title, is_free_preview)')
    .eq('slug', params.slug)
    .single();

  if (!course) notFound();

  const { data: { user } } = await supabase.auth.getUser();
  
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
    <div className="min-h-screen bg-white" dir="rtl">
      <Navbar />
      
      {/* Hero Banner */}
      <div className="relative bg-slate-900 h-[400px] flex items-center">
         {course.banner_image && (
             <>
               <img src={course.banner_image} alt={course.title} className="absolute inset-0 w-full h-full object-cover opacity-40"/>
               <div className="absolute inset-0 bg-gradient-to-t from-slate-900 via-transparent to-transparent"></div>
             </>
         )}
         <div className="container mx-auto px-4 relative z-10">
             <div className="max-w-3xl">
                <span className="inline-block px-3 py-1 rounded-full bg-blue-500/20 text-blue-300 border border-blue-500/30 text-sm font-bold mb-4 backdrop-blur-sm">
                    {course.level}
                </span>
                <h1 className="text-5xl font-extrabold text-white mb-6 leading-tight shadow-black drop-shadow-lg">{course.title}</h1>
                <p className="text-slate-200 text-lg mb-8 leading-relaxed max-w-2xl drop-shadow-md">{course.short_description}</p>
                
                {isEnrolled ? (
                    <Button size="lg" className="bg-green-600 hover:bg-green-500 text-lg px-8 py-6 h-auto">متابعة التعلم</Button>
                ) : (
                    <EnrollButton courseId={course.id} price={course.price} />
                )}
             </div>
         </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-4 py-16 grid lg:grid-cols-3 gap-12">
        <div className="lg:col-span-2">
          <h2 className="text-2xl font-bold mb-6 text-slate-900 border-r-4 border-blue-500 pr-4">عن الدورة</h2>
          <div className="prose prose-lg max-w-none text-slate-600 leading-loose">
            {course.full_description || 'No description available.'}
          </div>

          <h2 className="text-2xl font-bold mt-16 mb-6 text-slate-900 border-r-4 border-green-500 pr-4">المنهج الدراسي</h2>
          <div className="border border-slate-200 rounded-xl overflow-hidden bg-white shadow-sm">
            {course.lessons?.map((lesson: any, i: number) => (
              <div key={lesson.id} className="p-5 flex items-center justify-between hover:bg-slate-50 border-b border-slate-100 last:border-0 transition-colors">
                <div className="flex items-center gap-4">
                  <span className="flex items-center justify-center w-8 h-8 rounded-full bg-slate-100 text-slate-500 text-sm font-bold">
                    {i + 1}
                  </span>
                  <span className="font-medium text-slate-700">{lesson.title}</span>
                </div>
                {lesson.is_free_preview && !isEnrolled ? (
                  <span className="text-xs bg-green-100 text-green-700 px-3 py-1 rounded-full font-bold">معاينة مجانية</span>
                ) : (
                  <Lock size={16} className="text-slate-300"/>
                )}
              </div>
            ))}
          </div>
        </div>
        
        {/* Sidebar Info */}
        <div>
            <div className="bg-slate-50 p-6 rounded-2xl border border-slate-200 sticky top-24">
                <h3 className="font-bold text-lg mb-4">تفاصيل الدورة</h3>
                <ul className="space-y-3 text-sm text-slate-600">
                    <li className="flex justify-between">
                        <span>المستوى:</span>
                        <span className="font-bold text-slate-900">{course.level}</span>
                    </li>
                    <li className="flex justify-between">
                        <span>الدروس:</span>
                        <span className="font-bold text-slate-900">{course.lessons?.length || 0}</span>
                    </li>
                    <li className="flex justify-between">
                        <span>اللغة:</span>
                        <span className="font-bold text-slate-900">العربية</span>
                    </li>
                </ul>
            </div>
        </div>
      </div>
    </div>
  );
}
