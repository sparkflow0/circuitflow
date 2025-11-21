import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';
import Navbar from '@/components/Navbar';
import { Button } from '@/components/ui/Button';
import { Zap, Book, Download } from 'lucide-react';
import Link from 'next/link';

export default async function Dashboard() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) redirect('/auth/signin');

  // Fetch Data
  const { data: enrollments } = await supabase
    .from('course_enrollments')
    .select('*, courses(*)')
    .eq('user_id', user.id);

  const { data: purchases } = await supabase
    .from('product_purchases')
    .select('*, products(*)')
    .eq('user_id', user.id);

  return (
    <div className="min-h-screen">
      <Navbar />
      <div className="container mx-auto px-4 py-10 space-y-10">

        {/* Header */}
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-xs uppercase tracking-[0.2em] text-blue-400 mb-2">لوحة التحكم</p>
            <h1 className="text-3xl font-extrabold text-white mb-2">مرحباً بك مجدداً</h1>
            <p className="text-gray-400">سعيدون بعودتك، {user.email}</p>
          </div>

          {/* Simulator Launcher - DIRECT LINK */}
          <Link href="/simulator">
            <Button size="lg" className="shadow-lg shadow-blue-900/40">
              <Zap className="ml-2 h-5 w-5" /> فتح المحاكي
            </Button>
          </Link>
        </div>

        <div className="grid md:grid-cols-2 gap-8">

          {/* Courses Section */}
          <div className="bg-[#1e1e24] p-6 rounded-2xl border border-gray-800 shadow-xl shadow-black/20">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold text-white flex items-center gap-2">
                <span className="flex h-9 w-9 items-center justify-center rounded-full bg-blue-900/40 text-blue-300">
                  <Book className="h-5 w-5" />
                </span>
                تقدمك في التعلم
              </h2>
              <Link href="/courses" className="text-sm text-blue-400 hover:text-blue-300 transition-colors">استعراض الكورسات</Link>
            </div>
            {enrollments && enrollments.length > 0 ? (
              <ul className="space-y-4">
                {enrollments.map((enr: any) => (
                  <li key={enr.id} className="flex justify-between items-center p-4 bg-[#25252b] rounded-xl border border-gray-800 hover:border-gray-700 transition-colors">
                    <div>
                      <p className="font-semibold text-white">{enr.courses.title}</p>
                      <p className="text-xs text-gray-500">التقدم: 0% (قريباً)</p>
                    </div>
                    <Link href={`/courses/${enr.courses.slug}/learn`}>
                      <Button size="sm" variant="secondary">استمر</Button>
                    </Link>
                  </li>
                ))}
              </ul>
            ) : (
              <div className="text-center py-10 bg-[#16161b] rounded-xl border border-dashed border-gray-800">
                <p className="text-gray-400 mb-4">لم تنضم لأي دورة بعد.</p>
                <Link href="/courses"><Button variant="secondary">تصفح الدورات</Button></Link>
              </div>
            )}
          </div>

          {/* Products Section */}
          <div className="bg-[#1e1e24] p-6 rounded-2xl border border-gray-800 shadow-xl shadow-black/20">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold text-white flex items-center gap-2">
                <span className="flex h-9 w-9 items-center justify-center rounded-full bg-purple-900/40 text-purple-200">
                  <Download className="h-5 w-5" />
                </span>
                تحميلاتك الرقمية
              </h2>
              <Link href="/store" className="text-sm text-blue-400 hover:text-blue-300 transition-colors">زيارة المتجر</Link>
            </div>
            {purchases && purchases.length > 0 ? (
              <ul className="space-y-4">
                {purchases.map((pur: any) => (
                  <li key={pur.id} className="flex justify-between items-center p-4 bg-[#25252b] rounded-xl border border-gray-800 hover:border-gray-700 transition-colors">
                    <p className="font-semibold text-white">{pur.products.title}</p>
                    <a href={pur.products.file_url} target="_blank" rel="noreferrer">
                      <Button size="sm" variant="outline"><Download className="h-4 w-4" /></Button>
                    </a>
                  </li>
                ))}
              </ul>
            ) : (
              <div className="text-center py-10 bg-[#16161b] rounded-xl border border-dashed border-gray-800">
                <p className="text-gray-400 mb-4">لا توجد منتجات رقمية مشتراة بعد.</p>
                <Link href="/store"><Button variant="secondary">استعرض المنتجات</Button></Link>
              </div>
            )}
          </div>

        </div>
      </div>
    </div>
  );
}
