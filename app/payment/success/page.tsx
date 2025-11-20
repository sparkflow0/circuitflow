'use client';
import { useEffect, useState } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import { verifyStripeSession } from '@/app/courses/actions';
import { Loader2, CheckCircle } from 'lucide-react';
import { Button } from '@/components/ui/Button';

export default function PaymentSuccessPage() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const sessionId = searchParams.get('session_id');
  const type = searchParams.get('type'); // 'course' or 'product'
  const slug = searchParams.get('slug');

  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading');

  useEffect(() => {
    if (!sessionId) {
        setStatus('error');
        return;
    }

    // Verify payment on server to enroll user
    verifyStripeSession(sessionId)
      .then((result) => {
          if (result.success) {
              setStatus('success');
              // Redirect after short delay
              setTimeout(() => {
                  const target = type === 'course' ? `/courses/${slug}/learn` : `/dashboard`;
                  router.push(target);
              }, 2000);
          } else {
              setStatus('error');
          }
      })
      .catch(() => setStatus('error'));
  }, [sessionId, type, slug, router]);

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-slate-50 p-4 text-center">
       <div className="bg-white p-8 rounded-2xl shadow-lg max-w-md w-full">
           {status === 'loading' && (
               <>
                 <Loader2 size={48} className="animate-spin text-blue-600 mx-auto mb-4"/>
                 <h2 className="text-xl font-bold text-slate-800">Verifying Payment...</h2>
                 <p className="text-slate-500 mt-2">Please wait while we enroll you.</p>
               </>
           )}
           
           {status === 'success' && (
               <>
                 <CheckCircle size={48} className="text-green-500 mx-auto mb-4"/>
                 <h2 className="text-xl font-bold text-slate-800">Payment Successful!</h2>
                 <p className="text-slate-500 mt-2">Redirecting to your content...</p>
               </>
           )}

           {status === 'error' && (
               <>
                 <div className="text-red-500 text-4xl mb-4">⚠️</div>
                 <h2 className="text-xl font-bold text-slate-800">Something went wrong</h2>
                 <p className="text-slate-500 mt-2 mb-6">We couldn't verify your payment automatically.</p>
                 <Button onClick={() => router.push('/dashboard')}>Go to Dashboard</Button>
               </>
           )}
       </div>
    </div>
  );
}
