'use client';
import { useState } from 'react';
import { createBrowserClient } from '@supabase/ssr';
import { Upload, Loader2, X } from 'lucide-react';

export default function ImageUpload({ name, defaultValue, label, onChange }: { name: string, defaultValue?: string, label: string, onChange?: (url: string) => void }) {
  const [url, setUrl] = useState(defaultValue || '');
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Use Browser Client to access current user session
  const supabase = createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.files || e.target.files.length === 0) return;
    
    setUploading(true);
    setError(null);
    const file = e.target.files[0];
    if (file.type !== 'image/svg+xml') {
      setError('Only SVG files are allowed for components.');
      setUploading(false);
      return;
    }
    // Sanitize filename to avoid issues
    const fileExt = file.name.split('.').pop();
    const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`;
    const filePath = `${fileName}`;

    try {
      const { error: uploadError } = await supabase.storage
        .from('images')
        .upload(filePath, file);

      if (uploadError) throw uploadError;

      const { data } = supabase.storage.from('images').getPublicUrl(filePath);
      setUrl(data.publicUrl);
      onChange?.(data.publicUrl);
    } catch (error: any) {
      setError('Error uploading image: ' + error.message);
      console.error(error);
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="mb-4">
      <label className="block text-sm font-medium text-slate-700 mb-2">{label}</label>
      <input type="hidden" name={name} value={url} />
      
      <div className="flex items-center gap-4">
        {url ? (
           <div className="relative w-32 h-24 border rounded-lg overflow-hidden group bg-slate-100">
               <img src={url} className="w-full h-full object-cover" alt="Preview" />
               <button 
                 type="button" 
                 onClick={() => setUrl('')}
                 className="absolute inset-0 bg-black/50 text-white flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                 <X size={20} />
               </button>
           </div>
        ) : (
          <div className="w-32 h-24 border-2 border-dashed border-slate-300 rounded-lg flex flex-col items-center justify-center text-slate-400 bg-slate-50 hover:bg-slate-100 transition-colors">
             {uploading ? <Loader2 className="animate-spin"/> : <Upload size={24} />}
          </div>
        )}
        
          <div className="flex-1">
            <input 
                type="file" 
                accept="image/svg+xml" 
                onChange={handleUpload} 
                disabled={uploading}
                className="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 disabled:opacity-50 cursor-pointer"
            />
            <p className="text-xs text-slate-400 mt-1">SVG only. Pins auto-parse from the uploaded SVG.</p>
            {error && <p className="text-xs text-red-500 mt-1">{error}</p>}
        </div>
      </div>
    </div>
  );
}
