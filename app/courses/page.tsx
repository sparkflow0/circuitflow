import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import Link from 'next/link';
import { formatCurrency } from '@/lib/utils';
import { BookOpen, BarChart, Clock } from 'lucide-react';

export default async function CoursesPage() {
  const supabase = createClient();
  const { data: courses } = await supabase
    .from('courses')
    .select('*')
    .eq('is_published', true);

  return (
    <div className="min-h-screen bg-slate-50" dir="rtl">
      <Navbar />
      <div className="container mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-2 text-slate-900">الدورات المتاحة</h1>
        <p className="text-slate-500 mb-8">استكشف مسارات التعلم الاحترافية</p>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {courses?.map((course) => (
            <Link key={course.id} href={`/courses/${course.slug}`} className="group block bg-white rounded-2xl border border-slate-200 overflow-hidden hover:shadow-xl transition-all hover:-translate-y-1">
              {/* Image */}
              <div className="h-48 bg-slate-200 relative overflow-hidden">
                 {course.cover_image ? (
                    <img src={course.cover_image} alt={course.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                 ) : (
                    <div className="w-full h-full flex items-center justify-center text-slate-400">No Image</div>
                 )}
                 <div className="absolute top-3 right-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-xs font-bold text-blue-600">
                    {course.level}
                 </div>
              </div>

              <div className="p-6">
                <h3 className="font-bold text-xl mb-3 text-slate-800 group-hover:text-blue-600 transition-colors">{course.title}</h3>
                <p className="text-slate-600 text-sm mb-6 line-clamp-2 leading-relaxed">{course.short_description}</p>
                
                <div className="flex justify-between items-center border-t border-slate-100 pt-4">
                  <div className="flex items-center gap-4 text-slate-400 text-xs">
                      <span className="flex items-center gap-1"><BookOpen size={14}/> 9 دروس</span>
                      <span className="flex items-center gap-1"><Clock size={14}/> 2 ساعة</span>
                  </div>
                  <span className={`font-bold text-lg ${course.price === 0 ? 'text-green-600' : 'text-blue-600'}`}>
                    {course.price === 0 ? 'مجاني' : formatCurrency(course.price)}
                  </span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
