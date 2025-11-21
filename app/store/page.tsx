import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import Link from 'next/link';
import { formatCurrency } from '@/lib/utils';
import { ShoppingBag, Download } from 'lucide-react';

export const revalidate = 0;

export default async function StorePage() {
  const supabase = createClient();
  const { data: products } = await supabase
    .from('products')
    .select('*')
    .eq('is_published', true)
    .order('created_at', { ascending: false });

  return (
    <div className="min-h-screen bg-slate-50 font-sans">
      <Navbar />
      
      {/* Hero Section */}
      <div className="bg-white border-b border-slate-200 py-12 px-4 text-center">
        <h1 className="text-3xl md:text-4xl font-extrabold text-slate-900 mb-4">المتجر الرقمي</h1>
        <p className="text-slate-500 text-lg max-w-2xl mx-auto">
          ملفات مشاريع جاهزة، تصميمات PCB، ومكتبات أكواد لتسريع عملية التطوير لديك.
        </p>
      </div>

      <div className="container mx-auto px-4 py-12">
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {products?.map((product) => (
            <Link key={product.id} href={`/store/${product.slug}`} className="group block bg-white rounded-2xl border border-slate-200 overflow-hidden hover:shadow-xl transition-all hover:-translate-y-1">
              {/* Thumbnail */}
              <div className="h-56 bg-slate-100 relative overflow-hidden flex items-center justify-center">
                 {product.file_url && product.file_url.startsWith('http') ? (
                    <img src={product.file_url} alt={product.title} className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"/>
                 ) : (
                    <ShoppingBag size={48} className="text-slate-300"/>
                 )}
                 <div className="absolute top-3 right-3 bg-black/70 backdrop-blur text-white px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1">
                    <Download size={12}/> منتج رقمي
                 </div>
              </div>

              <div className="p-6">
                <h3 className="font-bold text-xl mb-2 text-slate-900 group-hover:text-blue-600 transition-colors">{product.title}</h3>
                <p className="text-slate-500 text-sm mb-6 line-clamp-2">{product.description}</p>
                
                <div className="flex justify-between items-center pt-4 border-t border-slate-100">
                  <span className="text-xs text-slate-400">يبدأ من</span>
                  <span className="font-bold text-xl text-blue-600">
                    {formatCurrency(product.price)}
                  </span>
                </div>
              </div>
            </Link>
          ))}
          
          {(!products || products.length === 0) && (
              <div className="col-span-full text-center py-20 text-slate-400">
                  لا توجد منتجات متاحة حالياً.
              </div>
          )}
        </div>
      </div>
    </div>
  );
}
