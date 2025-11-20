'use client';
import Link from 'next/link';
import { Button } from './ui/Button';
import { CircuitBoard, User, Globe } from 'lucide-react';
import { useLanguage } from '@/lib/LanguageContext';

export default function Navbar() {
  const { t, lang, toggleLanguage } = useLanguage();

  return (
    <nav className="border-b border-slate-200 bg-white">
      <div className="container mx-auto px-4 h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center space-x-2 text-blue-600 font-bold text-xl">
          <CircuitBoard className="ml-2"/>
          <span>{lang === 'ar' ? 'أردوينو' : 'Arduino'}<span className="text-slate-900">Sim</span></span>
        </Link>

        <div className="hidden md:flex items-center gap-6">
          <Link href="/courses" className="text-sm font-medium text-slate-600 hover:text-slate-900">{t.courses}</Link>
          <Link href="/store" className="text-sm font-medium text-slate-600 hover:text-slate-900">{t.store}</Link>
          <Link href="/blog" className="text-sm font-medium text-slate-600 hover:text-slate-900">{t.blog}</Link>
          <Link href="/simulator" className="text-sm font-medium text-blue-600 hover:text-blue-800">{t.simulator}</Link>
        </div>

        <div className="flex items-center gap-4">
          <button onClick={toggleLanguage} className="flex items-center gap-1 text-slate-600 hover:text-blue-600 text-sm font-bold">
             <Globe size={16} /> {lang === 'ar' ? 'English' : 'العربية'}
          </button>

          <Link href="/auth/signin">
            <Button size="sm" variant="outline">{t.signin}</Button>
          </Link>
          <Link href="/auth/signup">
            <Button size="sm">{t.getStarted}</Button>
          </Link>
        </div>
      </div>
    </nav>
  );
}
