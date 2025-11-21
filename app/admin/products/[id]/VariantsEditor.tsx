'use client';
import { useState } from 'react';
import { Trash2, Plus } from 'lucide-react';

export default function ProductVariantsEditor({ initialVariants }: { initialVariants: any[] }) {
  const [variants, setVariants] = useState(Array.isArray(initialVariants) ? initialVariants : []);

  const addVariant = () => {
      setVariants([...variants, { name: 'New Variant', price_mod: 0 }]);
  };

  const updateVariant = (index: number, field: string, value: any) => {
      const newV = [...variants];
      newV[index][field] = value;
      setVariants(newV);
  };

  const removeVariant = (index: number) => {
      setVariants(variants.filter((_, i) => i !== index));
  };

  return (
    <div className="space-y-3">
        <input type="hidden" name="variants" value={JSON.stringify(variants)} />
        
        {variants.map((v, i) => (
            <div key={i} className="flex gap-2 items-center">
                <input 
                    type="text" 
                    value={v.name} 
                    onChange={(e) => updateVariant(i, 'name', e.target.value)}
                    className="flex-1 p-2 border rounded text-sm" 
                    placeholder="Variant Name (e.g. Premium License)"
                />
                <input 
                    type="number" 
                    value={v.price_mod} 
                    onChange={(e) => updateVariant(i, 'price_mod', Number(e.target.value))}
                    className="w-24 p-2 border rounded text-sm" 
                    placeholder="Price (+/-)"
                />
                <button type="button" onClick={() => removeVariant(i)} className="text-red-500 hover:bg-red-50 p-2 rounded">
                    <Trash2 size={16}/>
                </button>
            </div>
        ))}
        
        <button type="button" onClick={addVariant} className="text-sm text-blue-600 flex items-center gap-1 font-medium hover:underline">
            <Plus size={14}/> Add Variant
        </button>
    </div>
  );
}
