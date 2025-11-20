import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import Link from 'next/link';
import { formatCurrency } from '@/lib/utils';

export default async function CoursesPage() {
  const supabase = createClient();
  const { data: courses } = await supabase
    .from('courses')
    .select('*')
    .eq('is_published', true);

  return (
    <div className="min-h-screen bg-slate-50">
      <Navbar />
      <div className="container mx-auto px-4 py-12">
        <h1 className="text-3xl font-bold mb-8">Available Courses</h1>
        <div className="grid md:grid-cols-3 gap-6">
          {courses?.map((course) => (
            <Link key={course.id} href={`/courses/${course.slug}`} className="block group">
              <div className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm transition-all group-hover:shadow-md">
                <div className="h-40 bg-slate-200 flex items-center justify-center text-slate-400">
                  Course Image
                </div>
                <div className="p-6">
                  <h3 className="font-bold text-lg mb-2 group-hover:text-blue-600">{course.title}</h3>
                  <p className="text-slate-600 text-sm mb-4 line-clamp-2">{course.short_description}</p>
                  <div className="flex justify-between items-center">
                    <span className="text-xs font-semibold px-2 py-1 bg-slate-100 rounded text-slate-600">
                      {course.level}
                    </span>
                    <span className="font-bold text-green-600">
                      {course.price === 0 ? 'Free' : formatCurrency(course.price)}
                    </span>
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
