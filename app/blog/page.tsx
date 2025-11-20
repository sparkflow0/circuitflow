import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import Link from 'next/link';
import { Calendar, Clock, ArrowRight } from 'lucide-react';

export const revalidate = 0; // Dynamic data

export default async function BlogIndex() {
  const supabase = createClient();
  const { data: posts } = await supabase
    .from('blog_posts')
    .select('*')
    .eq('is_published', true)
    .order('published_at', { ascending: false });

  return (
    <div className="min-h-screen bg-slate-50 font-sans">
      <Navbar />
      
      <div className="bg-slate-900 text-white py-16 px-4" dir="rtl">
        <div className="container mx-auto max-w-5xl">
          <h1 className="text-4xl font-extrabold mb-4">المدونة التعليمية</h1>
          <p className="text-slate-300 text-lg max-w-2xl">
            أحدث الدروس والمقالات حول الأردوينو، ESP32، وإنترنت الأشياء. تعلم كيف تبني مشاريعك بنفسك.
          </p>
        </div>
      </div>

      <div className="container mx-auto px-4 py-12 max-w-5xl" dir="rtl">
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {posts?.map((post) => (
            <Link key={post.id} href={`/blog/${post.slug}`} className="group flex flex-col bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden hover:shadow-md transition-all hover:-translate-y-1">
              <div className="h-48 bg-slate-200 relative overflow-hidden">
                {post.cover_image ? (
                    <img src={post.cover_image} alt={post.title} className="w-full h-full object-cover transition-transform group-hover:scale-105" />
                ) : (
                    <div className="flex items-center justify-center h-full text-slate-400">No Image</div>
                )}
              </div>
              <div className="p-6 flex-1 flex flex-col">
                <div className="flex items-center gap-2 text-xs text-slate-500 mb-3">
                    <Calendar size={14} />
                    <span>{new Date(post.published_at).toLocaleDateString('ar-EG')}</span>
                </div>
                <h3 className="text-xl font-bold text-slate-900 mb-3 leading-snug group-hover:text-blue-600 transition-colors">
                  {post.title}
                </h3>
                <p className="text-slate-600 text-sm mb-6 line-clamp-3 flex-1">
                  {post.excerpt}
                </p>
                <div className="flex items-center text-blue-600 font-bold text-sm mt-auto">
                  اقرأ المزيد <ArrowRight size={16} className="mr-2 rotate-180" />
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
