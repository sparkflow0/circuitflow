'use client';
import { useState } from 'react';
import { Button } from '@/components/ui/Button';
import { formatCurrency } from '@/lib/utils';
import { ShoppingCart, Download, Loader2, Check } from 'lucide-react';

interface Variant {
    name: string;
    price_mod: number;
}

export default function ProductActions({ product, isPurchased }: { product: any, isPurchased: boolean }) {
  const [selectedVariantIndex, setSelectedVariantIndex] = useState<number>(0);
  const [isLoading, setIsLoading] = useState(false);

  const variants: Variant[] = Array.isArray(product.variants) && product.variants.length > 0 
    ? product.variants 
    : [{ name: 'Standard License', price_mod: 0 }];

  const currentVariant = variants[selectedVariantIndex];
  const finalPrice = product.price + (currentVariant.price_mod || 0);

  const handleBuy = async () => {
      setIsLoading(true);
      try {
        const res = await fetch('/api/stripe/checkout', {
            method: 'POST',
            body: JSON.stringify({ 
                itemId: product.id, 
                type: 'product',
                variantName: currentVariant.name 
            })
        });
        const { url } = await res.json();
        if (url) window.location.href = url;
        else alert("Error initiating checkout");
      } catch (e) {
          console.error(e);
          alert("Something went wrong");
      } finally {
          setIsLoading(false);
      }
  };

  if (isPurchased) {
      return (
          <a href={product.file_url} download>
              <Button size="lg" className="w-full bg-green-600 hover:bg-green-700 text-lg">
                  <Download className="mr-2"/> تحميل الملفات
              </Button>
          </a>
      );
  }

  return (
    <div className="space-y-6">
        {/* Variant Selector */}
        {variants.length > 1 && (
            <div className="space-y-3">
                <label className="text-sm font-bold text-slate-700">اختر نوع الرخصة:</label>
                <div className="grid gap-3">
                    {variants.map((v, idx) => {
                        const isSelected = selectedVariantIndex === idx;
                        const priceDiff = v.price_mod > 0 ? `+${formatCurrency(v.price_mod)}` : '';
                        
                        return (
                            <div 
                                key={idx}
                                onClick={() => setSelectedVariantIndex(idx)}
                                className={`p-3 rounded-lg border-2 cursor-pointer flex justify-between items-center transition-all ${isSelected ? 'border-blue-600 bg-blue-50' : 'border-slate-200 hover:border-slate-300'}`}
                            >
                                <div className="flex items-center gap-3">
                                    <div className={`w-5 h-5 rounded-full border flex items-center justify-center ${isSelected ? 'border-blue-600 bg-blue-600' : 'border-slate-400'}`}>
                                        {isSelected && <Check size={12} className="text-white"/>}
                                    </div>
                                    <span className={`text-sm font-medium ${isSelected ? 'text-blue-900' : 'text-slate-600'}`}>{v.name}</span>
                                </div>
                                {priceDiff && <span className="text-xs font-bold text-slate-500 bg-white px-2 py-1 rounded border">{priceDiff}</span>}
                            </div>
                        );
                    })}
                </div>
            </div>
        )}

        <div className="flex items-center justify-between bg-slate-50 p-4 rounded-xl border border-slate-100">
            <div>
                <p className="text-xs text-slate-500 mb-1">السعر النهائي</p>
                <p className="text-2xl font-bold text-slate-900">{formatCurrency(finalPrice)}</p>
            </div>
            <Button size="lg" onClick={handleBuy} disabled={isLoading} className="px-8">
                {isLoading ? <Loader2 className="animate-spin"/> : <ShoppingCart className="mr-2"/>}
                {isLoading ? 'جاري المعالجة...' : 'شراء الآن'}
            </Button>
        </div>
    </div>
  );
}
