'use client';

import { useState } from 'react';
import { Plus, Trash2 } from 'lucide-react';
import ImageUpload from './ImageUpload';

export type AnimationFrame = {
  value: string;
  image_url: string;
  transition?: 'none' | 'fade';
};

export default function AnimationsEditor({
  value,
  onChange,
}: {
  value: AnimationFrame[];
  onChange: (frames: AnimationFrame[]) => void;
}) {
  const [frames, setFrames] = useState<AnimationFrame[]>(value || []);

  const update = (next: AnimationFrame[]) => {
    setFrames(next);
    onChange(next);
  };

  const addFrame = () => {
    update([...(frames || []), { value: '', image_url: '', transition: 'fade' }]);
  };

  const updateFrame = (idx: number, patch: Partial<AnimationFrame>) => {
    const next = frames.map((f, i) => (i === idx ? { ...f, ...patch } : f));
    update(next);
  };

  const removeFrame = (idx: number) => {
    update(frames.filter((_, i) => i !== idx));
  };

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-bold text-slate-700">Component Animations</h3>
        <button type="button" onClick={addFrame} className="text-blue-600 text-xs flex items-center gap-1">
          <Plus size={14} /> Add Frame
        </button>
      </div>
      <div className="space-y-3">
        {frames.length === 0 && <div className="text-xs text-slate-500">No frames yet.</div>}
        {frames.map((frame, idx) => (
          <div key={idx} className="border rounded-lg p-3 bg-white shadow-sm space-y-2">
            <div className="flex items-center gap-2">
              <label className="text-xs font-semibold text-slate-600">Value</label>
              <input
                className="border rounded px-2 py-1 text-sm flex-1"
                value={frame.value}
                onChange={(e) => updateFrame(idx, { value: e.target.value })}
                placeholder="e.g., HIGH, LOW, angle, etc."
              />
              <label className="text-xs font-semibold text-slate-600">Transition</label>
              <select
                className="border rounded px-2 py-1 text-sm"
                value={frame.transition || 'none'}
                onChange={(e) => updateFrame(idx, { transition: e.target.value as AnimationFrame['transition'] })}
              >
                <option value="none">None</option>
                <option value="fade">Fade</option>
              </select>
              <button type="button" onClick={() => removeFrame(idx)} className="text-red-500 hover:text-red-700">
                <Trash2 size={16} />
              </button>
            </div>
            <ImageUpload
              name={`frame-${idx}-image`}
              label="Frame Image"
              defaultValue={frame.image_url}
              onChange={(url) => updateFrame(idx, { image_url: url })}
            />
          </div>
        ))}
      </div>
    </div>
  );
}
