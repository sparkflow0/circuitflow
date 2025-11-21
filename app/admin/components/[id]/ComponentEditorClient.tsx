'use client';

import { useMemo, useState, useEffect, useRef } from 'react';
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
  const [svgMarkup, setSvgMarkup] = useState<string>(initialComponent.svg_markup || '');
  const [animations, setAnimations] = useState<AnimationFrame[]>(initialComponent.animations || []);
  const autoSizedRef = useRef<boolean>(false);

  const hiddenPins = useMemo(() => JSON.stringify(pins || []), [pins]);
  const hiddenAnimations = useMemo(() => JSON.stringify(animations || []), [animations]);

  const getSvgSize = (markup: string): { width?: number; height?: number } | null => {
    if (!markup) return null;
    try {
      const parser = new DOMParser();
      const doc = parser.parseFromString(markup, 'image/svg+xml');
      const svg = doc.querySelector('svg');
      if (!svg) return null;
      const vb = svg.getAttribute('viewBox')?.split(/\s+/).map(Number);
      if (vb && vb.length === 4) {
        return { width: Math.round(vb[2]), height: Math.round(vb[3]) };
      }
      const w = Number(svg.getAttribute('width'));
      const h = Number(svg.getAttribute('height'));
      if (w && h) return { width: Math.round(w), height: Math.round(h) };
      return null;
    } catch {
      return null;
    }
  };

  const parsePinsFromSvg = (markup: string) => {
    if (!markup) return [];
    try {
      const parser = new DOMParser();
      const parseSvg = (m: string) => parser.parseFromString(m, 'image/svg+xml');
      let doc = parseSvg(markup);
      let svg = doc.querySelector('svg');
      if (!svg) {
        // Fallback: wrap fragment in an SVG shell so loose <rect> snippets can be parsed
        const wrapped = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width || 200} ${height || 200}">${markup}</svg>`;
        doc = parseSvg(wrapped);
        svg = doc.querySelector('svg');
      }
      if (!svg) return [];
      const vb = svg.getAttribute('viewBox')?.split(/\s+/).map(Number);
      const minX = vb && vb.length === 4 ? vb[0] : 0;
      const minY = vb && vb.length === 4 ? vb[1] : 0;
      const vbW = vb && vb.length === 4 ? (vb[2] || width || 1) : (Number(svg.getAttribute('width')) || width || 1);
      const vbH = vb && vb.length === 4 ? (vb[3] || height || 1) : (Number(svg.getAttribute('height')) || height || 1);

      const nodes = svg.querySelectorAll('[data-pin-id], [data-pin]');
      const extracted: PinPoint[] = [];
      nodes.forEach((node) => {
        const id = node.getAttribute('data-pin-id') || node.getAttribute('data-pin');
        if (!id) return;
        const descText = node.querySelector('desc')?.textContent || '';
        const noteMatch = descText?.match(/data-pin(?:-label)?=([\\w-]+)/i);
        const label =
          node.getAttribute('data-pin-label') ||
          noteMatch?.[1] ||
          id;
        const voltage = node.getAttribute('data-pin-voltage') || undefined;
        const rawW = node.getAttribute('data-pin-width') || node.getAttribute('width') || node.getAttribute('r');
        const rawH = node.getAttribute('data-pin-height') || node.getAttribute('height') || node.getAttribute('r');
        const dx = node.getAttribute('data-pin-x');
        const dy = node.getAttribute('data-pin-y');
        const cx = node.getAttribute('cx');
        const cy = node.getAttribute('cy');
        const xAttr = node.getAttribute('x');
        const yAttr = node.getAttribute('y');
        const rawX = dx ?? cx ?? xAttr;
        const rawY = dy ?? cy ?? yAttr;
        if (!rawX || !rawY) return;
        const x = Math.round(((parseFloat(rawX) - minX) / vbW) * (width || 1));
        const y = Math.round(((parseFloat(rawY) - minY) / vbH) * (height || 1));
        const w = rawW ? Math.max(4, Math.round(((parseFloat(rawW) * (rawW === node.getAttribute('r') ? 2 : 1)) / vbW) * (width || 1))) : undefined;
        const h = rawH ? Math.max(4, Math.round(((parseFloat(rawH) * (rawH === node.getAttribute('r') ? 2 : 1)) / vbH) * (height || 1))) : undefined;
        if (Number.isNaN(x) || Number.isNaN(y)) return;
        extracted.push({ id, label, x, y, voltage, width: w, height: h });
      });
      return extracted;
    } catch (e) {
      console.error('SVG pin parse failed', e);
      return [];
    }
  };

  const fetchSvgAndParse = async (url: string) => {
    if (!url?.toLowerCase().endsWith('.svg')) return;
    try {
      const res = await fetch(url);
      if (!res.ok) return;
      const text = await res.text();
      setSvgMarkup(text);
      const parsed = parsePinsFromSvg(text);
      if (parsed.length) setPins(parsed);
      const size = getSvgSize(text);
      if (!autoSizedRef.current && size) {
        if (size.width) setWidth(size.width);
        if (size.height) setHeight(size.height);
        autoSizedRef.current = true;
      }
    } catch (e) {
      console.error('Failed to fetch SVG', e);
    }
  };

  useEffect(() => {
    if (!svgMarkup) return;
    const parsed = parsePinsFromSvg(svgMarkup);
    if (parsed.length) setPins(parsed);
    const size = getSvgSize(svgMarkup);
    if (!autoSizedRef.current && size) {
      if (size.width) setWidth(size.width);
      if (size.height) setHeight(size.height);
      autoSizedRef.current = true;
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [svgMarkup]);

  useEffect(() => {
    if (!isNew) autoSizedRef.current = true;
  }, [isNew]);

  return (
    <div className="max-w-3xl mx-auto pb-20">
      <h1 className="text-2xl font-bold mb-6">{isNew ? 'New Component' : 'Edit Component'}</h1>

      <form action={upsertComponent} className="bg-white p-8 rounded-xl border border-slate-200 space-y-6">
        <input type="hidden" name="id" value={initialComponent.id || ''} />
        <input type="hidden" name="pins" value={hiddenPins} />
        <input type="hidden" name="animations" value={hiddenAnimations} />
        <input type="hidden" name="svg_markup" value={svgMarkup} />

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

        <ImageUpload
          name="image_url"
          defaultValue={initialComponent.image_url}
          label="Component SVG"
          onChange={(url) => {
            setImageUrl(url);
            fetchSvgAndParse(url);
          }}
        />

        <div className="space-y-2">
          <div className="flex items-center justify-between gap-2">
            <label className="block text-sm font-bold">Component SVG (with data-pin-* attributes)</label>
            <div className="text-xs text-slate-500">Pins are auto-detected from the uploaded SVG.</div>
          </div>
          <textarea
            className="w-full p-2 border rounded-lg font-mono text-xs h-40"
            value={svgMarkup}
            onChange={(e) => setSvgMarkup(e.target.value)}
            placeholder='<svg viewBox="0 0 320 210"><circle data-pin-id="13" data-pin-label="13" cx="230" cy="12" r="3" /></svg>'
          />
          <p className="text-xs text-slate-500">
            Add <code>data-pin-id</code> (required) plus optional <code>data-pin-label</code>, <code>data-pin-voltage</code>, and pin positions via <code>cx/cy</code> or <code>data-pin-x</code>/<code>data-pin-y</code>. Pins scale from the SVG viewBox into the component width/height.
          </p>
        </div>

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

        <PinEditor
          imageUrl={imageUrl}
          svgMarkup={svgMarkup}
          type={type}
          width={width || 200}
          height={height || 200}
          value={pins}
          onChange={setPins}
        />

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
