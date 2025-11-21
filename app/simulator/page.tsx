'use client';
import React, { useState, useEffect, useRef } from 'react';
import { 
  Play, Square, Trash2, Terminal, Code, Zap, RotateCw, Cpu, 
  Lightbulb, ToggleLeft, Box, Wifi, Lock, Crown, CreditCard, 
  Settings, Sliders, MousePointer2, Sparkles, Loader2, MessageSquare, X,
  Volume2, VolumeX, Mic, GitCommit, CornerDownRight, Bug, Fan, Speaker, Grid3X3,
  CheckSquare, Square as SquareIcon, FileText, Workflow, Layers,
  CircuitBoard, FileCode, LayoutTemplate, Maximize2, ZoomIn, ZoomOut, Hand,
  Sun, Moon, MousePointerClick, ArrowRight, ArrowLeftRight, Shuffle
} from 'lucide-react';

// --- INTERNAL TRANSLATIONS ---
const useLanguage = () => {
  return {
    t: {
      stop: "Stop",
      simulate: "Simulate",
      deleteWire: "Delete Wire",
      deleteComponents: "Delete Components",
      serialMonitor: "Serial Monitor",
      aiTitle: "AI Assistant",
      aiPlaceholder: "Describe a circuit (e.g., 'Arduino blinking an LED on pin 13')...",
      genCircuit: "Circuit",
      genCode: "Code",
      genFlowchart: "Flowchart",
      genBlock: "Block Diagram",
      aiGenerating: "Generating...",
      aiGenerate: "Generate",
      aiSuccess: "Generated Successfully",
      aiApply: "Apply Changes",
      aiDiscard: "Discard"
    }
  };
};

// --- CONSTANTS & DEFINITIONS ---

const GRID_SIZE = 20;
const apiKey = "";

// --- HELPER: Extract JSON from AI Response ---
const extractJSON = (text: string) => {
    try {
        const jsonMatch = text.match(/```json([\s\S]*?)```/);
        if (jsonMatch && jsonMatch[1]) return JSON.parse(jsonMatch[1].trim());
        
        const bracketMatch = text.match(/\{[\s\S]*\}/);
        if (bracketMatch) return JSON.parse(bracketMatch[0]);
        
        return JSON.parse(text);
    } catch (e) {
        console.error("JSON Parse Error", e);
        return null;
    }
};

// --- HELPER: Clean Mermaid Syntax ---
const cleanMermaid = (str: string) => {
    if (!str) return "";
    return str.replace(/```mermaid/g, '').replace(/```/g, '').trim();
};

// --- HELPER: Normalize Pin IDs ---
const normalizePin = (componentType: string, pinId: string) => {
  if (!pinId) return '';
  const p = pinId.toString().toUpperCase().replace(/\s/g, '');

  if (componentType === 'ARDUINO') {
    const dMatch = p.match(/^D?(\d+)$/i);
    if (dMatch) return dMatch[1];

    const analogMatch = p.match(/^A(\d)$/i);
    if (analogMatch) return `A${analogMatch[1]}`;

    const powerMap: Record<string, string> = {
      'GND': 'GND1',
      'GND1': 'GND1',
      'GND2': 'GND2',
      'GND3': 'GND3',
      'GND_TOP': 'GND1',
      'VIN': 'VIN',
      '5V': '5V',
      '3.3V': '3.3V',
      'IOREF': 'IOREF',
      'RESET': 'RESET',
      'AREF': 'AREF',
      'SDA': 'SDA',
      'SCL': 'SCL',
    };
    if (powerMap[p]) return powerMap[p];
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

// --- HELPER: Get Wire Color ---
const getWireColor = (startPin: string, endPin: string) => {
    const p = (startPin + endPin).toUpperCase();
    if (p.includes('GND') || p.includes('NEG') || p.includes('CATHODE')) return '#333333'; // Black/Dark Grey
    if (p.includes('5V') || p.includes('VCC') || p.includes('VIN') || p.includes('POS') || p.includes('ANODE')) return '#EF4444'; // Red
    return '#10B981'; // Default Green
};

type ComponentPin = {
  id: string;
  label?: string | null;
  x: number;
  y: number;
  voltage?: string | null;
};

type ComponentDefinition = {
  id: string;
  name: string;
  type: string;
  slug: string;
  category?: string | null;
  image_url?: string | null;
  width: number;
  height: number;
  pins: ComponentPin[];
  metadata?: Record<string, any>;
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
  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=${key}`;
  const payload: any = {
    contents: [{ parts: [{ text: prompt }] }],
    systemInstruction: { parts: [{ text: systemInstruction }] },
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const data = await response.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || "{}";
  } catch (error) {
    console.error("API Call Failed", error);
    return "{}";
  }
};

// --- UI COMPONENTS ---

const ToolbarButton = ({ onClick, icon: Icon, label, active = false, disabled = false, color = "blue" }: any) => (
  <button
    onClick={onClick}
    disabled={disabled}
    className={`p-2 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group relative
      ${active 
        ? 'bg-blue-100 text-blue-600 dark:bg-blue-900/40 dark:text-blue-300' 
        : 'hover:bg-gray-100 text-gray-600 dark:hover:bg-gray-700 dark:text-gray-400'}
      ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
    `}
    title={label}
  >
    <Icon size={18} />
    {label && <span className="sr-only">{label}</span>}
  </button>
);

export default function ReactCircuitPro() {
  const { t } = useLanguage();

  // State
  const [showAIModal, setShowAIModal] = useState(false);
  const [aiPrompt, setAiPrompt] = useState('');
  const [aiResult, setAiResult] = useState<any>(null); 
  const [isGeneratingAI, setIsGeneratingAI] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState(false);
  
  const [genOptions, setGenOptions] = useState({
      circuit: true,
      code: true,
      flowchart: false,
      block: false
  });

  const [generatedDiagrams, setGeneratedDiagrams] = useState<{flowchart?: string, block?: string} | null>(null);
  const [showDiagramPanel, setShowDiagramPanel] = useState(false);
  const [activeDiagramTab, setActiveDiagramTab] = useState<'flowchart' | 'block'>('flowchart');

  const [activeView, setActiveView] = useState('both');
  const [wireMode, setWireMode] = useState<'curve' | 'angled'>('curve'); 
  const [showGrid, setShowGrid] = useState(true);
  const [darkMode, setDarkMode] = useState(true); 

  const [componentLibrary, setComponentLibrary] = useState<Record<string, ComponentDefinition>>({});
  const [libraryLoading, setLibraryLoading] = useState(true);
  const [libraryError, setLibraryError] = useState<string | null>(null);

  const [components, setComponents] = useState<any[]>([]);
  const [wires, setWires] = useState<any[]>([]);
  const [code, setCode] = useState(INITIAL_CODE);
  const [isSimulating, setIsSimulating] = useState(false);
  const [serialOutput, setSerialOutput] = useState<string[]>([]);
  
  const [draggedComponent, setDraggedComponent] = useState<any>(null);
  const [wireStart, setWireStart] = useState<any>(null);
  const [selectedWireId, setSelectedWireId] = useState<string | null>(null);
  const [wireColorPickerOpen, setWireColorPickerOpen] = useState(false);
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
  const prevPinPowerRef = useRef<Record<string, Record<string, boolean>>>({});
  const logsEndRef = useRef<HTMLDivElement>(null);
  const editorRef = useRef<HTMLTextAreaElement>(null);
  const speechRef = useRef<SpeechSynthesis | null>(null);
  const canvasRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
      if (typeof window !== 'undefined') speechRef.current = window.speechSynthesis;
      
      const handleKeyDown = (e: KeyboardEvent) => {
          if (e.key === 'Delete' || e.key === 'Backspace') {
              if (selectedWireId) {
                  setWires(prev => prev.filter(w => w.id !== selectedWireId));
                  setSelectedWireId(null);
              }
              if (selectedCompIds.length > 0) {
                  // Deleting components also deletes wires attached to them
                  const compIdsToDelete = selectedCompIds;
                  setComponents(prev => prev.filter(c => !compIdsToDelete.includes(c.id)));
                  setWires(prev => prev.filter(w => !compIdsToDelete.includes(w.startComp) && !compIdsToDelete.includes(w.endComp)));
                  setSelectedCompIds([]);
              }
          }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => window.removeEventListener('keydown', handleKeyDown);
  }, [selectedWireId, selectedCompIds]);

  useEffect(() => {
    const fetchComponents = async () => {
      try {
        const res = await fetch('/api/components');
        if (!res.ok) throw new Error('Failed to load component library');
        const payload = await res.json();
        const defs = Array.isArray(payload.components) ? payload.components : [];
        const mapped = defs.reduce((acc: Record<string, ComponentDefinition>, item: ComponentDefinition) => {
          if (!item?.type) return acc;
          const key = item.type.toUpperCase();
          acc[key] = { ...item, type: key, pins: Array.isArray(item.pins) ? item.pins : [] };
          return acc;
        }, {});
        setComponentLibrary(mapped);
      } catch (err: any) {
        setLibraryError(err?.message || 'Unable to load components');
      } finally {
        setLibraryLoading(false);
      }
    };

    fetchComponents();
  }, []);

  // --- VIEW HELPERS ---
  const toWorld = (screenX: number, screenY: number) => {
      const rect = canvasRef.current?.getBoundingClientRect();
      if (!rect) return { x: 0, y: 0 };
      return { x: (screenX - rect.left - view.x) / view.scale, y: (screenY - rect.top - view.y) / view.scale };
  };

  const getComponentDef = (typeKey: string) => {
    const key = typeKey?.toUpperCase?.() ?? typeKey;
    return componentLibrary[key] ?? null;
  };

  const getComponentDimensions = (typeKey: string) => {
    const def = getComponentDef(typeKey);
    return { width: def?.width ?? 60, height: def?.height ?? 40 };
  };

  // --- ACTIONS ---

  const addComponent = (typeKey: string) => {
    const template = getComponentDef(typeKey);
    if (!template) return;
    const centerX = (-view.x + (canvasRef.current?.clientWidth || 800)/2) / view.scale;
    const centerY = (-view.y + (canvasRef.current?.clientHeight || 600)/2) / view.scale;

    const newComponent = {
      id: Math.random().toString(36).substr(2, 9),
      type: typeKey,
      x: centerX - (template.width/2),
      y: centerY - (template.height/2),
      rotation: 0,
      state: { angle: 0, value: 0, r: 0, g: 0, b: 0, segments: {}, animationValue: null }
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
      const color = getWireColor(wireStart.pinId, pinId);
      setWires(prev => [...prev, {
        id: Math.random().toString(36).substr(2, 9),
        startComp: wireStart.compId, startPin: wireStart.pinId,
        endComp: compId, endPin: pinId,
        color: color,
        controlOffset: 0.5,
        axis: 'x' // Default axis
      }]);
      setWireStart(null);
    } else {
      setWireStart({ compId, pinId });
    }
  };

  const handleCodeSelect = (e: React.SyntheticEvent<HTMLTextAreaElement>) => {
    const target = e.currentTarget;
    setSelection({ start: target.selectionStart, end: target.selectionEnd, text: code.substring(target.selectionStart, target.selectionEnd) });
  };

  const flipWireAxis = () => {
      if (!selectedWireId) return;
      setWires(prev => prev.map(w => w.id === selectedWireId ? { ...w, axis: w.axis === 'y' ? 'x' : 'y' } : w));
  };

  // --- CANVAS INTERACTIONS ---
  const handleCanvasMouseDown = (e: React.MouseEvent) => {
      if (e.button === 1 || (e.button === 0 && e.altKey)) { 
          setIsPanning(true); 
          setLastMousePos({ x: e.clientX, y: e.clientY }); 
          return; 
      }
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
          if (selectedCompIds.includes(compId)) setSelectedCompIds(prev => prev.filter(id => id !== compId));
          else setSelectedCompIds(prev => [...prev, compId]);
      } else {
          if (!selectedCompIds.includes(compId)) setSelectedCompIds([compId]);
      }
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

      // Drag Wire Segment (Handle)
      if (dragWireSegment) {
          const w = wires.find(w => w.id === dragWireSegment.wireId);
          if (w) {
              const s = getPinCoords(w.startComp, w.startPin);
              const e = getPinCoords(w.endComp, w.endPin);
              
              let newOffset = w.controlOffset;
              if (dragWireSegment.axis === 'x') {
                  // Horizontal range
                  const range = e.x - s.x;
                  if (Math.abs(range) > 1) {
                      // Project mouse X onto the range s.x -> e.x
                      newOffset = (worldPos.x - s.x) / range;
                  }
              } else {
                  // Vertical range (for Y axis wires)
                  const range = e.y - s.y;
                  if (Math.abs(range) > 1) {
                      newOffset = (worldPos.y - s.y) / range;
                  }
              }
              
              // Clamp offset
              newOffset = Math.max(0.05, Math.min(0.95, newOffset));
              
              setWires(prev => prev.map(wire => wire.id === w.id ? { ...wire, controlOffset: newOffset } : wire));
          }
      }

      if (draggedComponent) {
          const dx = (e.clientX - draggedComponent.startX) / view.scale;
          const dy = (e.clientY - draggedComponent.startY) / view.scale;
          setComponents(prev => prev.map(c => {
              if (selectedCompIds.includes(c.id)) {
                  return { ...c, x: c.x + dx, y: c.y + dy };
              }
              return c;
          }));
          setDraggedComponent({ ...draggedComponent, startX: e.clientX, startY: e.clientY });
      }

      if (isMouseDownOnCanvas && selectionRect) {
           const newW = Math.abs(worldPos.x - selectionStartPoint.x);
           const newH = Math.abs(worldPos.y - selectionStartPoint.y);
           const newX = Math.min(worldPos.x, selectionStartPoint.x);
           const newY = Math.min(worldPos.y, selectionStartPoint.y);
           setSelectionRect({ x: newX, y: newY, w: newW, h: newH });
      }
  };

  const handleMouseUp = () => {
      setDraggedComponent(null);
      setDragWireSegment(null);
      setIsPanning(false);

      if (isMouseDownOnCanvas && selectionRect) {
          const selected = components.filter(c => {
              const def = getComponentDef(c.type);
              const cw = def ? def.width : 50;
              return (
                  c.x < selectionRect.x + selectionRect.w &&
                  c.x + cw > selectionRect.x &&
                  c.y < selectionRect.y + selectionRect.h &&
                  c.y + (def?.height ?? 50) > selectionRect.y
              );
          }).map(c => c.id);
          setSelectedCompIds(selected);
      }
      setIsMouseDownOnCanvas(false);
      setSelectionRect(null);
  };

  useEffect(() => {
      // @ts-ignore
      window.addEventListener('mousemove', handleMouseMove);
      window.addEventListener('mouseup', handleMouseUp);
      // @ts-ignore
      return () => { window.removeEventListener('mousemove', handleMouseMove); window.removeEventListener('mouseup', handleMouseUp); };
  }, [draggedComponent, dragWireSegment, isMouseDownOnCanvas, selectionRect, selectedCompIds, isPanning, view, lastMousePos, wires]);

  // --- OTHER UTILS ---

  const speakText = (text: string) => {
      return new Promise<void>((resolve) => {
          if (!text || !speechRef.current) return resolve();
          if (speechRef.current.speaking) speechRef.current.cancel();
          const utterance = new SpeechSynthesisUtterance(text);
          utterance.rate = 1.0; utterance.pitch = 1.0;
          utterance.onend = () => resolve();
          utterance.onerror = () => resolve();
          speechRef.current.speak(utterance);
      });
  };

  const handleExplainWithVoice = async () => {
      if (!speechRef.current) return;
      if (isSpeaking) { speechRef.current.cancel(); setIsSpeaking(false); return; }
      speechRef.current.speak(new SpeechSynthesisUtterance('')); 
      setIsSpeaking(true); setIsGeneratingAI(true);
      if (speechRef.current.resume) speechRef.current.resume();

      const hasSelection = selection.end > selection.start;
      const textToExplain = hasSelection ? selection.text : code;
      const systemPrompt = `You are a coding tutor. Explain the C++ code in short, spoken chunks. Return JSON: [{"snippet": "exact substring", "explanation": "spoken text"}]`;
      
      try {
          const response = await callGeminiAPI(`Explain:\n${textToExplain}`, systemPrompt, 'json');
          const chunks = extractJSON(response);
          setIsGeneratingAI(false);
          
          if (Array.isArray(chunks)) {
              let currentSearchIndex = hasSelection ? selection.start : 0;
              for (let chunk of chunks) {
                  if (!isSpeaking && !speechRef.current.speaking) break;
                  let idx = code.indexOf(chunk.snippet, currentSearchIndex);
                  if (idx === -1) idx = code.indexOf(chunk.snippet.trim(), currentSearchIndex);
                  
                  if (idx !== -1 && editorRef.current) {
                      editorRef.current.focus();
                      editorRef.current.setSelectionRange(idx, idx + chunk.snippet.length);
                      currentSearchIndex = idx + 1;
                  }
                  await speakText(chunk.explanation);
              }
          }
      } catch (e) { console.error(e); } 
      finally { setIsSpeaking(false); setIsGeneratingAI(false); }
  };

  const handleAIDebug = async () => {
    if (!code.trim()) return;
    setIsGeneratingAI(true);
    const systemPrompt = `You are an expert Arduino programmer. Analyze the following code. If there are bugs, fix them. Return ONLY the full corrected code as raw text.`;
    try {
        const correctedCode = await callGeminiAPI(code, systemPrompt);
        const cleanCode = correctedCode.replace(/```cpp|```c|```/g, '').trim();
        setCode(cleanCode);
        setSerialOutput(prev => [...prev, "> ✨ AI Debugger: Code updated!"]);
    } catch (e) { console.error(e); } finally { setIsGeneratingAI(false); }
  };

  const handleAIGenerate = async () => {
    if (!aiPrompt.trim()) return;
    setIsGeneratingAI(true);
    setAiResult(null);
    
    const requestedOutputs = [];
    if (genOptions.circuit) requestedOutputs.push("circuit JSON (components, connections)");
    if (genOptions.code) requestedOutputs.push("Arduino C++ code");
    if (genOptions.flowchart) requestedOutputs.push("Mermaid.js Flowchart");
    if (genOptions.block) requestedOutputs.push("Mermaid.js Block Diagram");

    const genSystemPrompt = `You are an expert electronics engineer & programmer. User Request: ${aiPrompt}. Generate JSON with keys: components, connections, code, flowchart, blockDiagram, explanation.`;

    try {
        const response = await callGeminiAPI(aiPrompt, genSystemPrompt, 'json');
        const parsed = extractJSON(response);
        setAiResult(parsed);
    } catch (error) {
        setAiResult({ error: true, explanation: "Failed to generate." });
    } finally {
        setIsGeneratingAI(false);
    }
  };

  const applyAICircuit = () => {
      if (!aiResult) return;
      if (aiResult.flowchart || aiResult.blockDiagram) {
          setGeneratedDiagrams({
              flowchart: cleanMermaid(aiResult.flowchart),
              block: cleanMermaid(aiResult.blockDiagram)
          });
          if (aiResult.flowchart) setActiveDiagramTab('flowchart');
          else if (aiResult.blockDiagram) setActiveDiagramTab('block');
          setShowDiagramPanel(true);
      }
      if (aiResult.code && genOptions.code) setCode(aiResult.code);
      if (aiResult.components && genOptions.circuit) {
          const newComps: any[] = [];
          let startX = (-view.x + 300) / view.scale;
          let startY = (-view.y + 100) / view.scale;
          let compCount = 0;
          setWireMode('angled'); 

          aiResult.components.forEach((c: any) => {
              let type = c.type ? c.type.toUpperCase() : "";
              if (type.includes('ARDUINO')) type = 'ARDUINO';
              if (type.includes('ESP')) type = 'ESP32';
              if (type.includes('RGB')) type = 'RGB_LED';
              const typeDef = getComponentDef(type);
              if (!typeDef) return;
              let x = startX + (compCount % 3) * 180, y = startY + Math.floor(compCount / 3) * 180;
              if (['ARDUINO', 'ESP32', 'ESP8266'].includes(type)) { x = startX - 200; y = startY; } 
              else { compCount++; }
              newComps.push({ id: c.id, type: typeDef.type, x, y, rotation: 0, state: { angle: 0, value: 0, on: false, r:0, g:0, b:0, segments: {}, animationValue: null } });
          });
          setComponents(newComps);

          const newWires: any[] = [];
          aiResult.connections?.forEach((conn: any) => {
              if (!conn.from || !conn.to) return;
              let [sId, sPin] = conn.from.split(':');
              let [eId, ePin] = conn.to.split(':');
              const sComp = newComps.find(c => c.id === sId);
              const eComp = newComps.find(c => c.id === eId);
              if (sComp && eComp) {
                 const nStart = normalizePin(sComp.type, sPin);
                 const nEnd = normalizePin(eComp.type, ePin);
                 newWires.push({
                     id: Math.random().toString(36).substr(2, 9),
                     startComp: sId, startPin: nStart,
                     endComp: eId, endPin: nEnd,
                     color: getWireColor(nStart, nEnd),
                     controlOffset: 0.5,
                     axis: 'x'
                 });
              }
          });
          setWires(newWires);
      }
      if (!aiResult.flowchart && !aiResult.blockDiagram) setShowAIModal(false);
  };

  // --- SIMULATION ---
  const runSimulationStep = async () => {
    if (!simulationRef.current.active) return;
    const lines = code.split('\n');
    let pc = 0;
    const loopStart = lines.findIndex(l => l.includes('void loop'));
    pc = loopStart !== -1 ? loopStart : 0;
    const sleep = (ms: number) => new Promise(r => setTimeout(r, ms));

    while (simulationRef.current.active) {
       const line = lines[pc];
       if (line) {
           const printMatch = line.match(/Serial\.println\("(.+)"\)/);
           if (printMatch && printMatch[1]) setSerialOutput(prev => [...prev.slice(-29), `> ${printMatch[1]}`]);

           const dwMatch = line.match(/digitalWrite\s*\(\s*(\w+)\s*,\s*(HIGH|LOW)\s*\)/);
           if (dwMatch) {
             const pin = dwMatch[1];
             const val = dwMatch[2] === 'HIGH' ? 1 : 0;
             simulationRef.current.pinStates[pin] = val;
             updateCircuitState();
           }
           const servoMatch = line.match(/\.write\((\d+)\)/);
           if (servoMatch) {
              const angle = parseInt(servoMatch[1]);
              setComponents(prev => prev.map(c => c.type === 'SERVO' ? { ...c, state: { ...c.state, angle } } : c));
           }
           const delayMatch = line.match(/delay\((\d+)\)/);
           if (delayMatch) await sleep(parseInt(delayMatch[1]));
       }
       pc++; if (pc >= lines.length) pc = loopStart !== -1 ? loopStart : 0;
       await sleep(10);
    }
  };

  const updateCircuitState = () => {
    const pinStates = simulationRef.current.pinStates;
    const activePins = Object.keys(pinStates).filter(p => pinStates[p] > 0);
    activePins.push('5V', '3.3V', 'VIN');
    const poweredPins = new Set();
    const mcus = components.filter(c => ['ARDUINO', 'ESP32', 'ESP8266'].includes(c.type));
    const sources: any[] = [];
    mcus.forEach(mcu => {
        Object.keys(pinStates).forEach(p => { if (pinStates[p]) sources.push({compId: mcu.id, pinId: p}); });
        sources.push({compId: mcu.id, pinId: '5V'});
    });
    let queue = sources;
    const visited = new Set();

    while(queue.length > 0) {
      const current = queue.shift();
      const key = `${current.compId}-${current.pinId}`;
      if (visited.has(key)) continue;
      visited.add(key);
      poweredPins.add(key);
      wires.forEach(w => {
        if (w.startComp === current.compId && w.startPin === current.pinId) queue.push({ compId: w.endComp, pinId: w.endPin });
        if (w.endComp === current.compId && w.endPin === current.pinId) queue.push({ compId: w.startComp, pinId: w.startPin });
      });
      const comp = components.find(c => c.id === current.compId);
      if (comp && comp.type === 'RESISTOR') {
          if (current.pinId === 't1') queue.push({ compId: comp.id, pinId: 't2' });
          if (current.pinId === 't2') queue.push({ compId: comp.id, pinId: 't1' });
      }
      if (comp && comp.type === 'BUTTON') { 
          if (current.pinId === '1a') queue.push({ compId: comp.id, pinId: '1b' });
          if (current.pinId === '1b') queue.push({ compId: comp.id, pinId: '1a' });
      }
    }
    // Map pin power for each component so we can drive animations
    const pinPowerMap: Record<string, Record<string, boolean>> = {};
    components.forEach((comp) => {
      const def = getComponentDef(comp.type);
      if (!def) return;
      pinPowerMap[comp.id] = {};
      def.pins.forEach((pin: any) => {
        pinPowerMap[comp.id][pin.id] = poweredPins.has(`${comp.id}-${pin.id}`);
      });
    });

    setComponents(prev => prev.map(c => {
      const compPinStates = pinPowerMap[c.id] || {};
      const prevCompPins = prevPinPowerRef.current[c.id] || {};
      const changedPinId = Object.keys(compPinStates).find(pinId => compPinStates[pinId] !== prevCompPins[pinId]);
      let nextState = { ...(c.state || {}) };

      // Tag which pin changed (and whether it went HIGH/LOW) so animations can react to that pin
      if (changedPinId) {
        const poweredNow = compPinStates[changedPinId];
        nextState = { ...nextState, animationValue: `${changedPinId}:${poweredNow ? 'HIGH' : 'LOW'}` };
      }

      if (c.type === 'LED') {
        const isPowered = compPinStates['anode'] || false;
        nextState = { ...nextState, on: isPowered };
      }
      return { ...c, state: nextState };
    }));

    prevPinPowerRef.current = pinPowerMap;
  };

  const toggleSimulation = () => {
    if (isSimulating) {
      setIsSimulating(false);
      simulationRef.current.active = false;
    } else {
      setIsSimulating(true);
      simulationRef.current.active = true;
      setSerialOutput(['> Booting Kernel...', '> System Ready.']);
      runSimulationStep();
    }
  };

  // --- RENDER HELPERS ---

  const getPinCoords = (compId: string, pinId: string) => {
    const comp = components.find(c => c.id === compId);
    if (!comp) return { x: 0, y: 0 };
    const typeDef = getComponentDef(comp.type);
    if (!typeDef) return { x: comp.x, y: comp.y };
    const pinDef = typeDef.pins.find((p: any) => p.id === pinId);
    if (!pinDef) return { x: comp.x + 50, y: comp.y + 50 };
    return { x: comp.x + pinDef.x, y: comp.y + pinDef.y };
  };

  const getWirePath = (s: any, e: any, offset = 0.5, axis = 'x') => {
      const lead = 10; // straight lead from pins
      const sLead = axis === 'x' ? { x: s.x + (e.x > s.x ? lead : -lead), y: s.y } : { x: s.x, y: s.y + (e.y > s.y ? lead : -lead) };
      const eLead = axis === 'x' ? { x: e.x - (e.x > s.x ? lead : -lead), y: e.y } : { x: e.x, y: e.y - (e.y > s.y ? lead : -lead) };

      if (wireMode === 'angled') {
          // Rounding Radius
          const r = 10; 
          
          if (axis === 'x') {
              const midX = sLead.x + (eLead.x - sLead.x) * offset;
              // Clamped Radius based on segment lengths
              const r1 = Math.min(r, Math.abs(midX - sLead.x) / 2);
              const r2 = Math.min(r, Math.abs(eLead.x - midX) / 2);
              const ry = Math.min(r, Math.abs(eLead.y - sLead.y) / 2);
              const effR = Math.min(r1, r2, ry);

              // Direction multipliers
              const dx1 = midX > sLead.x ? 1 : -1;
              const dy = eLead.y > sLead.y ? 1 : -1;
              const dx2 = eLead.x > midX ? 1 : -1;

              return {
                  d: `M ${s.x} ${s.y} 
                      L ${sLead.x} ${sLead.y}
                      L ${midX - effR * dx1} ${sLead.y} 
                      Q ${midX} ${sLead.y} ${midX} ${sLead.y + effR * dy} 
                      L ${midX} ${eLead.y - effR * dy} 
                      Q ${midX} ${eLead.y} ${midX + effR * dx2} ${eLead.y} 
                      L ${eLead.x} ${eLead.y}
                      L ${e.x} ${e.y}`,
                  midX, midY: (sLead.y + eLead.y) / 2,
                  axis: 'x',
                  dragRect: { x: midX - 8, y: Math.min(sLead.y, eLead.y), w: 16, h: Math.abs(eLead.y - sLead.y) } // Hit area for vertical segment
              };
          } else {
              // Y-Axis (Start -> Vertical -> Horizontal -> Vertical -> End)
              const midY = sLead.y + (eLead.y - sLead.y) * offset;
              
              // Clamped Radius
              const ry1 = Math.min(r, Math.abs(midY - sLead.y) / 2);
              const ry2 = Math.min(r, Math.abs(eLead.y - midY) / 2);
              const rx = Math.min(r, Math.abs(eLead.x - sLead.x) / 2);
              const effR = Math.min(ry1, ry2, rx);

              const dy1 = midY > sLead.y ? 1 : -1;
              const dx = eLead.x > sLead.x ? 1 : -1;
              const dy2 = eLead.y > midY ? 1 : -1;

              return {
                  d: `M ${s.x} ${s.y} 
                      L ${sLead.x} ${sLead.y}
                      L ${sLead.x} ${midY - effR * dy1} 
                      Q ${sLead.x} ${midY} ${sLead.x + effR * dx} ${midY} 
                      L ${eLead.x - effR * dx} ${midY} 
                      Q ${eLead.x} ${midY} ${eLead.x} ${midY + effR * dy2} 
                      L ${eLead.x} ${eLead.y}
                      L ${e.x} ${e.y}`,
                  midX: (sLead.x + eLead.x) / 2, midY,
                  axis: 'y',
                  dragRect: { x: Math.min(sLead.x, eLead.x), y: midY - 8, w: Math.abs(eLead.x - sLead.x), h: 16 } // Hit area for horizontal segment
              };
          }
      }
      // Curve mode
      const dx = Math.abs(eLead.x - sLead.x);
      const cOff = Math.max(dx * 0.5, 50);
      return { d: `M ${s.x} ${s.y} L ${sLead.x} ${sLead.y} C ${sLead.x + cOff} ${sLead.y}, ${eLead.x - cOff} ${eLead.y}, ${eLead.x} ${eLead.y} L ${e.x} ${e.y}` };
  };

  // --- GRID PATTERN ---
  const GridPattern = () => (
    <defs>
      <pattern id="smallGrid" width="10" height="10" patternUnits="userSpaceOnUse">
        <path d="M 10 0 L 0 0 0 10" fill="none" stroke={darkMode ? "#334155" : "#e2e8f0"} strokeWidth="0.5" />
      </pattern>
      <pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse">
        <rect width="100" height="100" fill="url(#smallGrid)" />
        <path d="M 100 0 L 0 0 0 100" fill="none" stroke={darkMode ? "#475569" : "#cbd5e1"} strokeWidth="1" />
      </pattern>
    </defs>
  );

  // --- RENDERERS ---

  const renderRealisticComponent = (comp: any) => {
    const typeDef = getComponentDef(comp.type);
    if (!typeDef) return null;
    const isSelected = selectedCompIds.includes(comp.id);
    const isArduino = comp.type === 'ARDUINO';
    const connectedPinIds = new Set(
      wires
        .filter((w) => w.startComp === comp.id || w.endComp === comp.id)
        .map((w) => (w.startComp === comp.id ? w.startPin : w.endPin))
    );

    const renderPinSockets = () => (
      <div className="absolute inset-0 pointer-events-none">
        {typeDef.pins.map((p: any) => (
          <div
            key={`${comp.id}-${p.id}-hole`}
            className="absolute flex items-center justify-center"
            style={{
              left: p.x - (isArduino ? 9 : 8),
              top: p.y - (isArduino ? 9 : 10),
              width: isArduino ? 18 : 16,
              height: isArduino ? 16 : 12,
            }}
          >
            <div
              className={`rounded-full ${isArduino ? 'bg-gradient-to-b from-[#16181d] to-[#050607] border border-[#1f2937] shadow-[inset_0_1px_2px_rgba(255,255,255,0.06)]' : 'bg-gray-900 border border-gray-700/80'}`}
              style={{
                width: isArduino ? 8 : 6,
                height: isArduino ? 8 : 6,
                boxShadow: isArduino ? '0 0 0 2px #0f172a' : undefined,
              }}
            />
          </div>
        ))}
      </div>
    );

    return (
      <div
        key={comp.id}
        onMouseDown={(e) => handleComponentMouseDown(e, comp.id)}
        style={{ position: 'absolute', left: comp.x, top: comp.y, width: typeDef.width, height: typeDef.height }}
        className={`group cursor-grab active:cursor-grabbing z-20 ${isSelected ? 'shadow-[0_0_0_2px_rgba(255,255,255,0.35)] rounded-xl' : ''}`}
      >
        {!isSimulating && isSelected && (
          <button
            onClick={(e) => {
              e.stopPropagation();
              removeComponent(comp.id);
            }}
            className="absolute -top-3 -right-3 bg-red-500 text-white p-1.5 rounded-full hover:scale-110 z-50 shadow-md transition-transform"
          >
            <Trash2 size={12} />
          </button>
        )}

        <div
          className={`w-full h-full relative rounded-xl overflow-hidden ${
            typeDef.image_url ? '' : 'border border-gray-700/60 bg-gradient-to-br from-slate-800 via-slate-900 to-black shadow-[0_12px_28px_rgba(0,0,0,0.45)]'
          }`}
        >
          {typeDef.image_url ? (
            <img
              src={typeDef.image_url}
              className="absolute inset-0 w-full h-full object-contain pointer-events-none select-none"
              alt={typeDef.name}
              draggable={false}
            />
          ) : (
            <>
              <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_20%_20%,#fff,transparent_35%)]" />
              <div className="absolute inset-0 flex items-start justify-between p-3 text-[10px] uppercase tracking-[0.18em] text-gray-200/70 font-semibold pointer-events-none">
                <span>{typeDef.name}</span>
                <span>{comp.type}</span>
              </div>
              <div className="absolute inset-3 rounded-lg overflow-hidden border border-gray-700/60 bg-gray-900/70 flex items-center justify-center text-gray-500 text-xs font-medium">
                Image placeholder
              </div>
            </>
          )}

          {renderPinSockets()}
        </div>

        {typeDef.pins.map((p: any) => {
          const isConnected = connectedPinIds.has(p.id);
          return (
            <div
              key={p.id}
              onClick={(e) => handlePinClick(comp.id, p.id, e)}
              className={`absolute w-3 h-3 rounded-full transition-all duration-150 cursor-crosshair z-50 shadow-sm border ${
                isConnected
                  ? 'bg-emerald-400 border-emerald-700 shadow-[0_0_12px_rgba(16,185,129,0.7)] scale-110'
                  : 'bg-gradient-to-b from-gray-700 to-black border-gray-900 hover:scale-125 hover:border-blue-400'
              }`}
              style={{ left: p.x - 6, top: p.y - 6 }}
              title={p.label}
              onMouseDown={(e) => e.stopPropagation()}
            />
          );
        })}
      </div>
    );
  };

  return (
    <div className={`flex h-screen w-full ${darkMode ? 'bg-gray-900 text-white' : 'bg-gray-50 text-gray-900'} font-sans select-none transition-colors duration-300`}>
      
      {/* --- LEFT SIDEBAR (Components) --- */}
      <div className={`w-64 flex flex-col z-10 shadow-lg border-r ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
        <div className="p-5 border-b border-gray-200 dark:border-gray-700 flex items-center gap-3">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-1.5 rounded-lg shadow-lg">
               <Zap size={18} className="text-white"/> 
            </div>
            <h1 className="font-bold text-lg bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">CircuitPro</h1>
        </div>
        
        <div className="p-4 flex-1 overflow-y-auto grid grid-cols-2 gap-3 content-start custom-scrollbar">
            {libraryLoading && <div className="col-span-2 text-center text-xs text-gray-500">Loading components...</div>}
            {libraryError && <div className="col-span-2 text-center text-xs text-red-400">{libraryError}</div>}
            {!libraryLoading && !libraryError && Object.values(componentLibrary).map((def) => (
              <div
                key={def.id}
                onClick={() => addComponent(def.type)}
                className={`group p-3 rounded-xl border cursor-pointer flex flex-col items-center transition-all duration-200
                  ${darkMode 
                    ? 'bg-gray-700/50 border-gray-600 hover:bg-gray-700 hover:border-blue-500' 
                    : 'bg-white border-gray-200 hover:border-blue-500 hover:shadow-md hover:-translate-y-0.5'
                  }`}
              >
                <div className={`mb-2 w-16 h-16 flex items-center justify-center ${def.image_url ? '' : darkMode ? 'bg-gray-600 group-hover:text-blue-400 rounded-lg' : 'bg-gray-100 group-hover:text-blue-600 rounded-lg'}`}>
                  {def.image_url ? (
                    <img src={def.image_url} className="max-w-full max-h-full object-contain pointer-events-none" alt={def.name} />
                  ) : (
                    <Cpu size={24} className="text-gray-500 group-hover:text-blue-500 transition-colors"/>
                  )}
                </div>
                <span className={`text-[11px] font-bold text-center ${darkMode ? 'text-gray-200' : 'text-gray-700'}`}>{def.name}</span>
              </div>
            ))}
            {!libraryLoading && !libraryError && Object.keys(componentLibrary).length === 0 && (
              <div className="col-span-2 text-center text-xs text-gray-500">No components available</div>
            )}
        </div>
        
        <div className="p-4 border-t dark:border-gray-700">
             <div className={`flex items-center justify-between p-2 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-gray-100'}`}>
                 <span className="text-xs font-medium px-2">Theme</span>
                 <button onClick={() => setDarkMode(!darkMode)} className="p-1.5 rounded-md hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors">
                     {darkMode ? <Sun size={16}/> : <Moon size={16}/>}
                 </button>
             </div>
        </div>
      </div>

      {/* --- MAIN WORKSPACE --- */}
      <div className="flex-1 flex flex-col relative">
        {/* Header */}
        <div className={`h-16 border-b flex items-center justify-between px-6 z-20 shadow-sm ${darkMode ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'}`}>
            <div className="flex items-center gap-3">
                <button onClick={toggleSimulation} 
                    className={`flex items-center gap-2 px-4 py-2 rounded-lg font-bold text-sm transition-all shadow-sm hover:shadow
                    ${isSimulating 
                        ? 'bg-red-100 text-red-600 border border-red-200 hover:bg-red-200' 
                        : 'bg-green-600 text-white hover:bg-green-700 border border-green-700'}`}>
                    {isSimulating ? <Square size={16} fill="currentColor"/> : <Play size={16} fill="currentColor"/>} 
                    {isSimulating ? t.stop : t.simulate}
                </button>

                <div className="h-8 w-px bg-gray-300 dark:bg-gray-600 mx-2" />

                <div className={`flex p-1 rounded-lg border ${darkMode ? 'bg-gray-700 border-gray-600' : 'bg-gray-100 border-gray-200'}`}>
                    <ToolbarButton icon={GitCommit} onClick={() => setWireMode('curve')} active={wireMode==='curve'} label="Curved Wires" />
                    <ToolbarButton icon={CornerDownRight} onClick={() => setWireMode('angled')} active={wireMode==='angled'} label="Angled Wires" />
                </div>

                <div className="flex items-center gap-2 ml-2">
                    <ToolbarButton icon={Grid3X3} onClick={() => setShowGrid(!showGrid)} active={showGrid} label="Toggle Grid" />
                    
                    {/* Wire Axis Toggle - Only shown if wire selected & in angled mode */}
                    {selectedWireId && wireMode === 'angled' && (
                        <button onClick={flipWireAxis} className="text-blue-600 bg-blue-50 border border-blue-200 px-3 py-2 rounded-lg text-xs flex items-center gap-2 font-medium hover:bg-blue-100 transition-colors" title="Flip Wire Axis">
                            <ArrowLeftRight size={14}/> Flip Axis
                        </button>
                    )}
                    
                    {selectedWireId && (
                      <>
                        <select
                          value={wires.find(w => w.id === selectedWireId)?.color || '#10B981'}
                          onChange={(e) => setWires(prev => prev.map(w => w.id === selectedWireId ? { ...w, color: e.target.value } : w))}
                          className="text-xs border rounded-lg px-2 py-2 bg-white text-gray-700"
                        >
                          <option value="#10B981">Green</option>
                          <option value="#3B82F6">Blue</option>
                          <option value="#EF4444">Red</option>
                          <option value="#F59E0B">Orange</option>
                          <option value="#8B5CF6">Purple</option>
                          <option value="#111827">Black</option>
                        </select>
                        <button onClick={() => {setWires(w => w.filter(x=>x.id!==selectedWireId)); setSelectedWireId(null)}} className="text-red-600 bg-red-50 border border-red-200 px-3 py-2 rounded-lg text-xs flex items-center gap-2 font-medium hover:bg-red-100 transition-colors"><Trash2 size={14}/> {t.deleteWire}</button>
                      </>
                    )}
                    {selectedCompIds.length > 0 && <button onClick={() => {setComponents(c => c.filter(x => !selectedCompIds.includes(x.id))); setSelectedCompIds([]);}} className="text-red-600 bg-red-50 border border-red-200 px-3 py-2 rounded-lg text-xs flex items-center gap-2 font-medium hover:bg-red-100 transition-colors"><Trash2 size={14}/> {t.deleteComponents}</button>}
                </div>
            </div>

            <div className="flex items-center gap-3">
                 {generatedDiagrams && (
                     <button onClick={() => setShowDiagramPanel(!showDiagramPanel)} className={`flex items-center gap-2 px-3 py-2 rounded-lg border transition-all text-sm font-medium ${showDiagramPanel ? 'bg-blue-50 border-blue-500 text-blue-600' : 'bg-white border-gray-300 text-gray-600 hover:bg-gray-50'}`}>
                        <Workflow size={16}/> Diagrams
                     </button>
                 )}

                 <div className={`flex rounded-lg p-1 border ${darkMode ? 'bg-gray-700 border-gray-600' : 'bg-gray-100 border-gray-200'}`}>
                    <ToolbarButton icon={Zap} onClick={() => setActiveView('canvas')} active={activeView === 'canvas'} label="Canvas Only" />
                    <ToolbarButton icon={RotateCw} onClick={() => setActiveView('both')} active={activeView === 'both'} label="Split View" />
                    <ToolbarButton icon={Code} onClick={() => setActiveView('code')} active={activeView === 'code'} label="Code Only" />
                </div>

                <button onClick={() => setShowAIModal(true)} className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-purple-500 to-blue-500 text-white rounded-lg hover:opacity-90 transition-all text-sm font-bold shadow-md hover:shadow-lg">
                    <Sparkles size={16} /> AI Assistant
                </button>
            </div>
        </div>

        <div className="flex-1 flex overflow-hidden relative">
            {/* Canvas Area */}
            <div ref={canvasRef} 
                 className={`relative flex-1 overflow-hidden cursor-${isPanning ? 'grabbing' : 'default'}`} 
                 onMouseDown={handleCanvasMouseDown} 
                 onWheel={handleWheel}
            >
                {/* --- INFINITE GRID BACKGROUND LAYER --- */}
                <div className="absolute inset-0 pointer-events-none" style={{backgroundColor: darkMode ? '#111827' : '#F9FAFB'}}>
                    <svg className="w-full h-full">
                        <GridPattern />
                        <g transform={`translate(${view.x}, ${view.y}) scale(${view.scale})`}>
                             {showGrid && (
                                 <rect x="-25000" y="-25000" width="50000" height="50000" fill="url(#grid)" />
                             )}
                        </g>
                    </svg>
                </div>

                {/* Content Container - Transformed */}
                <div style={{transform: `translate(${view.x}px, ${view.y}px) scale(${view.scale})`, width: '100%', height: '100%', position: 'absolute', transformOrigin: '0 0'}}>
                    {components.map(comp => renderRealisticComponent(comp))}
                    
                    {/* WIRES LAYER - Now z-30 to be above components */}
                    <svg className="absolute left-0 top-0 w-full h-full pointer-events-none z-30" style={{overflow: 'visible'}}>
                        {wires.map(w => {
                            const s = getPinCoords(w.startComp, w.startPin);
                            const e = getPinCoords(w.endComp, w.endPin);
                            const isSelected = w.id === selectedWireId;
                            const pathData = getWirePath(s, e, w.controlOffset, w.axis || 'x'); // Pass axis
                            
                            return (
                                <g key={w.id} onClick={(ev) => { ev.stopPropagation(); setSelectedWireId(w.id); }}>
                                    {/* Hit Area (Invisible) */}
                                    <path d={pathData.d} stroke="transparent" strokeWidth="20" fill="none" className="pointer-events-auto cursor-pointer"/>
                                    
                                    {/* Visible wire */}
                                    <path d={pathData.d} stroke={isSelected ? '#3B82F6' : w.color} strokeWidth={isSelected ? "5" : "3"} fill="none" className="pointer-events-none shadow-sm drop-shadow-md transition-all"/>
                                    
                                    {/* Draggable Segment Overlay (Angled Mode) */}
                                    {isSelected && wireMode === 'angled' && pathData.dragRect && (
                                        <rect 
                                            x={pathData.dragRect.x} 
                                            y={pathData.dragRect.y} 
                                            width={pathData.dragRect.w} 
                                            height={pathData.dragRect.h}
                                            fill="transparent"
                                            className={`pointer-events-auto ${pathData.axis === 'x' ? 'cursor-col-resize' : 'cursor-row-resize'} hover:fill-blue-500/20`}
                                            onMouseDown={(ev) => {
                                                ev.stopPropagation();
                                                setDragWireSegment({ 
                                                    wireId: w.id, 
                                                    axis: pathData.axis as 'x'|'y', 
                                                    initialVal: w.controlOffset || 0.5, 
                                                    mouseStart: pathData.axis === 'x' ? ev.clientX : ev.clientY 
                                                });
                                            }}
                                        />
                                    )}
                                </g>
                            );
                        })}
                        {wireStart && (
                             <line x1={getPinCoords(wireStart.compId, wireStart.pinId).x} 
                                   y1={getPinCoords(wireStart.compId, wireStart.pinId).y} 
                                   x2={mousePos.x}
                                   y2={mousePos.y} 
                                   stroke="#10B981" strokeWidth="2" strokeDasharray="5,5" className="opacity-60 animate-pulse"/>
                        )}
                    </svg>

                    {selectionRect && <div className="absolute border border-blue-500 bg-blue-500/10 pointer-events-none backdrop-blur-[1px]" style={{left: selectionRect.x, top: selectionRect.y, width: selectionRect.w, height: selectionRect.h}} />}
                </div>
                
                {/* Floating Diagram Viewer */}
                {showDiagramPanel && generatedDiagrams && (
                    <div className="absolute top-4 right-4 w-96 bg-white dark:bg-gray-800 rounded-xl shadow-2xl overflow-hidden border border-gray-200 dark:border-gray-700 z-50 flex flex-col max-h-[500px] animate-in slide-in-from-right-10">
                        <div className="bg-gray-50 dark:bg-gray-900 p-3 flex justify-between items-center border-b border-gray-200 dark:border-gray-700">
                            <div className="flex gap-2">
                                {generatedDiagrams.flowchart && (
                                    <button onClick={() => setActiveDiagramTab('flowchart')} className={`text-xs px-3 py-1.5 rounded-md font-semibold transition-colors ${activeDiagramTab==='flowchart'?'bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300':'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800'}`}>Flowchart</button>
                                )}
                                {generatedDiagrams.block && (
                                    <button onClick={() => setActiveDiagramTab('block')} className={`text-xs px-3 py-1.5 rounded-md font-semibold transition-colors ${activeDiagramTab==='block'?'bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300':'text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800'}`}>Block Diagram</button>
                                )}
                            </div>
                            <button onClick={() => setShowDiagramPanel(false)} className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"><X size={16}/></button>
                        </div>
                        <div className="p-6 overflow-auto bg-white flex justify-center items-start min-h-[200px]">
                             {activeDiagramTab === 'flowchart' && generatedDiagrams.flowchart && (
                                 <img src={`https://mermaid.ink/img/${btoa(generatedDiagrams.flowchart)}`} alt="Flowchart" className="max-w-full"/>
                             )}
                             {activeDiagramTab === 'block' && generatedDiagrams.block && (
                                 <img src={`https://mermaid.ink/img/${btoa(generatedDiagrams.block)}`} alt="Block Diagram" className="max-w-full"/>
                             )}
                        </div>
                    </div>
                )}
            </div>
            
            {/* CODE EDITOR SIDEBAR */}
            <div className={`w-96 flex flex-col shadow-xl border-l z-20 transition-all duration-300
                ${darkMode ? 'bg-[#1e1e1e] border-gray-700' : 'bg-[#1e1e1e] border-gray-800'} 
                ${activeView === 'canvas' ? 'hidden' : ''}`}
            >
                 <div className="bg-[#252526] px-4 py-2 text-xs font-bold text-blue-400 border-b border-[#333] flex justify-between items-center h-10">
                    <div className="flex items-center gap-2"><FileCode size={14}/> <span>sketch.ino</span></div>
                    <div className="flex gap-2">
                      <button onClick={handleAIDebug} className="text-[10px] text-purple-400 hover:text-purple-300 flex items-center gap-1 px-2 py-1 hover:bg-purple-500/10 rounded" title="AI Fix">
                          <Bug size={12}/> Debug
                      </button>
                      <button onClick={handleExplainWithVoice} className={`text-[10px] px-2 py-1 rounded border flex items-center gap-1 transition-colors ${isSpeaking ? 'border-red-500 text-red-400 bg-red-500/10' : 'border-gray-600 text-gray-400 hover:text-white hover:border-gray-500'}`}>
                       {isSpeaking ? <VolumeX size={12}/> : <Volume2 size={12}/>} {isSpeaking ? 'Stop' : 'Explain'}
                      </button>
                    </div>
                 </div>
                 <textarea 
                     className="flex-1 bg-[#1e1e1e] p-4 font-mono text-sm text-gray-300 resize-none focus:outline-none leading-relaxed custom-scrollbar"
                     value={code} onChange={e => setCode(e.target.value)} spellCheck={false}
                     onSelect={handleCodeSelect} ref={editorRef}
                 />
                 <div className="h-40 bg-[#0f0f10] border-t border-[#333] p-3 font-mono text-xs overflow-y-auto custom-scrollbar">
                     <div className="text-gray-500 mb-2 select-none font-bold flex items-center gap-2"><Terminal size={12}/> {t.serialMonitor}</div>
                     {serialOutput.map((s, i) => <div key={i} className="text-green-500 font-mono leading-tight">{s}</div>)}
                     <div ref={logsEndRef}/>
                 </div>
            </div>
        </div>
      </div>

      {/* AI Modal */}
      {showAIModal && (
        <div className="absolute inset-0 z-[100] bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 animate-in fade-in">
            <div className="bg-white dark:bg-gray-800 w-full max-w-xl rounded-2xl shadow-2xl overflow-hidden border border-gray-200 dark:border-gray-700">
                <div className="bg-gray-50 dark:bg-gray-900 p-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                    <h3 className="font-bold text-gray-800 dark:text-white flex items-center gap-2"><Sparkles className="text-blue-600" size={20}/> {t.aiTitle}</h3>
                    <button onClick={() => setShowAIModal(false)} className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"><X size={20}/></button>
                </div>
                {!aiResult ? (
                    <div className="p-6">
                        <textarea 
                            value={aiPrompt} onChange={e => setAiPrompt(e.target.value)} 
                            className="w-full h-32 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg p-3 text-sm text-gray-900 dark:text-white outline-none focus:ring-2 focus:ring-blue-500" 
                            placeholder={t.aiPlaceholder}
                        />
                        <div className="mt-6">
                             <label className="block text-xs font-bold text-gray-500 uppercase mb-3">Generate Options</label>
                             <div className="grid grid-cols-2 gap-3">
                                 {Object.entries({circuit: t.genCircuit, code: t.genCode, flowchart: t.genFlowchart, block: t.genBlock}).map(([key, label]) => (
                                    <label key={key} className="flex items-center gap-3 p-3 rounded-lg border border-gray-200 dark:border-gray-700 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                                        {/* @ts-ignore */}
                                        <input type="checkbox" checked={genOptions[key]} onChange={e => setGenOptions({...genOptions, [key]: e.target.checked})} className="w-4 h-4 accent-blue-600 rounded"/> 
                                        <span className="text-sm font-medium text-gray-700 dark:text-gray-200">{label}</span>
                                    </label>
                                 ))}
                             </div>
                        </div>
                        <button onClick={handleAIGenerate} className="mt-6 w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white py-3 rounded-lg font-bold shadow-lg flex justify-center items-center gap-2 transition-all" disabled={isGeneratingAI}>
                            {isGeneratingAI ? <Loader2 className="animate-spin"/> : <Sparkles size={18}/>} {isGeneratingAI ? t.aiGenerating : t.aiGenerate}
                        </button>
                    </div>
                ) : (
                    <div className="p-6">
                        <p className="text-green-600 mb-4 font-bold flex items-center gap-2"><CheckSquare size={18}/> {t.aiSuccess}</p>
                        <div className="bg-gray-50 dark:bg-gray-900 p-4 rounded-lg border border-gray-200 dark:border-gray-700 mb-6"><p className="text-sm text-gray-700 dark:text-gray-300 leading-relaxed">{typeof aiResult.explanation === 'string' ? aiResult.explanation : 'Success'}</p></div>
                        <div className="flex gap-3">
                            <button onClick={applyAICircuit} className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-lg font-bold shadow-md transition-colors">{t.aiApply}</button>
                            <button onClick={() => setAiResult(null)} className="px-6 border border-gray-300 dark:border-gray-600 text-gray-600 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 font-medium transition-colors">{t.aiDiscard}</button>
                        </div>
                    </div>
                )}
            </div>
        </div>
      )}
    </div>
  );
}
