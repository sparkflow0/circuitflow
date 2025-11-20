import Link from 'next/link';
import { Button } from '@/components/ui/Button';
import { Cpu, BookOpen, ShoppingBag } from 'lucide-react';
import Navbar from '@/components/Navbar';

export default function LandingPage() {
  return (
    <div className="min-h-screen flex flex-col bg-slate-50">
      <Navbar />
      
      {/* Hero */}
      <section className="py-20 px-4 text-center bg-white border-b border-slate-200">
        <div className="container mx-auto max-w-4xl">
          <h1 className="text-5xl font-extrabold text-slate-900 tracking-tight mb-6">
            Master Arduino without the Hardware
          </h1>
          <p className="text-xl text-slate-600 mb-8">
            An advanced AI-powered simulator combined with expert-led courses. 
            Design circuits, write code, and debug in your browser.
          </p>
          <div className="flex justify-center gap-4">
            <Link href="/auth/signup">
              <Button size="lg">Start Simulating Free</Button>
            </Link>
            <Link href="/courses">
              <Button variant="outline" size="lg">Explore Courses</Button>
            </Link>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="py-16 px-4 container mx-auto">
        <div className="grid md:grid-cols-3 gap-8">
          <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
            <Cpu className="h-10 w-10 text-blue-500 mb-4" />
            <h3 className="text-xl font-bold mb-2">Browser Simulator</h3>
            <p className="text-slate-600">Real-time circuit simulation with ESP32 support. No installation required.</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
            <BookOpen className="h-10 w-10 text-green-500 mb-4" />
            <h3 className="text-xl font-bold mb-2">Interactive Learning</h3>
            <p className="text-slate-600">Follow step-by-step guides that sync directly with your simulator workspace.</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
            <ShoppingBag className="h-10 w-10 text-purple-500 mb-4" />
            <h3 className="text-xl font-bold mb-2">Digital Assets</h3>
            <p className="text-slate-600">Buy project templates, PCB layouts, and advanced component libraries.</p>
          </div>
        </div>
      </section>
    </div>
  );
}
