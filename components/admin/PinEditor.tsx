'use client';

import { useEffect, useMemo, useRef, useState } from 'react';
import { Trash2 } from 'lucide-react';

export type PinPoint = { id: string; label?: string; x: number; y: number; voltage?: string; width?: number; height?: number };

type Voltage = '5V' | '3.3V' | 'GND' | 'NORMAL';

export default function PinEditor({
  imageUrl,
  type,
  width,
  height,
  value,
  svgMarkup,
  onChange,
}: {
  imageUrl?: string | null;
  type?: string | null;
  width: number;
  height: number;
  value: PinPoint[];
  svgMarkup?: string | null;
  onChange: (pins: PinPoint[]) => void;
}) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [voltage, setVoltage] = useState<Voltage>('NORMAL');
  const [draggingId, setDraggingId] = useState<string | null>(null);
  const [snapX, setSnapX] = useState<number | null>(null);
  const [snapY, setSnapY] = useState<number | null>(null);
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const selectedRowRef = useRef<HTMLDivElement | null>(null);
  const dragStartRef = useRef<{ mouseX: number; mouseY: number; pins: PinPoint[] } | null>(null);
  const [autoLoading, setAutoLoading] = useState(false);
  const [autoError, setAutoError] = useState<string | null>(null);

  useEffect(() => {
    if (selectedRowRef.current) {
      selectedRowRef.current.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }, [selectedIds]);

  const pins = useMemo(() => value ?? [], [value]);

  const voltageColor = (v?: string) => {
    if (v === '5V') return 'bg-red-500';
    if (v === '3.3V') return 'bg-amber-400';
    if (v === 'GND') return 'bg-gray-600';
    return 'bg-emerald-500';
  };

  const addPinCenter = () => {
    const newPin: PinPoint = {
      id: Math.random().toString(36).slice(2, 9),
      x: Math.round(width / 2),
      y: Math.round(height / 2),
      voltage: voltage === 'NORMAL' ? undefined : voltage,
      label: '',
    };
    onChange([...pins, newPin]);
    setSelectedIds([newPin.id]);
  };

  const startDrag = (id: string, shiftKey: boolean, mouseX: number, mouseY: number) => {
    const currentSelection = shiftKey
      ? selectedIds.includes(id)
        ? selectedIds
        : [...selectedIds, id]
      : selectedIds.includes(id)
        ? selectedIds
        : [id];

    setSelectedIds(currentSelection);
    setDraggingId(id);
    dragStartRef.current = { mouseX, mouseY, pins: pins.map((p) => ({ ...p })) };
  };

  const endDrag = () => {
    setDraggingId(null);
    setSnapX(null);
    setSnapY(null);
  };

  const handleMouseMove = (event: React.MouseEvent<HTMLDivElement>) => {
    if (!draggingId) return;
    const rect = containerRef.current?.getBoundingClientRect();
    if (!rect) return;
    const scaleX = width / rect.width;
    const scaleY = height / rect.height;
    const start = dragStartRef.current;
    if (!start) return;

    const deltaX = (event.clientX - start.mouseX) * scaleX;
    const deltaY = (event.clientY - start.mouseY) * scaleY;
    const selectedSet = new Set(selectedIds.length ? selectedIds : [draggingId]);

    if (selectedSet.size === 1) {
      let x = (event.clientX - rect.left) * scaleX;
      let y = (event.clientY - rect.top) * scaleY;

      const thisPin = pins.find((p) => p.id === draggingId);
      if (!thisPin) return;

      let nearestX: number | null = null;
      let nearestY: number | null = null;
      const snapThreshold = 6;

      pins.forEach((p) => {
        if (p.id === draggingId) return;
        if (Math.abs(p.x - x) < snapThreshold) nearestX = p.x;
        if (Math.abs(p.y - y) < snapThreshold) nearestY = p.y;
      });

      if (nearestX !== null) x = nearestX;
      if (nearestY !== null) y = nearestY;

      setSnapX(nearestX);
      setSnapY(nearestY);

      x = Math.max(0, Math.min(width, x));
      y = Math.max(0, Math.min(height, y));

      onChange(pins.map((p) => (p.id === draggingId ? { ...p, x: Math.round(x), y: Math.round(y) } : p)));
    } else {
      setSnapX(null);
      setSnapY(null);
      const updated = start.pins.map((p) => {
        if (!selectedSet.has(p.id)) return p;
        const nx = Math.max(0, Math.min(width, p.x + deltaX));
        const ny = Math.max(0, Math.min(height, p.y + deltaY));
        return { ...p, x: Math.round(nx), y: Math.round(ny) };
      });
      onChange(updated);
    }
  };

  const updatePin = (id: string, updates: Partial<PinPoint>) => {
    onChange(pins.map((p) => (p.id === id ? { ...p, ...updates } : p)));
  };

  const removePin = (id: string) => onChange(pins.filter((p) => p.id !== id));

  const fetchAutoPins = async () => {
    if (!type) return;
    setAutoLoading(true);
    setAutoError(null);
    try {
      const res = await fetch('/api/components/auto-pins', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to load pins');
      if (data.pins && Array.isArray(data.pins)) {
        onChange(data.pins);
      }
    } catch (e: any) {
      setAutoError(e.message);
    } finally {
      setAutoLoading(false);
    }
  };

  return (
    <div className="space-y-3">
      <div className="flex items-center gap-3 text-sm flex-wrap">
        <span className="font-semibold">Pin type:</span>
        <select
          value={voltage}
          onChange={(e) => setVoltage(e.target.value as Voltage)}
          className="border rounded-lg px-2 py-1 text-sm"
        >
          <option value="NORMAL">Normal</option>
          <option value="5V">5V</option>
          <option value="3.3V">3.3V</option>
          <option value="GND">GND</option>
        </select>
        <button
          type="button"
          onClick={addPinCenter}
          className="px-3 py-1 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-500"
        >
          + Add pin (center)
        </button>
        <button
          type="button"
          disabled={!type || autoLoading}
          onClick={fetchAutoPins}
          className={`px-3 py-1 rounded-lg text-sm border ${!type ? 'bg-gray-200 text-gray-400 cursor-not-allowed' : 'bg-white text-slate-700 hover:bg-blue-50 border-slate-200'}`}
          title={!type ? 'Set a component type to auto-detect pins' : 'Auto-place pins based on component type'}
        >
          {autoLoading ? 'Detecting...' : 'Auto-detect pins'}
        </button>
        <span className="text-xs text-slate-500">Drag pins; guides appear when aligned.</span>
      </div>
      {autoError && <div className="text-xs text-red-500">{autoError}</div>}

      <div
        ref={containerRef}
        onMouseMove={handleMouseMove}
        onMouseLeave={endDrag}
        onMouseUp={endDrag}
        className="relative border rounded-lg overflow-hidden bg-slate-100"
        style={{ width: width ? `${width}px` : '100%', maxWidth: '100%', aspectRatio: `${width}/${height}` }}
      >
        {svgMarkup ? (
          <div
            className="absolute inset-0 pointer-events-none [&_svg]:w-full [&_svg]:h-full [&_svg]:object-contain [&_svg]:overflow-visible"
            dangerouslySetInnerHTML={{ __html: svgMarkup }}
          />
        ) : imageUrl ? (
          <img src={imageUrl} alt="Component" className="w-full h-full object-contain select-none pointer-events-none" />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-slate-400 text-sm bg-slate-200">No image</div>
        )}

        {/* Snap guides */}
        {snapX !== null && (
          <div
            className="absolute inset-y-0 border-l border-blue-400/70 pointer-events-none"
            style={{ left: `${(snapX / width) * 100}%` }}
          />
        )}
        {snapY !== null && (
          <div
            className="absolute inset-x-0 border-t border-blue-400/70 pointer-events-none"
            style={{ top: `${(snapY / height) * 100}%` }}
          />
        )}

        <div className="absolute inset-0">
          {pins.map((pin) => {
            const left = (pin.x / width) * 100;
            const top = (pin.y / height) * 100;
            const pinW = pin.width ?? 10;
            const pinH = pin.height ?? 10;
            const pinWPercent = (pinW / width) * 100;
            const pinHPercent = (pinH / height) * 100;
            return (
              <div
                key={pin.id}
                className={`absolute border-2 border-white shadow cursor-grab active:cursor-grabbing ${voltageColor(pin.voltage)} ${selectedIds.includes(pin.id) ? 'ring-2 ring-blue-400' : ''}`}
                style={{
                  left: `${left}%`,
                  top: `${top}%`,
                  width: `${pinWPercent}%`,
                  height: `${pinHPercent}%`,
                  transform: 'translate(-50%, -50%)',
                  minWidth: '6px',
                  minHeight: '6px',
                }}
                title={pin.label || pin.id}
                onMouseDown={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  startDrag(pin.id, e.shiftKey, e.clientX, e.clientY);
                }}
                onClick={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  if (e.shiftKey) {
                    setSelectedIds((prev) =>
                      prev.includes(pin.id) ? prev.filter((id) => id !== pin.id) : [...prev, pin.id]
                    );
                  } else {
                    setSelectedIds([pin.id]);
                  }
                }}
              />
            );
          })}
        </div>
      </div>

      <div className="bg-slate-50 border rounded-lg p-3">
            <div className="text-xs text-slate-500 mb-2">Pins</div>
            <div className="space-y-2 max-h-48 overflow-auto">
              {pins.map((pin) => (
                <div
                  key={pin.id}
              ref={selectedIds.includes(pin.id) ? selectedRowRef : null}
              className={`flex items-center gap-2 text-sm bg-white border rounded-lg p-2 transition-all ${selectedIds.includes(pin.id) ? 'ring-2 ring-blue-400 shadow-sm' : ''}`}
              onClick={(e) => {
                if (e.shiftKey) {
                  setSelectedIds((prev) =>
                    prev.includes(pin.id) ? prev.filter((id) => id !== pin.id) : [...prev, pin.id]
                  );
                } else {
                  setSelectedIds([pin.id]);
                }
              }}
              >
                <span className={`w-2 h-2 rounded-full ${voltageColor(pin.voltage)}`} />
                <input
                  className="border rounded px-2 py-1 text-xs flex-1"
                  placeholder="Label"
                  value={pin.label || ''}
                  onChange={(e) => updatePin(pin.id, { label: e.target.value })}
                />
              <select
                className="border rounded px-2 py-1 text-xs"
                value={pin.voltage || 'NORMAL'}
                onChange={(e) => updatePin(pin.id, { voltage: e.target.value === 'NORMAL' ? undefined : e.target.value })}
              >
                <option value="NORMAL">Normal</option>
                <option value="5V">5V</option>
                <option value="3.3V">3.3V</option>
                <option value="GND">GND</option>
              </select>
              <span className="text-[10px] text-slate-500">{Math.round(pin.x)}, {Math.round(pin.y)}</span>
              <button type="button" onClick={() => removePin(pin.id)} className="text-red-500 hover:text-red-600">
                <Trash2 size={14} />
              </button>
            </div>
          ))}
          {pins.length === 0 && <div className="text-xs text-slate-400">No pins yet. Use "+ Add pin" to place one.</div>}
        </div>
      </div>
    </div>
  );
}
