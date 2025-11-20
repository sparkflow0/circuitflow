'use client';
import { useEffect } from 'react';
import confetti from 'canvas-confetti';
import { Download, Award } from 'lucide-react';

export default function Certificate({ courseName, userName, date }: any) {
  useEffect(() => {
    // Trigger confetti on mount
    const duration = 3000;
    const animationEnd = Date.now() + duration;
    const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

    const random = (min: number, max: number) => Math.random() * (max - min) + min;

    const interval: any = setInterval(function() {
      const timeLeft = animationEnd - Date.now();
      if (timeLeft <= 0) return clearInterval(interval);
      const particleCount = 50 * (timeLeft / duration);
      confetti(Object.assign({}, defaults, { particleCount, origin: { x: random(0.1, 0.3), y: Math.random() - 0.2 } }));
      confetti(Object.assign({}, defaults, { particleCount, origin: { x: random(0.7, 0.9), y: Math.random() - 0.2 } }));
    }, 250);
  }, []);

  return (
    <div className="flex flex-col items-center justify-center p-8 bg-slate-50 rounded-xl border-2 border-dashed border-yellow-400 animate-in zoom-in-95 duration-500">
      <div className="bg-white p-10 rounded-lg shadow-2xl text-center max-w-2xl w-full border-[10px] border-double border-slate-800 relative">
         <Award size={64} className="mx-auto text-yellow-500 mb-4" />
         <h2 className="text-4xl font-serif font-bold text-slate-900 mb-2">شهادة إتمام</h2>
         <p className="text-slate-500 mb-8">Certificate of Completion</p>
         
         <p className="text-lg text-slate-700 mb-2">نقر بأن المتدرب</p>
         <h3 className="text-3xl font-bold text-blue-600 mb-6">{userName}</h3>
         
         <p className="text-lg text-slate-700 mb-2">قد أتم بنجاح دورة</p>
         <h3 className="text-2xl font-bold text-slate-800 mb-8">{courseName}</h3>
         
         <div className="border-t border-slate-200 pt-6 flex justify-between text-sm text-slate-500">
             <span>Date: {new Date(date).toLocaleDateString('en-US')}</span>
             <span>ArduinoSimPro</span>
         </div>
      </div>
      <button onClick={() => window.print()} className="mt-6 flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
         <Download size={18}/> تحميل الشهادة
      </button>
    </div>
  );
}
