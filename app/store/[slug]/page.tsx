import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import { notFound } from 'next/navigation';
import { CheckCircle, ShieldCheck, FileCode } from 'lucide-react';
import ProductActions from './ProductActions'; // Client Component

export const revalidate = 0;

export default async function ProductDetail({ params }: { params: { slug: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  // Fetch Product
  const { data: product } = await supabase
    .from('products')
    .select('*')
    .eq('slug', params.slug)
    .single();

  if (!product) notFound();

  // Check if already purchased
  let isPurchased = false;
  if (user) {
      const { data } = await supabase.from('product_purchases').select('id').eq('user_id', user.id).eq('product_id', product.id).single();
      if (data) isPurchased = true;
  }

  return (
    <div className="min-h-screen bg-slate-50 font-sans">
      <Navbar />
      
      <div className="container mx-auto px-4 py-12">
        <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden shadow-sm grid md:grid-cols-2">
            
            {/* Left: Image/Preview */}
            <div className="bg-slate-100 min-h-[400px] relative flex items-center justify-center p-8">
                {product.file_url && product.file_url.startsWith('http') ? (
                    <img src={product.file_url} alt={product.title} className="max-w-full max-h-full object-contain shadow-2xl rounded-lg"/>
                ) : (
                    <FileCode size={80} className="text-slate-300"/>
                )}
            </div>

            {/* Right: Info & Buy */}
            <div className="p-8 md:p-12 flex flex-col" dir="rtl">
                <div className="mb-auto">
                    <h1 className="text-3xl font-extrabold text-slate-900 mb-4">{product.title}</h1>
                    <div className="prose text-slate-600 mb-8 text-lg leading-relaxed">
                        {product.description}
                    </div>
                    
                    <div className="space-y-3 mb-8">
                        <div className="flex items-center gap-2 text-sm text-slate-600">
                            <CheckCircle className="text-green-500" size={18} />
                            <span>تحميل فوري بعد الدفع</span>
                        </div>
                        <div className="flex items-center gap-2 text-sm text-slate-600">
                            <ShieldCheck className="text-blue-500" size={18} />
                            <span>ملفات آمنة ومفحوصة</span>
                        </div>
                        <div className="flex items-center gap-2 text-sm text-slate-600">
                            <FileCode className="text-purple-500" size={18} />
                            <span>تتضمن الأكواد والمخططات</span>
                        </div>
                    </div>
                </div>

                <div className="border-t border-slate-100 pt-8">
                    <ProductActions product={product} isPurchased={isPurchased} />
                </div>
            </div>
        </div>
      </div>
    </div>
  );
}
