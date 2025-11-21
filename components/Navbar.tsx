'use client';
import Link from 'next/link';
import { Button } from './ui/Button';
import { CircuitBoard, Globe } from 'lucide-react';
import { useLanguage } from '@/lib/LanguageContext';

export default function Navbar() {
  const { t, lang, toggleLanguage } = useLanguage();

  return (
    <nav className="border-b border-gray-800 bg-[#0f0f13]/90 backdrop-blur-md sticky top-0 z-30 shadow-lg shadow-black/20">
      <div className="container mx-auto px-4 h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2 text-white font-bold text-xl">
          <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-gradient-to-r from-blue-600 to-purple-600 shadow-lg shadow-blue-900/30">
            <CircuitBoard className="h-5 w-5" />
          </span>
          <span className="tracking-tight">
            {lang === 'ar' ? 'أردوينو' : 'Arduino'}<span className="text-blue-400">Sim</span>
          </span>
        </Link>

        <div className="hidden md:flex items-center gap-6">
          <Link href="/courses" className="text-sm font-medium text-gray-300 hover:text-white transition-colors">{t.courses}</Link>
          <Link href="/store" className="text-sm font-medium text-gray-300 hover:text-white transition-colors">{t.store}</Link>
          <Link href="/blog" className="text-sm font-medium text-gray-300 hover:text-white transition-colors">{t.blog}</Link>
          <Link href="/simulator" className="text-sm font-medium text-blue-400 hover:text-blue-300 transition-colors">{t.simulator}</Link>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={toggleLanguage}
            className="flex items-center gap-1 text-gray-300 hover:text-white text-sm font-bold transition-colors"
          >
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
