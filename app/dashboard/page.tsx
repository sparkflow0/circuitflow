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
    <div className="min-h-screen bg-slate-50">
      <Navbar />
      <div className="container mx-auto px-4 py-8">
        
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-slate-900">Dashboard</h1>
            <p className="text-slate-500">Welcome back, {user.email}</p>
          </div>
          
          {/* Simulator Launcher - DIRECT LINK */}
          <Link href="/simulator">
            <Button size="lg" className="shadow-lg shadow-blue-500/20">
              <Zap className="mr-2 h-5 w-5" /> Launch Simulator
            </Button>
          </Link>
        </div>

        <div className="grid md:grid-cols-2 gap-8">
          
          {/* Courses Section */}
          <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
            <h2 className="text-xl font-bold mb-4 flex items-center">
              <Book className="mr-2 h-5 w-5 text-blue-500" /> Your Learning
            </h2>
            {enrollments && enrollments.length > 0 ? (
              <ul className="space-y-4">
                {enrollments.map((enr: any) => (
                  <li key={enr.id} className="flex justify-between items-center p-3 bg-slate-50 rounded-lg">
                    <div>
                      <p className="font-medium">{enr.courses.title}</p>
                      <p className="text-xs text-slate-500">Progress: 0% (Coming soon)</p>
                    </div>
                    <Link href={`/courses/${enr.courses.slug}/learn`}>
                      <Button size="sm" variant="outline">Continue</Button>
                    </Link>
                  </li>
                ))}
              </ul>
            ) : (
              <div className="text-center py-8">
                <p className="text-slate-500 mb-4">You aren't enrolled in any courses yet.</p>
                <Link href="/courses"><Button variant="secondary">Browse Courses</Button></Link>
              </div>
            )}
          </div>

          {/* Products Section */}
          <div className="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
            <h2 className="text-xl font-bold mb-4 flex items-center">
              <Download className="mr-2 h-5 w-5 text-purple-500" /> Your Downloads
            </h2>
            {purchases && purchases.length > 0 ? (
              <ul className="space-y-4">
                {purchases.map((pur: any) => (
                  <li key={pur.id} className="flex justify-between items-center p-3 bg-slate-50 rounded-lg">
                    <p className="font-medium">{pur.products.title}</p>
                    <a href={pur.products.file_url} target="_blank" rel="noreferrer">
                      <Button size="sm" variant="ghost"><Download className="h-4 w-4" /></Button>
                    </a>
                  </li>
                ))}
              </ul>
            ) : (
              <div className="text-center py-8">
                <p className="text-slate-500 mb-4">No digital products purchased.</p>
                <Link href="/store"><Button variant="secondary">Visit Store</Button></Link>
              </div>
            )}
          </div>

        </div>
      </div>
    </div>
  );
}
