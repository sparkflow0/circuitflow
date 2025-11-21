import { createClient } from '@/lib/supabase/server';

export default async function AdminDashboard() {
  const supabase = createClient();
  
  const { count: users } = await supabase.from('profiles').select('*', { count: 'exact', head: true });
  const { count: courses } = await supabase.from('courses').select('*', { count: 'exact', head: true });
  const { count: orders } = await supabase.from('course_enrollments').select('*', { count: 'exact', head: true });
  const { count: posts } = await supabase.from('blog_posts').select('*', { count: 'exact', head: true });

  return (
    <div>
      <h1 className="text-3xl font-bold text-slate-800 mb-8">Dashboard Overview</h1>
      
      <div className="grid grid-cols-4 gap-6">
         <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
             <h3 className="text-sm font-medium text-slate-500 uppercase">Total Users</h3>
             <p className="text-3xl font-bold text-slate-900 mt-2">{users}</p>
         </div>
         <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
             <h3 className="text-sm font-medium text-slate-500 uppercase">Active Courses</h3>
             <p className="text-3xl font-bold text-slate-900 mt-2">{courses}</p>
         </div>
         <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
             <h3 className="text-sm font-medium text-slate-500 uppercase">Enrollments</h3>
             <p className="text-3xl font-bold text-slate-900 mt-2">{orders}</p>
         </div>
         <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-200">
             <h3 className="text-sm font-medium text-slate-500 uppercase">Blog Posts</h3>
             <p className="text-3xl font-bold text-slate-900 mt-2">{posts}</p>
         </div>
      </div>
    </div>
  );
}
