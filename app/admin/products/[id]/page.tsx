import { createClient } from '@/lib/supabase/server';
import { upsertProduct } from '@/app/admin/actions';
import { Button } from '@/components/ui/Button';
import ImageUpload from '@/components/admin/ImageUpload';
import ProductVariantsEditor from './VariantsEditor'; // Client Component

export default async function ProductEditor({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const isNew = params.id === 'new';
  
  let product: any = {};
  if (!isNew) {
      const { data } = await supabase.from('products').select('*').eq('id', params.id).single();
      if (data) product = data;
  }

  return (
    <div className="max-w-2xl mx-auto pb-20">
       <h1 className="text-2xl font-bold mb-6">{isNew ? 'New Product' : 'Edit Product'}</h1>
       
       <form action={upsertProduct} className="bg-white p-8 rounded-xl border border-slate-200 space-y-6">
           <input type="hidden" name="id" value={product.id || ''} />
           
           <div className="grid grid-cols-2 gap-6">
               <div>
                   <label className="block text-sm font-bold mb-2">Title</label>
                   <input name="title" defaultValue={product.title} required className="w-full p-2 border rounded-lg"/>
               </div>
               <div>
                   <label className="block text-sm font-bold mb-2">Price (cents)</label>
                   <input name="price" type="number" defaultValue={product.price || 0} className="w-full p-2 border rounded-lg"/>
               </div>
           </div>
           
           <div>
                <label className="block text-sm font-bold mb-2">Slug</label>
                <input name="slug" defaultValue={product.slug} required className="w-full p-2 border rounded-lg"/>
           </div>
           
           <ImageUpload name="file_url" label="Product File / Placeholder Image" defaultValue={product.file_url}/>

           <div>
                <label className="block text-sm font-bold mb-2">Description</label>
                <textarea name="description" defaultValue={product.description} className="w-full p-2 border rounded-lg h-32"/>
           </div>

           {/* Variants Editor (Client Component handles JSON) */}
           <div>
               <label className="block text-sm font-bold mb-2">Variants</label>
               <ProductVariantsEditor initialVariants={product.variants || []} />
           </div>

           <div className="flex items-center gap-2 pt-4 border-t border-slate-100">
                <input type="checkbox" name="is_published" defaultChecked={product.is_published} id="pub"/>
                <label htmlFor="pub" className="font-medium">Publish in Store</label>
           </div>
           
           <Button className="w-full" type="submit">Save Product</Button>
       </form>
    </div>
  );
}
