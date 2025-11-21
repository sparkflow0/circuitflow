'use client';

import { useMemo, useState } from 'react';
import { upsertComponent } from '@/app/admin/actions';
import { Button } from '@/components/ui/Button';
import ImageUpload from '@/components/admin/ImageUpload';
import PinEditor, { PinPoint } from '@/components/admin/PinEditor';
import AnimationsEditor, { AnimationFrame } from '@/components/admin/AnimationsEditor';

export default function ComponentEditorClient({ initialComponent, isNew }: { initialComponent: any; isNew: boolean }) {
  const [imageUrl, setImageUrl] = useState<string>(initialComponent.image_url || '');
  const [width, setWidth] = useState<number>(initialComponent.width || 200);
  const [height, setHeight] = useState<number>(initialComponent.height || 200);
  const [pins, setPins] = useState<PinPoint[]>(initialComponent.pins || []);
  const [type, setType] = useState<string>(initialComponent.type || '');
  const [animations, setAnimations] = useState<AnimationFrame[]>(initialComponent.animations || []);

  const hiddenPins = useMemo(() => JSON.stringify(pins || []), [pins]);
  const hiddenAnimations = useMemo(() => JSON.stringify(animations || []), [animations]);

  return (
    <div className="max-w-3xl mx-auto pb-20">
      <h1 className="text-2xl font-bold mb-6">{isNew ? 'New Component' : 'Edit Component'}</h1>

      <form action={upsertComponent} className="bg-white p-8 rounded-xl border border-slate-200 space-y-6">
        <input type="hidden" name="id" value={initialComponent.id || ''} />
        <input type="hidden" name="pins" value={hiddenPins} />
        <input type="hidden" name="animations" value={hiddenAnimations} />

        <div className="grid grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-bold mb-2">Name</label>
            <input name="name" defaultValue={initialComponent.name} required className="w-full p-2 border rounded-lg"/>
          </div>
          <div>
            <label className="block text-sm font-bold mb-2">Type (unique)</label>
            <input
              name="type"
              value={type}
              onChange={(e) => setType(e.target.value)}
              required
              className="w-full p-2 border rounded-lg"
              placeholder="ARDUINO"
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-bold mb-2">Slug</label>
            <input name="slug" defaultValue={initialComponent.slug} required className="w-full p-2 border rounded-lg"/>
          </div>
          <div>
            <label className="block text-sm font-bold mb-2">Category</label>
            <input name="category" defaultValue={initialComponent.category} className="w-full p-2 border rounded-lg"/>
          </div>
        </div>

        <ImageUpload name="image_url" defaultValue={initialComponent.image_url} label="Component Image" onChange={setImageUrl} />

        <div className="grid grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-bold mb-2">Width (px)</label>
            <input
              name="width"
              type="number"
              value={width}
              onChange={(e) => setWidth(Number(e.target.value || 0))}
              required
              className="w-full p-2 border rounded-lg"
            />
          </div>
          <div>
            <label className="block text-sm font-bold mb-2">Height (px)</label>
            <input
              name="height"
              type="number"
              value={height}
              onChange={(e) => setHeight(Number(e.target.value || 0))}
              required
              className="w-full p-2 border rounded-lg"
            />
          </div>
        </div>

        <PinEditor imageUrl={imageUrl} type={type} width={width || 200} height={height || 200} value={pins} onChange={setPins} />

        <AnimationsEditor value={animations} onChange={setAnimations} />

        <div>
          <label className="block text-sm font-bold mb-2">Metadata (JSON)</label>
          <textarea
            name="metadata"
            className="w-full p-2 border rounded-lg font-mono text-xs h-24"
            defaultValue={JSON.stringify(initialComponent.metadata || {}, null, 2)}
            placeholder='{"default_voltage":"5V"}'
          />
        </div>

        <Button className="w-full" type="submit">Save Component</Button>
      </form>
    </div>
  );
}
