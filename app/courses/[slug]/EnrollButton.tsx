'use client';
import { useState } from 'react';
import { Button } from '@/components/ui/Button';
import { formatCurrency } from '@/lib/utils';
import { enrollFreeCourse } from '@/app/courses/actions';
import { Loader2 } from 'lucide-react';

export default function EnrollButton({ courseId, price }: { courseId: string, price: number }) {
  const [isLoading, setIsLoading] = useState(false);

  const handleEnroll = async () => {
    setIsLoading(true);
    try {
        if (price === 0) {
            // Direct Server Action for Free Courses
            await enrollFreeCourse(courseId);
        } else {
            // Stripe Checkout for Paid
            const res = await fetch('/api/stripe/checkout', {
              method: 'POST',
              body: JSON.stringify({ itemId: courseId, type: 'course' })
            });
            const { url } = await res.json();
            if (url) window.location.href = url;
            else setIsLoading(false);
        }
    } catch (e) {
        console.error(e);
        setIsLoading(false);
        alert("Something went wrong. Please try again.");
    }
  };

  return (
    <Button size="lg" onClick={handleEnroll} disabled={isLoading} className="min-w-[150px]">
      {isLoading ? <Loader2 className="animate-spin mr-2"/> : null}
      {isLoading ? 'Processing...' : (price === 0 ? 'Enroll Free' : `Enroll for ${formatCurrency(price)}`)}
    </Button>
  );
}
