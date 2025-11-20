'use client';
import { Button } from '@/components/ui/Button';
import { formatCurrency } from '@/lib/utils';

export default function EnrollButton({ courseId, price }: { courseId: string, price: number }) {
  const handleEnroll = async () => {
    const res = await fetch('/api/stripe/checkout', {
      method: 'POST',
      body: JSON.stringify({ itemId: courseId, type: 'course' })
    });
    const { url } = await res.json();
    if (url) window.location.href = url;
  };

  return (
    <Button size="lg" onClick={handleEnroll}>
      Enroll for {price === 0 ? 'Free' : formatCurrency(price)}
    </Button>
  );
}
