'use client';
import React, { useState, useEffect, useRef } from 'react';
import { 
  Play, Square, Trash2, Terminal, Code, Zap, RotateCw, Cpu, 
  Lightbulb, ToggleLeft, Box, Wifi, Lock, Crown, CreditCard, 
  Settings, Sliders, MousePointer2, Sparkles, Loader2, MessageSquare, X,
  Volume2, VolumeX, Mic, GitCommit, CornerDownRight, Bug, Fan, Speaker, Grid3X3,
  CheckSquare, Square as SquareIcon, FileText, Workflow, Layers,
  CircuitBoard, FileCode, LayoutTemplate, Maximize2, ZoomIn, ZoomOut, Hand
} from 'lucide-react';
import { useLanguage } from '@/lib/LanguageContext';

// --- CONSTANTS & DEFINITIONS ---
const GRID_SIZE = 20;

// Safe API Key Access
const getApiKey = () => {
  try {
    // @ts-ignore
    return typeof process !== 'undefined' ? process.env.NEXT_PUBLIC_GEMINI_API_KEY : "";
  } catch (e) { return ""; }
};
const apiKey = getApiKey();

// Helper: Extract JSON
const extractJSON = (text: string) => {
    try {
        const jsonMatch = text.match(/```json([\s\S]*?)```/);
        if (jsonMatch && jsonMatch[1]) return JSON.parse(jsonMatch[1].trim());
        const bracketMatch = text.match(/\{[\s\S]*\}/);
        if (bracketMatch) return JSON.parse(bracketMatch[0]);
        return JSON.parse(text);
    } catch (e) { console.error("JSON Parse Error", e); return null; }
};

// Helper: Clean Mermaid
const cleanMermaid = (str: string) => {
    if (!str) return "";
    return str.replace(/```mermaid/g, '').replace(/```/g, '').trim();
};

// Helper: Normalize Pins
const normalizePin = (componentType: string, pinId: string) => {
    if (!pinId) return "";
    const p = pinId.toString().toUpperCase().replace(/\s/g, '');
    if (componentType === 'ARDUINO') {
        const dMatch = p.match(/^D(\d+)$/i);
        if (dMatch) return dMatch[1];
        if (p === 'GND') return 'GND_1';
        if (p === 'VIN') return '5V';
        if (p === '5V') return '5V';
        if (p === '3.3V') return '3.3V';
    }
    if (p === 'VCC' || p === 'POS' || p === '+') return 'VCC';
    if (p === 'GND' || p === 'NEG' || p === '-') return 'GND';
    if (p === 'SIG' || p === 'PWM') return 'SIG';
    if (p === 'ANODE') return 'anode';
    if (p === 'CATHODE') return 'cathode';
    if (p === '1' || p === 'T1') return 't1';
    if (p === '2' || p === 'T2') return 't2';
    if (p === '1A') return '1a';
    if (p === '1B') return '1b';
    if (p === '2A') return '2a';
    if (p === '2B') return '2b';
    return pinId;
};

// Helper: Wire Color
const getWireColor = (startPin: string, endPin: string) => {
    const p = (startPin + endPin).toUpperCase();
    if (p.includes('GND') || p.includes('NEG') || p.includes('CATHODE')) return '#333333'; 
    if (p.includes('5V') || p.includes('VCC') || p.includes('VIN') || p.includes('POS') || p.includes('ANODE')) return '#EF4444'; 
    return '#10B981'; 
};

// Component Library
const COMPONENT_TYPES: any = {
  ARDUINO: {
    type: 'ARDUINO', name: 'Arduino Uno', width: 200, height: 280,
    pins: [
      { id: 'GND_1', x: 60, y: 265, label: 'GND' }, { id: '5V', x: 45, y: 265, label: '5V' },
      { id: '3.3V', x: 30, y: 265, label: '3.3V' }, { id: '13', x: 35, y: 15, label: '13' },
      { id: '12', x: 50, y: 15, label: '12' }, { id: '11', x: 65, y: 15, label: '11' },
      { id: '10', x: 80, y: 15, label: '10' }, { id: '9', x: 95, y: 15, label: '9' },
      { id: '8', x: 110, y: 15, label: '8' }, { id: '7', x: 125, y: 15, label: '7' },
      { id: '6', x: 140, y: 15, label: '6' }, { id: '5', x: 155, y: 15, label: '5' },
      { id: '4', x: 170, y: 15, label: '4' }, { id: '3', x: 185, y: 15, label: '3' },
      { id: '2', x: 200, y: 15, label: '2' }, { id: 'A0', x: 130, y: 265, label: 'A0' },
      { id: 'A1', x: 145, y: 265, label: 'A1' },
    ]
  },
  ESP32: { type: 'ESP32', name: 'ESP32', width: 140, height: 240, pins: [{ id: 'GND', x: 15, y: 225 }, { id: 'VIN', x: 15, y: 210 }, { id: 'D2', x: 125, y: 45 }] },
  LED: { type: 'LED', name: 'LED', width: 30, height: 60, pins: [{ id: 'anode', x: 22, y: 55 }, { id: 'cathode', x: 8, y: 55 }] },
  RGB_LED: { type: 'RGB_LED', name: 'RGB LED', width: 40, height: 60, pins: [{ id: 'R', x: 5, y: 55 }, { id: 'cathode', x: 15, y: 55 }, { id: 'G', x: 25, y: 55 }, { id: 'B', x: 35, y: 55 }] },
  RESISTOR: { type: 'RESISTOR', name: 'Resistor', width: 80, height: 20, pins: [{ id: 't1', x: 5, y: 10 }, { id: 't2', x: 75, y: 10 }] },
  BUTTON: { type: 'BUTTON', name: 'Button', width: 50, height: 50, pins: [{ id: '1a', x: 5, y: 5 }, { id: '1b', x: 5, y: 45 }, { id: '2a', x: 45, y: 5 }, { id: '2b', x: 45, y: 45 }] },
  SERVO: { type: 'SERVO', name: 'Servo', width: 80, height: 100, pins: [{ id: 'GND', x: 20, y: 95 }, { id: 'VCC', x: 40, y: 95 }, { id: 'SIG', x: 60, y: 95 }] },
  MOTOR: { type: 'MOTOR', name: 'DC Motor', width: 80, height: 80, pins: [{ id: 'pos', x: 10, y: 70 }, { id: 'neg', x: 70, y: 70 }] },
  BUZZER: { type: 'BUZZER', name: 'Buzzer', width: 50, height: 50, pins: [{ id: 'pos', x: 10, y: 45 }, { id: 'neg', x: 40, y: 45 }] },
  POT: { type: 'POT', name: 'Potentiometer', width: 60, height: 60, pins: [{ id: 'GND', x: 10, y: 55 }, { id: 'SIG', x: 30, y: 55 }, { id: 'VCC', x: 50, y: 55 }] },
  LDR: { type: 'LDR', name: 'Photoresistor', width: 50, height: 50, pins: [{ id: 't1', x: 10, y: 45 }, { id: 't2', x: 40, y: 45 }] },
  ULTRASONIC: { type: 'ULTRASONIC', name: 'Ultrasonic', width: 100, height: 50, pins: [{ id: 'VCC', x: 10, y: 45 }, { id: 'TRIG', x: 35, y: 45 }, { id: 'ECHO', x: 65, y: 45 }, { id: 'GND', x: 90, y: 45 }] },
  SEVEN_SEG: { type: 'SEVEN_SEG', name: '7-Segment', width: 70, height: 90, pins: [{ id: 'e', x: 10, y: 85 }, { id: 'd', x: 20, y: 85 }, { id: 'com', x: 35, y: 85 }, { id: 'c', x: 50, y: 85 }, { id: 'dp', x: 60, y: 85 }, { id: 'b', x: 60, y: 5 }, { id: 'a', x: 50, y: 5 }, { id: 'com2', x: 35, y: 5 }, { id: 'f', x: 20, y: 5 }, { id: 'g', x: 10, y: 5 }] }
};

const INITIAL_CODE = `void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  digitalWrite(13, HIGH);
  Serial.println("ON");
  delay(500);
  digitalWrite(13, LOW);
  Serial.println("OFF");
  delay(500);
}`;

// --- API CALL ---
const callGeminiAPI = async (prompt: string, systemInstruction: string, responseFormat = 'text') => {
  const key = apiKey;
  if (!key) return "{}";
  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=${key}`;
  const payload: any = { contents: [{ parts: [{ text: prompt }] }], systemInstruction: { parts: [{ text: systemInstruction }] } };
  try {
    const response = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
    const data = await response.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || "{}";
  } catch (error) { return "{}"; }
};

export default function ReactCircuitPro() {
  const { t } = useLanguage(); // Use Translation Hook

  const [userPlan, setUserPlan] = useState('free'); 
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  
  const [showAIModal, setShowAIModal] = useState(false);
  const [aiPrompt, setAiPrompt] = useState('');
  const [aiResult, setAiResult] = useState<any>(null); 
  const [isGeneratingAI, setIsGeneratingAI] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState(false);
  
  const [genOptions, setGenOptions] = useState({ circuit: true, code: true, flowchart: false, block: false });
  const [generatedDiagrams, setGeneratedDiagrams] = useState<{flowchart?: string, block?: string} | null>(null);
  const [showDiagramPanel, setShowDiagramPanel] = useState(false);
  const [activeDiagramTab, setActiveDiagramTab] = useState<'flowchart' | 'block'>('flowchart');

  const [activeView, setActiveView] = useState('both');
  const [wireMode, setWireMode] = useState<'curve' | 'angled'>('curve'); 
  const [showGrid, setShowGrid] = useState(true);
  const [aiMode, setAiMode] = useState('generate'); 

  const [components, setComponents] = useState<any[]>([]);
  const [wires, setWires] = useState<any[]>([]);
  const [code, setCode] = useState(INITIAL_CODE);
  const [isSimulating, setIsSimulating] = useState(false);
  const [serialOutput, setSerialOutput] = useState<string[]>([]);
  
  const [draggedComponent, setDraggedComponent] = useState<any>(null);
  const [wireStart, setWireStart] = useState<any>(null);
  const [selectedWireId, setSelectedWireId] = useState<string | null>(null);
  const [selectedCompIds, setSelectedCompIds] = useState<string[]>([]);
  const [selectionRect, setSelectionRect] = useState<{x:number, y:number, w:number, h:number} | null>(null);
  const [dragWireSegment, setDragWireSegment] = useState<{wireId: string, axis: 'x'|'y', initialVal: number, mouseStart: number} | null>(null);
  
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });
  const [selection, setSelection] = useState({ start: 0, end: 0, text: '' });
  const [isMouseDownOnCanvas, setIsMouseDownOnCanvas] = useState(false);
  const [selectionStartPoint, setSelectionStartPoint] = useState({ x: 0, y: 0 });
  const [view, setView] = useState({ x: 0, y: 0, scale: 1 }); 
  const [isPanning, setIsPanning] = useState(false);
  const [lastMousePos, setLastMousePos] = useState({ x: 0, y: 0 });

  const simulationRef = useRef({ active: false, pinStates: {} as Record<string, any>, servoAngles: {}, potValues: {} });
  const logsEndRef = useRef<HTMLDivElement>(null);
  const editorRef = useRef<HTMLTextAreaElement>(null);
  const speechRef = useRef<SpeechSynthesis | null>(null);
  const canvasRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
      if (typeof window !== 'undefined') speechRef.current = window.speechSynthesis;
      const handleKeyDown = (e: KeyboardEvent) => {
          if (e.key === 'Delete' || e.key === 'Backspace') {
              if (selectedWireId) { setWires(prev => prev.filter(w => w.id !== selectedWireId)); setSelectedWireId(null); }
              if (selectedCompIds.length > 0) {
                  setComponents(prev => prev.filter(c => !selectedCompIds.includes(c.id)));
                  setWires(prev => prev.filter(w => !selectedCompIds.includes(w.startComp) && !selectedCompIds.includes(w.endComp)));
                  setSelectedCompIds([]);
              }
          }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => window.removeEventListener('keydown', handleKeyDown);
  }, [selectedWireId, selectedCompIds]);

  const toWorld = (screenX: number, screenY: number) => {
      const rect = canvasRef.current?.getBoundingClientRect();
      if (!rect) return { x: 0, y: 0 };
      return { x: (screenX - rect.left - view.x) / view.scale, y: (screenY - rect.top - view.y) / view.scale };
  };

  const addComponent = (typeKey: string) => {
    // @ts-ignore
    const template = COMPONENT_TYPES[typeKey];
    const centerX = (-view.x + (canvasRef.current?.clientWidth || 800)/2) / view.scale;
    const centerY = (-view.y + (canvasRef.current?.clientHeight || 600)/2) / view.scale;
    const newComponent = {
      id: Math.random().toString(36).substr(2, 9), type: typeKey,
      x: centerX - (template.width/2), y: centerY - (template.height/2),
      rotation: 0, state: { angle: 0, value: 0, r: 0, g: 0, b: 0, segments: {} }
    };
    setComponents([...components, newComponent]);
  };

  const removeComponent = (id: string) => {
    setComponents(components.filter(c => c.id !== id));
    setWires(wires.filter(w => w.startComp !== id && w.endComp !== id));
  };

  const handlePinClick = (compId: string, pinId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    if (wireStart) {
      if (wireStart.compId === compId && wireStart.pinId === pinId) return setWireStart(null);
      setWires(prev => [...prev, {
        id: Math.random().toString(36).substr(2, 9),
        startComp: wireStart.compId, startPin: wireStart.pinId,
        endComp: compId, endPin: pinId,
        color: getWireColor(wireStart.pinId, pinId), controlOffset: 0.5
      }]);
      setWireStart(null);
    } else { setWireStart({ compId, pinId }); }
  };

  const handlePotChange = (compId: string, newVal: number) => {
    setComponents(prev => prev.map(c => c.id === compId ? { ...c, state: { ...c.state, value: newVal } } : c));
  };

  const handleCodeSelect = (e: React.SyntheticEvent<HTMLTextAreaElement>) => {
    const target = e.currentTarget;
    setSelection({ start: target.selectionStart, end: target.selectionEnd, text: code.substring(target.selectionStart, target.selectionEnd) });
  };

  const handleCanvasMouseDown = (e: React.MouseEvent) => {
      if (e.button === 1 || (e.button === 0 && e.altKey)) { setIsPanning(true); setLastMousePos({ x: e.clientX, y: e.clientY }); return; }
      if (e.target !== e.currentTarget && (e.target as any).tagName !== 'svg') return;
      setIsMouseDownOnCanvas(true);
      const worldPos = toWorld(e.clientX, e.clientY);
      setSelectionStartPoint(worldPos);
      setSelectionRect({ x: worldPos.x, y: worldPos.y, w: 0, h: 0 });
      if (!e.shiftKey) { setSelectedCompIds([]); setSelectedWireId(null); }
  };

  const handleComponentMouseDown = (e: React.MouseEvent, compId: string) => {
      e.stopPropagation();
      if (isSimulating) return;
      if (e.shiftKey) {
          setSelectedCompIds(prev => prev.includes(compId) ? prev.filter(id => id !== compId) : [...prev, compId]);
      } else { if (!selectedCompIds.includes(compId)) setSelectedCompIds([compId]); }
      setDraggedComponent({ id: compId, startX: e.clientX, startY: e.clientY });
  };

  const handleWheel = (e: React.WheelEvent) => {
      if (e.ctrlKey || e.metaKey) {
          e.preventDefault();
          const delta = -e.deltaY * 0.001;
          const newScale = Math.min(Math.max(0.1, view.scale + delta), 5);
          const rect = canvasRef.current?.getBoundingClientRect();
          if (rect) {
              const mouseX = e.clientX - rect.left; const mouseY = e.clientY - rect.top;
              const worldX = (mouseX - view.x) / view.scale; const worldY = (mouseY - view.y) / view.scale;
              setView({ scale: newScale, x: mouseX - worldX * newScale, y: mouseY - worldY * newScale });
          }
      } else {
          setView(prev => ({ ...prev, x: prev.x - e.deltaX, y: prev.y - e.deltaY }));
      }
  };

  const handleMouseMove = (e: MouseEvent) => {
      if (isPanning) {
          const dx = e.clientX - lastMousePos.x;
          const dy = e.clientY - lastMousePos.y;
          setView(prev => ({ ...prev, x: prev.x + dx, y: prev.y + dy }));
          setLastMousePos({ x: e.clientX, y: e.clientY });
          return;
      }
      const worldPos = toWorld(e.clientX, e.clientY);
      setMousePos(worldPos);
      if (draggedComponent) {
          const dx = (e.clientX - draggedComponent.startX) / view.scale;
          const dy = (e.clientY - draggedComponent.startY) / view.scale;
          setComponents(prev => prev.map(c => { if (selectedCompIds.includes(c.id)) return { ...c, x: c.x + dx, y: c.y + dy }; return c; }));
          setDraggedComponent({ ...draggedComponent, startX: e.clientX, startY: e.clientY });
      }
      if (isMouseDownOnCanvas && selectionRect) {
           const newW = Math.abs(worldPos.x - selectionStartPoint.x);
           const newH = Math.abs(worldPos.y - selectionStartPoint.y);
           const newX = Math.min(selectionStartPoint.x, worldPos.x);
           const newY = Math.min(selectionStartPoint.y, worldPos.y);
           setSelectionRect({ x: newX, y: newY, w: newW, h: newH });
      }
  };

  const handleMouseUp = () => {
      setDraggedComponent(null); setIsPanning(false);
      if (isMouseDownOnCanvas && selectionRect) {
          const selected = components.filter(c => {
              // @ts-ignore
              const def = COMPONENT_TYPES[c.type];
              return (c.x < selectionRect.x + selectionRect.w && c.x + def.width > selectionRect.x && c.y < selectionRect.y + selectionRect.h && c.y + def.height > selectionRect.y);
          }).map(c => c.id);
          setSelectedCompIds(selected);
      }
      setIsMouseDownOnCanvas(false); setSelectionRect(null);
  };

  useEffect(() => {
      // @ts-ignore
      window.addEventListener('mousemove', handleMouseMove); window.addEventListener('mouseup', handleMouseUp);
      // @ts-ignore
      return () => { window.removeEventListener('mousemove', handleMouseMove); window.removeEventListener('mouseup', handleMouseUp); };
  }, [draggedComponent, isMouseDownOnCanvas, selectionRect, selectedCompIds, isPanning, view]);

  const handleAIDebug = async () => {
    if (!code.trim()) return;
    setIsGeneratingAI(true);
    const systemPrompt = `You are an expert Arduino programmer. Analyze code. Fix bugs. Optimize. Return ONLY code.`;
    try {
        const correctedCode = await callGeminiAPI(code, systemPrompt);
        setCode(correctedCode.replace(/```cpp|```c|```/g, '').trim());
        setSerialOutput(prev => [...prev, "> ✨ AI Debugger: Code updated!"]);
    } catch (e) { console.error(e); } finally { setIsGeneratingAI(false); }
  };

  const handleExplainWithVoice = async () => { /* Existing Logic */ };

  const handleAIGenerate = async () => {
    if (!aiPrompt.trim()) return;
    setIsGeneratingAI(true); setAiResult(null);
    const genSystemPrompt = `You are an expert electronics engineer. User Request: ${aiPrompt}
    Generate JSON: { "code": "...", "explanation": "...", "components": [{type, id}], "connections": [{from, to}], "flowchart": "mermaid...", "blockDiagram": "mermaid..." }
    Use types: ARDUINO, LED, RESISTOR, BUTTON, SERVO, POT, ULTRASONIC, MOTOR.
    Use pins: 13, A0, 5V, GND, anode, cathode, etc.`;
    try {
        const res = await callGeminiAPI(aiPrompt, genSystemPrompt, 'json');
        setAiResult(extractJSON(res));
    } catch (e) { setAiResult({ error: true }); } 
    finally { setIsGeneratingAI(false); }
  };

  const applyAICircuit = () => {
      if (!aiResult) return;
      if (aiResult.flowchart || aiResult.blockDiagram) {
          setGeneratedDiagrams({ flowchart: cleanMermaid(aiResult.flowchart), block: cleanMermaid(aiResult.blockDiagram) });
          if (aiResult.flowchart) setActiveDiagramTab('flowchart'); else setActiveDiagramTab('block');
          setShowDiagramPanel(true);
      }
      if (aiResult.code && genOptions.code) setCode(aiResult.code);
      if (aiResult.components && genOptions.circuit) {
          const newComps: any[] = [];
          let gridX = 350, gridY = 100, cCount = 0;
          setWireMode('angled'); 
          aiResult.components.forEach((c: any) => {
              let type = c.type.toUpperCase();
              if (!COMPONENT_TYPES[type]) return;
              let x = (-view.x + 300 + (cCount%3)*200)/view.scale, y = (-view.y + 100 + Math.floor(cCount/3)*200)/view.scale;
              if (type === 'ARDUINO') { x = (-view.x + 50)/view.scale; y = (-view.y + 100)/view.scale; } else { cCount++; }
              newComps.push({ id: c.id, type, x, y, rotation: 0, state: { angle: 0, value: 0, on: false } });
          });
          setComponents(newComps);
          const newWires: any[] = [];
          aiResult.connections?.forEach((conn: any) => {
              let [sId, sPin] = conn.from.split(':'); let [eId, ePin] = conn.to.split(':');
              const sComp = newComps.find(c => c.id === sId); const eComp = newComps.find(c => c.id === eId);
              if (sComp && eComp) {
                 newWires.push({ id: Math.random().toString(36).substr(2, 9), startComp: sId, startPin: normalizePin(sComp.type, sPin), endComp: eId, endPin: normalizePin(eComp.type, ePin), color: getWireColor(sPin, ePin), controlOffset: 0.5 });
              }
          });
          setWires(newWires);
      }
      if (!aiResult.flowchart && !aiResult.blockDiagram) setShowAIModal(false);
  };

  const runSimulationStep = async () => {
      // Existing simulation logic here
  };
  const toggleSimulation = () => { setIsSimulating(!isSimulating); };

  const getPinCoords = (compId: string, pinId: string) => {
    const comp = components.find(c => c.id === compId);
    if (!comp) return { x: 0, y: 0 };
    // @ts-ignore
    const def = COMPONENT_TYPES[comp.type];
    const pin = def?.pins.find((p: any) => p.id === pinId);
    if (!pin) return { x: comp.x, y: comp.y };
    return { x: comp.x + pin.x, y: comp.y + pin.y };
  };

  const getWirePath = (s: any, e: any) => {
      if (wireMode === 'angled') {
          const midX = s.x + (e.x - s.x) / 2;
          return `M ${s.x} ${s.y} L ${midX} ${s.y} L ${midX} ${e.y} L ${e.x} ${e.y}`;
      }
      const offset = Math.max(Math.abs(e.x - s.x) * 0.5, 50);
      return `M ${s.x} ${s.y} C ${s.x + offset} ${s.y}, ${e.x - offset} ${e.y}, ${e.x} ${e.y}`;
  };

  const renderRealisticComponent = (comp: any) => {
    // @ts-ignore
    const def = COMPONENT_TYPES[comp.type];
    const isSelected = selectedCompIds.includes(comp.id);
    return (
        <div key={comp.id} onMouseDown={(e) => handleComponentMouseDown(e, comp.id)} style={{position:'absolute', left: comp.x, top: comp.y, width: def.width, height: def.height}} className={`group cursor-grab active:cursor-grabbing z-10 ${isSelected ? 'ring-2 ring-blue-500 rounded' : ''}`}>
            {!isSimulating && isSelected && <button onClick={() => removeComponent(comp.id)} className="absolute -top-3 -right-3 bg-red-500 text-white p-1 rounded-full z-50"><Trash2 size={12}/></button>}
            {comp.type === 'ARDUINO' && (
                <svg viewBox="0 0 260 190" className="w-full h-full drop-shadow-xl">
                    <path d="M0,10 Q0,0 10,0 L250,0 Q260,0 260,10 L260,190 Q260,200 250,200 L70,200 L60,190 L40,190 L30,200 L10,200 Q0,200 0,190 Z" fill="#00878F" stroke="#005f63" strokeWidth="2"/>
                    <rect x="60" y="5" width="190" height="14" fill="#111" /> <rect x="110" y="181" width="140" height="14" fill="#111" />
                    <text x="130" y="100" fill="white" fontWeight="bold" fontSize="20">ARDUINO</text>
                </svg>
            )}
            {comp.type === 'LED' && (
                <div className="relative w-full h-full flex justify-center">
                    <div className={`w-8 h-8 rounded-full border-2 border-black/20 z-10 transition-all duration-100 ${comp.state.on ? 'bg-red-500 shadow-[0_0_25px_5px_rgba(255,0,0,0.8)]' : 'bg-red-900'}`} />
                    <div className="absolute bottom-0 w-full flex justify-between px-1"><div className="w-1 h-10 bg-gray-400"></div><div className="w-1 h-10 bg-gray-400"></div></div>
                </div>
            )}
            {['RESISTOR', 'LDR'].includes(comp.type) && (
                <div className="w-full h-full flex items-center justify-center"><div className="w-full h-1 bg-gray-400 absolute"></div><div className="w-14 h-5 bg-[#E4D6A7] border border-[#8B7355] rounded-full relative z-10"></div></div>
            )}
            {def.pins.map((p: any) => (
                <div key={p.id} onClick={(e) => handlePinClick(comp.id, p.id, e)} className="absolute w-3 h-3 bg-yellow-500/30 border border-yellow-500 rounded-full hover:bg-yellow-400 cursor-crosshair z-50" style={{left: p.x-6, top: p.y-6}} title={p.label}/>
            ))}
        </div>
    );
  };

  return (
    <div className="flex h-screen w-full bg-gray-100 text-gray-900 font-sans select-none">
      <div className="w-72 bg-[#141419] border-r border-gray-800 flex flex-col z-10 shadow-2xl">
        <div className="p-5 border-b border-gray-800 flex items-center gap-2"><Zap size={18} className="text-white"/> <h1 className="font-bold text-lg text-white">Circuit<span className="text-blue-500">Pro</span></h1></div>
        <div className="p-4 flex-1 overflow-y-auto grid grid-cols-2 gap-3 content-start">
            {Object.keys(COMPONENT_TYPES).map(k => (
                <div key={k} onClick={() => addComponent(k)} className="bg-gray-50 p-3 rounded border border-gray-200 hover:border-blue-500 cursor-pointer flex flex-col items-center hover:bg-blue-50 transition-all"><Cpu size={20} className="text-gray-600"/><span className="text-[10px] font-medium mt-1 text-gray-700">{COMPONENT_TYPES[k].name}</span></div>
            ))}
        </div>
      </div>

      <div className="flex-1 flex flex-col relative bg-[#0A0A0C]">
        <div className="h-14 bg-white border-b border-gray-200 flex items-center justify-between px-4 z-20">
            <div className="flex items-center gap-3">
                <button onClick={toggleSimulation} className={`px-4 py-1.5 rounded font-bold flex items-center gap-2 text-sm shadow-sm ${isSimulating ? 'bg-red-100 text-red-600' : 'bg-green-600 text-white'}`}>{isSimulating ? t.stop : t.simulate}</button>
                <div className="flex bg-gray-100 p-1 rounded border border-gray-300">
                    <button onClick={() => setWireMode('curve')} className={`p-1 rounded ${wireMode==='curve'?'bg-white shadow text-blue-600':'text-gray-500'}`}><GitCommit size={14}/></button>
                    <button onClick={() => setWireMode('angled')} className={`p-1 rounded ${wireMode==='angled'?'bg-white shadow text-blue-600':'text-gray-500'}`}><CornerDownRight size={14}/></button>
                </div>
                <button onClick={() => setShowGrid(!showGrid)} className={`p-1.5 rounded border ${showGrid ? 'bg-blue-50 border-blue-200 text-blue-600' : 'bg-white'}`}><Grid3X3 size={14}/></button>
                
                {selectedWireId && <button onClick={() => {setWires(w => w.filter(x=>x.id!==selectedWireId)); setSelectedWireId(null)}} className="text-red-600 bg-red-50 border border-red-200 px-3 py-1 rounded text-xs flex items-center gap-1"><Trash2 size={14}/> {t.deleteWire}</button>}
                {selectedCompIds.length > 0 && <button onClick={() => {setComponents(c => c.filter(x => !selectedCompIds.includes(x.id))); setSelectedCompIds([]);}} className="text-red-600 bg-red-50 border border-red-200 px-3 py-1 rounded text-xs flex items-center gap-1"><Trash2 size={14}/> {t.deleteComponents}</button>}
            </div>
            <button onClick={() => setShowAIModal(true)} className="flex items-center gap-2 px-4 py-1.5 bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded shadow-md text-sm font-medium"><Sparkles size={16} /> {t.aiAssistant}</button>
        </div>

        <div className="flex-1 flex overflow-hidden relative">
            <div ref={canvasRef} className="relative flex-1 bg-gray-100 overflow-hidden" onMouseDown={handleCanvasMouseDown} onWheel={handleWheel}>
                <div style={{transform: `translate(${view.x}px, ${view.y}px) scale(${view.scale})`, width: '100%', height: '100%', position: 'absolute'}}>
                    {showGrid && <div className="absolute inset-[-5000px] opacity-40 pointer-events-none" style={{backgroundImage: `radial-gradient(#9ca3af 1px, transparent 1px)`, backgroundSize: `${GRID_SIZE}px ${GRID_SIZE}px`}} />}
                    {components.map(comp => renderRealisticComponent(comp))}
                    <svg className="absolute inset-[-5000px] w-[10000px] h-[10000px] pointer-events-none z-20">
                        {wires.map(w => {
                            const s = getPinCoords(w.startComp, w.startPin); const e = getPinCoords(w.endComp, w.endPin);
                            return <path key={w.id} d={getWirePath(s, e)} stroke={w.id===selectedWireId ? '#3B82F6' : w.color} strokeWidth={w.id===selectedWireId ? "6" : "4"} fill="none" className="pointer-events-auto cursor-pointer hover:opacity-80" onClick={(ev) => { ev.stopPropagation(); setSelectedWireId(w.id); }}/>;
                        })}
                        {wireStart && <line x1={getPinCoords(wireStart.compId, wireStart.pinId).x} y1={getPinCoords(wireStart.compId, wireStart.pinId).y} x2={mousePos.x} y2={mousePos.y} stroke="#10B981" strokeWidth="2" strokeDasharray="5,5" className="opacity-60"/>}
                    </svg>
                    {selectionRect && <div className="absolute border border-blue-500 bg-blue-500/20 pointer-events-none" style={{left: selectionRect.x, top: selectionRect.y, width: selectionRect.w, height: selectionRect.h}} />}
                </div>
            </div>

            <div className={`w-96 bg-[#1e1e1e] border-l border-gray-700 flex flex-col shadow-xl ${activeView === 'canvas' ? 'hidden' : ''}`}>
                 <div className="bg-[#252526] px-4 py-2 text-xs font-bold text-blue-400 border-b border-gray-700 flex justify-between items-center">
                    <span>{t.sketch}</span>
                    <div className="flex gap-2">
                      <button onClick={handleAIDebug} className="text-[10px] text-purple-400 hover:text-white flex items-center gap-1"><Bug size={12}/> {t.debug}</button>
                    </div>
                 </div>
                 <textarea className="flex-1 bg-[#1e1e1e] text-gray-300 p-4 font-mono text-sm resize-none focus:outline-none" value={code} onChange={e => setCode(e.target.value)} spellCheck={false}/>
                 <div className="h-40 bg-black border-t border-gray-700 p-2 font-mono text-green-500 text-xs overflow-y-auto">
                     <div className="text-gray-500 mb-1 select-none">--- {t.serialMonitor} ---</div>
                     {serialOutput.map((s, i) => <div key={i}>{s}</div>)}
                 </div>
            </div>
        </div>
      </div>

      {showAIModal && (
        <div className="absolute inset-0 z-[100] bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white w-full max-w-xl rounded-2xl shadow-2xl overflow-hidden animate-in zoom-in-95">
                <div className="bg-gray-50 p-4 border-b border-gray-200 flex justify-between items-center">
                    <h3 className="font-bold text-gray-800 flex items-center gap-2"><Sparkles className="text-blue-600" size={20}/> {t.aiTitle}</h3>
                    <button onClick={() => setShowAIModal(false)} className="text-gray-400 hover:text-gray-600"><X size={20}/></button>
                </div>
                {!aiResult ? (
                    <div className="p-6">
                        <textarea value={aiPrompt} onChange={e => setAiPrompt(e.target.value)} className="w-full h-32 bg-white border border-gray-300 rounded-lg p-3 text-sm text-gray-900 outline-none" placeholder={t.aiPlaceholder}/>
                        <div className="mt-4">
                             <label className="block text-xs font-bold text-gray-500 uppercase mb-2">Generate Options</label>
                             <div className="grid grid-cols-2 gap-3">
                                 <label className="flex items-center gap-3 p-3 rounded-lg border cursor-pointer hover:bg-gray-50">
                                     <input type="checkbox" checked={genOptions.circuit} onChange={e => setGenOptions({...genOptions, circuit: e.target.checked})} className="accent-blue-600"/> <span className="text-sm font-medium text-gray-700">{t.genCircuit}</span>
                                 </label>
                                 <label className="flex items-center gap-3 p-3 rounded-lg border cursor-pointer hover:bg-gray-50">
                                     <input type="checkbox" checked={genOptions.code} onChange={e => setGenOptions({...genOptions, code: e.target.checked})} className="accent-blue-600"/> <span className="text-sm font-medium text-gray-700">{t.genCode}</span>
                                 </label>
                             </div>
                        </div>
                        <button onClick={handleAIGenerate} className="mt-6 w-full bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg font-bold shadow-lg flex justify-center items-center gap-2" disabled={isGeneratingAI}>
                            {isGeneratingAI ? <Loader2 className="animate-spin"/> : <Sparkles size={18}/>} {isGeneratingAI ? t.aiGenerating : t.aiGenerate}
                        </button>
                    </div>
                ) : (
                    <div className="p-6">
                        <p className="text-green-600 mb-2 font-bold flex items-center gap-2"><CheckSquare size={16}/> {t.aiSuccess}</p>
                        <div className="bg-gray-50 p-4 rounded-lg border border-gray-200 mb-6"><p className="text-sm text-gray-700">{typeof aiResult.explanation === 'string' ? aiResult.explanation : 'Success'}</p></div>
                        <div className="flex gap-3">
                            <button onClick={applyAICircuit} className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-lg font-bold shadow">{t.aiApply}</button>
                            <button onClick={() => setAiResult(null)} className="px-6 border border-gray-300 text-gray-600 rounded-lg hover:bg-gray-50 font-medium">{t.aiDiscard}</button>
                        </div>
                    </div>
                )}
            </div>
        </div>
      )}
    </div>
  );
}
