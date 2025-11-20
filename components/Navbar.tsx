import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import { Button } from './ui/Button';
import { CircuitBoard, User } from 'lucide-react';

export default async function Navbar() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <nav className="border-b border-slate-200 bg-white">
      <div className="container mx-auto px-4 h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center space-x-2 text-blue-600 font-bold text-xl">
          <CircuitBoard />
          <span>ArduinoSim<span className="text-slate-900">Pro</span></span>
        </Link>

        <div className="hidden md:flex items-center space-x-6">
          <Link href="/courses" className="text-sm font-medium text-slate-600 hover:text-slate-900">Courses</Link>
          <Link href="/store" className="text-sm font-medium text-slate-600 hover:text-slate-900">Store</Link>
          <Link href="/blog" className="text-sm font-medium text-slate-600 hover:text-slate-900">Blog</Link>
          {user && (
            <Link href="/simulator" className="text-sm font-medium text-blue-600 hover:text-blue-800">Simulator</Link>
          )}
        </div>

        <div className="flex items-center space-x-4">
          {user ? (
            <Link href="/dashboard">
               <Button variant="secondary" size="sm">
                 <User className="mr-2 h-4 w-4" /> Dashboard
               </Button>
            </Link>
          ) : (
            <>
              <Link href="/auth/signin" className="text-sm font-medium text-slate-600 hover:text-slate-900">
                Sign In
              </Link>
              <Link href="/auth/signup">
                <Button size="sm">Get Started</Button>
              </Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}
