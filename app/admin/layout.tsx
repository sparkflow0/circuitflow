import Link from 'next/link';
import { LayoutDashboard, BookOpen, ShoppingBag, FileText, LogOut, Settings } from 'lucide-react';
import { createClient } from '@/lib/supabase/server';
import { redirect } from 'next/navigation';

export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  // Server-side Auth Check
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect('/auth/signin');
  
  const { data: profile } = await supabase.from('profiles').select('role').eq('id', user.id).single();
  if (profile?.role !== 'admin') redirect('/dashboard');

  const links = [
    { href: '/admin', label: 'Dashboard', icon: LayoutDashboard },
    { href: '/admin/courses', label: 'Courses', icon: BookOpen },
    { href: '/admin/products', label: 'Products', icon: ShoppingBag },
    { href: '/admin/blog', label: 'Blog', icon: FileText },
  ];

  return (
    <div className="min-h-screen flex bg-slate-100 font-sans text-slate-900">
      {/* Sidebar: Fixed to the 'start' (Right in Arabic, Left in English) */}
      <aside className="w-64 bg-slate-900 text-white flex flex-col fixed h-full top-0 bottom-0 start-0 z-50 overflow-y-auto">
        <div className="p-6 border-b border-slate-800">
          <h1 className="text-xl font-bold">Admin CMS</h1>
          <p className="text-xs text-slate-400 mt-1">{user.email}</p>
        </div>
        <nav className="flex-1 p-4 space-y-1">
          {links.map(link => (
            <Link key={link.href} href={link.href} className="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-slate-800 transition-colors">
               <link.icon size={18} /> {link.label}
            </Link>
          ))}
        </nav>
        <div className="p-4 border-t border-slate-800">
          <Link href="/" className="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-red-900/50 text-red-400 transition-colors">
             <LogOut size={18} /> Exit Admin
          </Link>
        </div>
      </aside>

      {/* Content: Margin Start (ms-64) pushes content away from sidebar in correct direction */}
      <main className="flex-1 ms-64 p-8 overflow-y-auto w-full">
         <div className="max-w-6xl mx-auto">
             {children}
         </div>
      </main>
    </div>
  );
}
