'use client';
import React, { useState, useEffect, useRef } from 'react';
import { 
  Play, Square, Trash2, Terminal, Code, Zap, RotateCw, Cpu, 
  Lightbulb, ToggleLeft, Box, Wifi, Lock, Crown, CreditCard, 
  Settings, Sliders, MousePointer2, Sparkles, Loader2, MessageSquare, X,
  Volume2, VolumeX, Mic, GitCommit, CornerDownRight
} from 'lucide-react';

// --- CONSTANTS & DEFINITIONS ---

const GRID_SIZE = 20;

// Safe API Key Access
const getApiKey = () => {
  try {
    // @ts-ignore
    return typeof process !== 'undefined' ? process.env.NEXT_PUBLIC_GEMINI_API_KEY : "";
  } catch (e) {
    return "";
  }
};
const apiKey = getApiKey();

// --- HELPER: Extract JSON from AI Response (Robust) ---
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

// --- HELPER: Normalize Pin IDs from AI ---
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
    
    return pinId;
};

// Component Library Definition
const COMPONENT_TYPES: any = {
  ARDUINO: {
    type: 'ARDUINO',
    name: 'Arduino Uno R3',
    tier: 'free',
    width: 200,
    height: 280,
    icon: Cpu,
    description: 'Classic ATmega328P board. 5V logic.',
    pins: [
      { id: 'GND_1', x: 60, y: 265, label: 'GND', type: 'power' },
      { id: '5V', x: 45, y: 265, label: '5V', type: 'power' },
      { id: '3.3V', x: 30, y: 265, label: '3.3V', type: 'power' },
      { id: '13', x: 35, y: 15, label: 'D13', type: 'digital' },
      { id: '12', x: 50, y: 15, label: 'D12', type: 'digital' },
      { id: '11', x: 65, y: 15, label: 'D11', type: 'digital' },
      { id: '10', x: 80, y: 15, label: 'D10', type: 'digital' },
      { id: '9', x: 95, y: 15, label: 'D9', type: 'digital' },
      { id: '8', x: 110, y: 15, label: 'D8', type: 'digital' },
      { id: '7', x: 125, y: 15, label: 'D7', type: 'digital' },
      { id: '6', x: 140, y: 15, label: 'D6', type: 'digital' },
      { id: '5', x: 155, y: 15, label: 'D5', type: 'digital' },
      { id: '4', x: 170, y: 15, label: 'D4', type: 'digital' },
      { id: '3', x: 185, y: 15, label: 'D3', type: 'digital' },
      { id: '2', x: 200, y: 15, label: 'D2', type: 'digital' },
      { id: 'A0', x: 130, y: 265, label: 'A0', type: 'analog' },
      { id: 'A1', x: 145, y: 265, label: 'A1', type: 'analog' },
    ]
  },
  ESP32: {
    type: 'ESP32',
    name: 'ESP32 DevKit',
    tier: 'pro',
    width: 140,
    height: 240,
    icon: Wifi,
    description: 'Dual-core, Wi-Fi & Bluetooth. 3.3V logic.',
    pins: [
      { id: 'GND', x: 15, y: 225, label: 'GND', type: 'power' },
      { id: 'VIN', x: 15, y: 210, label: 'VIN', type: 'power' },
      { id: 'D2', x: 125, y: 45, label: 'D2', type: 'digital' },
      { id: 'D4', x: 125, y: 60, label: 'D4', type: 'digital' },
      { id: 'D5', x: 125, y: 75, label: 'D5', type: 'digital' },
      { id: 'D18', x: 125, y: 90, label: 'D18', type: 'digital' },
      { id: 'D19', x: 125, y: 105, label: 'D19', type: 'digital' },
      { id: 'D21', x: 125, y: 120, label: 'D21', type: 'digital' },
      { id: 'D22', x: 15, y: 120, label: 'D22', type: 'digital' },
      { id: 'D23', x: 15, y: 105, label: 'D23', type: 'digital' },
    ]
  },
  ESP8266: {
    type: 'ESP8266',
    name: 'NodeMCU ESP8266',
    tier: 'pro',
    width: 130,
    height: 220,
    icon: Wifi,
    description: 'Low-cost Wi-Fi microchip.',
    pins: [
      { id: 'GND', x: 15, y: 190, label: 'GND', type: 'power' },
      { id: '3V3', x: 15, y: 175, label: '3V3', type: 'power' },
      { id: 'D0', x: 115, y: 40, label: 'D0', type: 'digital' },
      { id: 'D1', x: 115, y: 55, label: 'D1', type: 'digital' },
      { id: 'D2', x: 115, y: 70, label: 'D2', type: 'digital' },
      { id: 'D3', x: 115, y: 85, label: 'D3', type: 'digital' },
      { id: 'D4', x: 115, y: 100, label: 'D4', type: 'digital' },
    ]
  },
  LED: {
    type: 'LED',
    name: 'LED (Red)',
    tier: 'free',
    width: 30,
    height: 60,
    icon: Lightbulb,
    pins: [
      { id: 'anode', x: 22, y: 55, label: '+', type: 'io' },
      { id: 'cathode', x: 8, y: 55, label: '-', type: 'io' },
    ]
  },
  RESISTOR: {
    type: 'RESISTOR',
    name: 'Resistor 220Ω',
    tier: 'free',
    width: 80,
    height: 20,
    icon: Box,
    pins: [
      { id: 't1', x: 5, y: 10, label: '1', type: 'io' },
      { id: 't2', x: 75, y: 10, label: '2', type: 'io' },
    ]
  },
  BUTTON: {
    type: 'BUTTON',
    name: 'Push Button',
    tier: 'free',
    width: 50,
    height: 50,
    icon: ToggleLeft,
    pins: [
      { id: '1a', x: 5, y: 5, label: '1a', type: 'io' },
      { id: '1b', x: 5, y: 45, label: '1b', type: 'io' },
      { id: '2a', x: 45, y: 5, label: '2a', type: 'io' },
      { id: '2b', x: 45, y: 45, label: '2b', type: 'io' },
    ]
  },
  SERVO: {
    type: 'SERVO',
    name: 'Micro Servo',
    tier: 'pro',
    width: 80,
    height: 100,
    icon: Settings,
    description: 'Positional rotation 0-180°',
    pins: [
      { id: 'GND', x: 20, y: 95, label: 'GND (Brn)', type: 'power' },
      { id: 'VCC', x: 40, y: 95, label: 'VCC (Red)', type: 'power' },
      { id: 'SIG', x: 60, y: 95, label: 'PWM (Org)', type: 'digital' },
    ]
  },
  POT: {
    type: 'POT',
    name: 'Potentiometer',
    tier: 'free',
    width: 60,
    height: 60,
    icon: Sliders,
    pins: [
      { id: 'GND', x: 10, y: 55, label: '1', type: 'power' },
      { id: 'SIG', x: 30, y: 55, label: '2', type: 'analog' },
      { id: 'VCC', x: 50, y: 55, label: '3', type: 'power' },
    ]
  }
};

const INITIAL_CODE = `// Arduino / ESP Simulator
void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  Serial.println("System Initialized");
}

void loop() {
  digitalWrite(13, HIGH);
  Serial.println("Blink: ON");
  delay(500);
  digitalWrite(13, LOW);
  Serial.println("Blink: OFF");
  delay(500);
}`;

const generateId = () => Math.random().toString(36).substr(2, 9);

const callGeminiAPI = async (prompt: string, systemInstruction: string, responseFormat = 'text') => {
  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=${apiKey}`;
  const payload: any = {
    contents: [{ parts: [{ text: prompt }] }],
    systemInstruction: { parts: [{ text: systemInstruction }] },
  };
  // if (responseFormat === 'json') payload.generationConfig = { responseMimeType: "application/json" };

  const delays = [1000, 2000, 4000];
  for (let i = 0; i <= delays.length; i++) {
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
      const data = await response.json();
      return data.candidates?.[0]?.content?.parts?.[0]?.text || "{}";
    } catch (error) {
      if (i === delays.length) throw error;
      await new Promise(resolve => setTimeout(resolve, delays[i]));
    }
  }
};

export default function ReactCircuitPro() {
  const [userPlan, setUserPlan] = useState('free'); 
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [showAIModal, setShowAIModal] = useState(false);
  const [aiPrompt, setAiPrompt] = useState('');
  const [aiResult, setAiResult] = useState<any>(null); 
  const [isGeneratingAI, setIsGeneratingAI] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState(false);

  const [aiMode, setAiMode] = useState('generate'); 
  const [activeView, setActiveView] = useState('both');

  const [components, setComponents] = useState<any[]>([]);
  const [wires, setWires] = useState<any[]>([]);
  const [code, setCode] = useState(INITIAL_CODE);
  const [isSimulating, setIsSimulating] = useState(false);
  const [serialOutput, setSerialOutput] = useState<string[]>([]);
  
  const [draggedComponent, setDraggedComponent] = useState<any>(null);
  const [wireStart, setWireStart] = useState<any>(null);
  const [selectedWireId, setSelectedWireId] = useState<string | null>(null); 
  const [wireMode, setWireMode] = useState<'curve' | 'angled'>('curve'); 
  
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });
  const [selection, setSelection] = useState({ start: 0, end: 0, text: '' });
  
  const simulationRef = useRef({ active: false, pinStates: {} as Record<string, any>, servoAngles: {}, potValues: {} });
  const logsEndRef = useRef<HTMLDivElement>(null);
  const editorRef = useRef<HTMLTextAreaElement>(null);
  const speechRef = useRef<SpeechSynthesis | null>(null);

  useEffect(() => {
      if (typeof window !== 'undefined') speechRef.current = window.speechSynthesis;
      
      const handleKeyDown = (e: KeyboardEvent) => {
          if ((e.key === 'Delete' || e.key === 'Backspace') && selectedWireId) {
              setWires(prev => prev.filter(w => w.id !== selectedWireId));
              setSelectedWireId(null);
          }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => window.removeEventListener('keydown', handleKeyDown);
  }, [selectedWireId]);

  const addComponent = (typeKey: string) => {
    // @ts-ignore
    const template = COMPONENT_TYPES[typeKey];
    if (template.tier === 'pro' && userPlan === 'free') {
      setShowUpgradeModal(true);
      return;
    }
    const newComponent = {
      id: generateId(), type: typeKey,
      x: 200 + Math.random() * 100, y: 200 + Math.random() * 100, rotation: 0,
      state: { angle: 0, value: 0, on: false } 
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
      setWires([...wires, {
        id: generateId(),
        startComp: wireStart.compId, startPin: wireStart.pinId,
        endComp: compId, endPin: pinId,
        color: '#10B981' 
      }]);
      setWireStart(null);
    } else {
      setWireStart({ compId, pinId });
    }
  };

  const handlePotChange = (compId: string, newVal: number) => {
    setComponents(prev => prev.map(c => c.id === compId ? { ...c, state: { ...c.state, value: newVal } } : c));
    // @ts-ignore
    simulationRef.current.potValues[compId] = newVal;
  };

  const handleCodeSelect = (e: React.SyntheticEvent<HTMLTextAreaElement>) => {
    const target = e.currentTarget;
    setSelection({ start: target.selectionStart, end: target.selectionEnd, text: code.substring(target.selectionStart, target.selectionEnd) });
  };

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
      speechRef.current.speak(new SpeechSynthesisUtterance('')); // Prime audio
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

  const handleAIGenerate = async () => {
    if (!aiPrompt.trim()) return;
    setIsGeneratingAI(true);
    setAiResult(null);
    
    const genSystemPrompt = `You are an expert electronics engineer. Return raw JSON: { "code": "C++", "explanation": "summary", "components": [{"type": "ARDUINO", "id": "u1"}], "connections": [{"from": "u1:13", "to": "led1:anode"}] }.
    Use EXACT types: ARDUINO, ESP32, ESP8266, LED, RESISTOR, BUTTON, SERVO, POT.
    Use EXACT Pins: Arduino(13, 12, GND_1, 5V, A0), LED(anode, cathode), RESISTOR(t1, t2), BUTTON(1a, 1b), SERVO(GND, VCC, SIG).
    ALWAYS include "code" field with the Arduino Sketch.`;

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
      if (!aiResult || !aiResult.components) return;
      
      // Ensure code is applied from AI
      if (aiResult.code) setCode(aiResult.code);

      const newComps: any[] = [];
      let gridX = 350;
      let gridY = 100;
      const spacingX = 150;
      const spacingY = 150;
      let compCount = 0;
      
      let mcuX = 50, mcuY = 100;

      if (Array.isArray(aiResult.components)) {
          aiResult.components.forEach((c: any) => {
              let type = c.type ? c.type.toUpperCase() : "";
              
              // FIX: Map common AI aliases to Internal Types
              if (type.includes('ARDUINO')) type = 'ARDUINO';
              if (type.includes('ESP32')) type = 'ESP32';
              if (type.includes('BUTTON')) type = 'BUTTON';
              if (type.includes('POT')) type = 'POT';

              if (!COMPONENT_TYPES[type]) return; // Skip invalid

              let x, y;
              if (['ARDUINO', 'ESP32', 'ESP8266'].includes(type)) {
                  x = mcuX; 
                  y = mcuY;
              } else {
                  x = gridX + (compCount % 3) * spacingX;
                  y = gridY + Math.floor(compCount / 3) * spacingY;
                  compCount++;
              }

              newComps.push({
                  id: c.id,
                  type: type,
                  x: x,
                  y: y,
                  rotation: 0,
                  state: { angle: 0, value: 0, on: false }
              });
          });
      }

      setComponents(newComps);

      const newWires: any[] = [];
      if (Array.isArray(aiResult.connections)) {
          aiResult.connections.forEach((conn: any) => {
              if (!conn.from || !conn.to) return;
              let [sId, sPin] = conn.from.split(':');
              let [eId, ePin] = conn.to.split(':');

              const sComp = newComps.find(c => c.id === sId);
              const eComp = newComps.find(c => c.id === eId);
              
              if (sComp && eComp) {
                 // FIX: Normalize Pins BEFORE creating wire
                 const normSPin = normalizePin(sComp.type, sPin);
                 const normEPin = normalizePin(eComp.type, ePin);

                 newWires.push({
                     id: generateId(),
                     startComp: sId, startPin: normSPin,
                     endComp: eId, endPin: normEPin,
                     color: '#10B981'
                 });
              }
          });
      }

      setWires(newWires);
      setShowAIModal(false);
      setAiResult(null);
      setAiPrompt('');
  };

  // --- SIMULATION ENGINE ---

  const runSimulationStep = async () => {
    if (!simulationRef.current.active) return;
    
    const lines = code.split('\n');
    let loopStartLine = lines.findIndex(l => l.includes('void loop()')) + 1;
    if (loopStartLine === 0) loopStartLine = 0; 

    const sleep = (ms: number) => new Promise(r => setTimeout(r, ms));

    const processLine = async (line: string) => {
       if (!line || line.trim().startsWith('//')) return;
       
       const printMatch = line.match(/Serial\.println\("(.+)"\)/);
       if (printMatch && printMatch[1]) {
         setSerialOutput(prev => [...prev.slice(-29), `> ${printMatch[1]}`]);
       }

       const dwMatch = line.match(/digitalWrite\((\w+),\s*(HIGH|LOW)\)/);
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
    };

    let currentLine = loopStartLine;
    while (simulationRef.current.active) {
      if (currentLine >= lines.length || lines[currentLine].includes('}')) {
        currentLine = loopStartLine;
        await sleep(10);
      }
      await processLine(lines[currentLine]);
      currentLine++;
      await sleep(1); 
    }
  };

  const updateCircuitState = () => {
    const activeSources: any[] = [];
    const mcus = components.filter(c => ['ARDUINO', 'ESP32', 'ESP8266'].includes(c.type));
    
    mcus.forEach(mcu => {
        Object.keys(simulationRef.current.pinStates).forEach(pin => {
            if (simulationRef.current.pinStates[pin] === 1) {
                activeSources.push({ compId: mcu.id, pinId: pin });
            }
        });
        activeSources.push({ compId: mcu.id, pinId: '5V' });
        activeSources.push({ compId: mcu.id, pinId: '3.3V' });
        activeSources.push({ compId: mcu.id, pinId: 'VIN' });
    });

    const poweredPins = new Set();
    let queue = [...activeSources];
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
    }

    setComponents(prev => prev.map(c => {
      if (c.type === 'LED') {
        return { ...c, state: { on: poweredPins.has(`${c.id}-anode`) } }; 
      }
      return c;
    }));
  };

  const toggleSimulation = () => {
    if (isSimulating) {
      setIsSimulating(false);
      simulationRef.current.active = false;
      simulationRef.current.pinStates = {};
      setComponents(prev => prev.map(c => ({ ...c, state: { ...c.state, on: false } })));
    } else {
      setIsSimulating(true);
      simulationRef.current.active = true;
      setSerialOutput(['> Booting Kernel...', '> System Ready.']);
      runSimulationStep();
    }
  };

  // --- VISUAL HELPERS ---

  const getPinCoords = (compId: string, pinId: string) => {
    const comp = components.find(c => c.id === compId);
    if (!comp) return { x: 0, y: 0 };
    // @ts-ignore
    const typeDef = COMPONENT_TYPES[comp.type];
    if (!typeDef) return { x: comp.x, y: comp.y }; // Fallback if type is unknown
    
    const pinDef = typeDef.pins.find((p: any) => p.id === pinId);
    // FIX: If pinDef is missing (AI generated bad ID), fallback to component center
    if (!pinDef) return { x: comp.x + (typeDef.width / 2), y: comp.y + (typeDef.height / 2) };
    
    return { x: comp.x + pinDef.x, y: comp.y + pinDef.y };
  };

  const getWirePath = (s: any, e: any) => {
      if (wireMode === 'angled') {
          const midX = s.x + (e.x - s.x) / 2;
          return `M ${s.x} ${s.y} L ${midX} ${s.y} L ${midX} ${e.y} L ${e.x} ${e.y}`;
      }
      // Curve
      const dx = Math.abs(e.x - s.x);
      const controlOffset = Math.max(dx * 0.5, 50);
      return `M ${s.x} ${s.y} C ${s.x + controlOffset} ${s.y}, ${e.x - controlOffset} ${e.y}, ${e.x} ${e.y}`;
  };

  const handleMouseDown = (e: React.MouseEvent, compId: string) => {
    if (isSimulating) return; 
    setDraggedComponent({ id: compId, offsetX: e.clientX, offsetY: e.clientY });
  };

  const handleMouseMove = (e: MouseEvent) => {
    setMousePos({ x: e.clientX, y: e.clientY });
    if (draggedComponent) {
      setComponents(prev => prev.map(c => c.id === draggedComponent.id ? { ...c, x: e.clientX - draggedComponent.offsetX, y: e.clientY - draggedComponent.offsetY } : c));
    }
  };

  useEffect(() => {
    // @ts-ignore
    window.addEventListener('mousemove', handleMouseMove);
    window.addEventListener('mouseup', () => setDraggedComponent(null));
    // @ts-ignore
    return () => { window.removeEventListener('mousemove', handleMouseMove); window.removeEventListener('mouseup', () => setDraggedComponent(null)); };
  }, [draggedComponent]);

  // --- RENDERERS ---

  const renderRealisticComponent = (comp: any) => {
    // @ts-ignore
    const typeDef = COMPONENT_TYPES[comp.type];
    if (!typeDef) return null;
    const { width, height } = typeDef;
    
    const renderPins = () => typeDef.pins.map((pin: any) => (
      <div
        key={pin.id}
        onClick={(e) => handlePinClick(comp.id, pin.id, e)}
        className={`absolute w-3 h-3 rounded-full cursor-crosshair z-30 transition-all ${
          wireStart?.pinId === pin.id && wireStart?.compId === comp.id 
            ? 'bg-green-400 scale-150 ring-2 ring-green-200' 
            : 'bg-yellow-500/40 hover:bg-yellow-400 border border-yellow-600/50'
        }`}
        style={{ left: pin.x - 6, top: pin.y - 6 }}
        title={pin.label}
      />
    ));

    return (
        <div
            key={comp.id}
            onMouseDown={(e) => handleMouseDown(e, comp.id)}
            style={{
                position: 'absolute',
                left: comp.x,
                top: comp.y,
                width, height,
                transform: `rotate(${comp.rotation}deg)`,
                zIndex: draggedComponent?.id === comp.id ? 50 : 10
            }}
            className="group select-none"
        >
            {!isSimulating && (
                <button onClick={(e) => {e.stopPropagation(); removeComponent(comp.id)}} className="absolute -top-2 -right-2 bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity z-40 shadow-lg hover:scale-110"><Trash2 size={12} /></button>
            )}

            {/* --- COMPONENT VISUALS --- */}
            {comp.type === 'ARDUINO' && (
                <div className="w-full h-full bg-[#00878F] rounded-sm shadow-[0_10px_20px_rgba(0,0,0,0.3)] border-b-4 border-[#006269] relative overflow-hidden">
                    <div className="absolute top-[-10px] left-4 w-12 h-12 bg-gray-300 rounded shadow-sm border border-gray-400"></div>
                    <div className="absolute bottom-[-5px] left-4 w-12 h-14 bg-black rounded shadow-sm"></div>
                    <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-36 h-10 bg-[#222] rounded flex items-center justify-center">
                        <span className="text-[8px] text-gray-500 font-mono tracking-widest">ATMEGA328P</span>
                    </div>
                    <div className="absolute top-1 left-8 right-8 h-4 bg-black flex justify-between px-1 items-center">
                        {Array(14).fill(0).map((_,i) => <div key={i} className="w-1.5 h-1.5 bg-[#111] border border-gray-700 rounded-full"></div>)}
                    </div>
                    <div className="absolute bottom-1 left-14 right-14 h-4 bg-black flex justify-between px-1 items-center">
                        {Array(6).fill(0).map((_,i) => <div key={i} className="w-1.5 h-1.5 bg-[#111] border border-gray-700 rounded-full"></div>)}
                    </div>
                    <div className="absolute top-12 right-4 text-white font-bold italic font-sans opacity-90 text-sm text-right">ARDUINO<br/><span className="text-[10px] not-italic font-normal">UNO</span></div>
                    <div className="absolute top-1/2 right-4 flex flex-col gap-1">
                        <div className={`w-2 h-1 bg-yellow-300 rounded-full ${simulationRef.current.active ? 'animate-pulse' : 'opacity-50'}`}></div>
                        <div className="w-2 h-1 bg-yellow-300 rounded-full opacity-50"></div>
                    </div>
                    <div className={`absolute bottom-16 left-8 w-2 h-1 bg-orange-400 rounded-sm ${simulationRef.current.pinStates['13'] ? 'shadow-[0_0_8px_rgba(251,146,60,1)] bg-orange-300' : 'opacity-40'}`}></div>
                </div>
            )}

            {/* --- ESP32 --- */}
            {comp.type === 'ESP32' && (
                <div className="w-full h-full bg-[#1a1a1a] rounded shadow-xl border border-gray-800 relative flex flex-col items-center pt-2">
                    <div className="w-[80%] h-24 bg-gradient-to-br from-gray-300 to-gray-400 rounded-sm border border-gray-500 shadow-inner flex items-center justify-center mb-2 relative">
                         <div className="w-2 h-2 bg-black/20 rounded-full absolute top-1 left-1"></div>
                         <span className="text-[8px] font-bold text-gray-600 transform -rotate-90">ESP-WROOM-32</span>
                    </div>
                    <div className="absolute left-0 top-12 bottom-4 w-3 bg-black flex flex-col justify-around items-center py-1">
                         {Array(15).fill(0).map((_,i) => <div key={i} className="w-1.5 h-1.5 bg-[#333] rounded-full border border-gray-600"></div>)}
                    </div>
                    <div className="absolute right-0 top-12 bottom-4 w-3 bg-black flex flex-col justify-around items-center py-1">
                         {Array(15).fill(0).map((_,i) => <div key={i} className="w-1.5 h-1.5 bg-[#333] rounded-full border border-gray-600"></div>)}
                    </div>
                    <div className="absolute bottom-2 left-4 w-4 h-6 bg-gray-300 rounded-sm shadow"></div>
                    <div className="absolute bottom-2 right-4 w-4 h-6 bg-gray-300 rounded-sm shadow"></div>
                    <div className="absolute bottom-6 text-[7px] text-white opacity-50">DEVKIT V1</div>
                </div>
            )}

            {/* --- ESP8266 --- */}
            {comp.type === 'ESP8266' && (
                <div className="w-full h-full bg-[#111] rounded shadow-xl border border-gray-800 relative flex flex-col items-center pt-6">
                    <div className="absolute bottom-[-5px] w-10 h-6 bg-gray-400 rounded"></div>
                    <div className="w-[80%] h-24 bg-gray-300 rounded-sm border border-gray-500 shadow-inner mb-4 relative">
                         <span className="absolute bottom-1 left-1 text-[6px] font-bold text-gray-600">ESP8266MOD</span>
                         <div className="absolute -top-4 left-0 w-full h-4 border-t border-yellow-600" style={{backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 2px, #b45309 2px, #b45309 4px)'}}></div>
                    </div>
                     <div className="absolute left-0 top-10 bottom-10 w-3 bg-black flex flex-col justify-around items-center py-1">
                         {Array(10).fill(0).map((_,i) => <div key={i} className="w-1.5 h-1.5 bg-[#333] rounded-full border border-gray-600"></div>)}
                    </div>
                    <div className="absolute right-0 top-10 bottom-10 w-3 bg-black flex flex-col justify-around items-center py-1">
                         {Array(10).fill(0).map((_,i) => <div key={i} className="w-1.5 h-1.5 bg-[#333] rounded-full border border-gray-600"></div>)}
                    </div>
                    <div className="text-[8px] text-white opacity-60 font-mono mt-auto mb-8">NodeMCU</div>
                </div>
            )}

            {/* --- LED --- */}
            {comp.type === 'LED' && (
                <div className="w-full h-full relative flex justify-center pointer-events-none">
                    <div className={`w-8 h-9 rounded-t-full rounded-b-md border border-red-900 transition-all duration-100 relative z-10 ${comp.state.on ? 'bg-red-500 shadow-[0_0_25px_rgba(239,68,68,0.8)]' : 'bg-red-800 opacity-80'}`}>
                        <div className="absolute top-2 left-2 w-2 h-2 bg-white rounded-full opacity-30"></div>
                    </div>
                    <div className="w-1 h-12 bg-gray-400 absolute bottom-2 left-2.5"></div>
                    <div className="w-1 h-14 bg-gray-400 absolute bottom-0 right-2.5"></div>
                </div>
            )}

            {/* --- RESISTOR --- */}
            {comp.type === 'RESISTOR' && (
                <div className="w-full h-full relative flex items-center justify-center">
                    <div className="w-full h-0.5 bg-gray-400 absolute"></div>
                    <div className="w-14 h-5 bg-[#E4D6A7] rounded-full relative overflow-hidden shadow-sm border border-[#cbbba0] flex items-center justify-center gap-1.5 z-10">
                        <div className="w-1.5 h-full bg-red-600"></div>
                        <div className="w-1.5 h-full bg-red-600"></div>
                        <div className="w-1.5 h-full bg-[#5C4033]"></div>
                        <div className="w-1.5 h-full bg-[#D4AF37]"></div>
                    </div>
                </div>
            )}

            {/* --- BUTTON --- */}
            {comp.type === 'BUTTON' && (
                <div className="w-full h-full bg-[#333] rounded shadow-md border-b-2 border-[#222] flex items-center justify-center relative">
                    <div className="absolute w-full h-[1px] bg-gray-500 top-1.5"></div>
                    <div className="absolute w-full h-[1px] bg-gray-500 bottom-1.5"></div>
                    <div className="w-8 h-8 bg-black rounded-full shadow-inner flex items-center justify-center active:scale-95 transition-transform cursor-pointer">
                        <div className="w-6 h-6 bg-[#222] rounded-full border border-[#444]"></div>
                    </div>
                    <div className="absolute -left-1 top-1 w-2 h-3 bg-gray-400 rounded-sm"></div>
                    <div className="absolute -right-1 top-1 w-2 h-3 bg-gray-400 rounded-sm"></div>
                    <div className="absolute -left-1 bottom-1 w-2 h-3 bg-gray-400 rounded-sm"></div>
                    <div className="absolute -right-1 bottom-1 w-2 h-3 bg-gray-400 rounded-sm"></div>
                </div>
            )}

            {/* --- SERVO --- */}
            {comp.type === 'SERVO' && (
                <div className="w-full h-full relative">
                    <div className="absolute top-8 w-full h-16 bg-blue-600 rounded shadow-md border border-blue-700">
                        <span className="absolute top-2 left-2 text-[8px] text-white opacity-80">SG90</span>
                    </div>
                    <div className="absolute top-10 -left-2 w-2 h-6 bg-blue-600 rounded-l-sm"></div>
                    <div className="absolute top-10 -right-2 w-2 h-6 bg-blue-600 rounded-r-sm"></div>
                    <div className="absolute top-0 left-1/2 transform -translate-x-1/2 w-full h-10 flex justify-center pointer-events-none">
                         <div 
                            className="w-2 h-8 bg-white rounded-full absolute top-2 transition-transform duration-300 origin-bottom"
                            style={{ transform: `rotate(${(comp.state.angle || 0) - 90}deg)` }}
                         >
                             <div className="w-12 h-2 bg-white rounded-full absolute -left-5 top-1"></div>
                         </div>
                    </div>
                    <div className="absolute bottom-0 left-4 w-6 h-20 bg-gradient-to-r from-yellow-600 via-red-600 to-yellow-900 opacity-50 -z-10 rounded-b"></div>
                </div>
            )}

            {/* --- POT --- */}
            {comp.type === 'POT' && (
                <div className="w-full h-full relative">
                    <div className="w-full h-full bg-gray-300 rounded-full border-2 border-gray-400 shadow-md flex items-center justify-center">
                        <div className="w-[80%] h-[80%] bg-gray-200 rounded-full border border-gray-300 flex items-center justify-center relative">
                            <div 
                                className="w-full h-2 bg-blue-500 absolute top-1/2 transform -translate-y-1/2 pointer-events-none transition-transform duration-75"
                                style={{ transform: `translateY(-50%) rotate(${(comp.state.value || 0) * 2.7}deg)` }}
                            ></div>
                             <div className="w-8 h-8 bg-white rounded-full border border-gray-300 shadow-sm z-10"></div>
                        </div>
                    </div>
                    <input 
                        type="range" 
                        min="0" max="100" 
                        value={comp.state.value || 0}
                        onChange={(e) => handlePotChange(comp.id, parseInt(e.target.value))}
                        className="absolute -bottom-6 left-0 w-full h-4 opacity-0 cursor-pointer z-50"
                    />
                    <div className="absolute -bottom-6 left-0 w-full h-1 bg-gray-600 rounded flex items-center">
                         <div className="h-3 w-3 bg-blue-500 rounded-full shadow" style={{ marginLeft: `${comp.state.value}%` }}></div>
                    </div>
                </div>
            )}

            {renderPins()}
        </div>
    );
  };


  return (
    <div className="flex h-screen w-full bg-[#0F0F13] text-gray-100 overflow-hidden font-sans select-none">
      
      {/* --- LEFT SIDEBAR: COMPONENTS --- */}
      <div className="w-72 bg-[#141419] border-r border-gray-800 flex flex-col z-10 shadow-2xl">
        <div className="p-5 border-b border-gray-800 flex items-center gap-2">
            <Zap size={18} className="text-white" fill="currentColor"/>
            <h1 className="font-bold text-lg text-white">Circuit<span className="text-blue-500">Pro</span></h1>
        </div>
        <div className="p-4 flex-1 overflow-y-auto custom-scrollbar">
          <div className="grid grid-cols-2 gap-3">
            {Object.keys(COMPONENT_TYPES).map(key => (
               <div key={key} onClick={() => addComponent(key)} className="p-3 rounded-xl border border-gray-700 bg-[#1E1E24] hover:border-blue-500 cursor-pointer flex flex-col items-center gap-2">
                  <div className="p-2 bg-blue-500/10 rounded-full text-blue-400"><Cpu size={20}/></div>
                  <span className="text-[11px] font-medium">{COMPONENT_TYPES[key].name}</span>
               </div>
            ))}
          </div>
        </div>
      </div>

      {/* --- MAIN WORKSPACE --- */}
      <div className="flex-1 flex flex-col relative bg-[#0A0A0C]">
        <div className="h-14 bg-[#141419] border-b border-gray-800 flex items-center justify-between px-6 shadow-sm z-20">
            <div className="flex items-center gap-4">
                <button onClick={toggleSimulation} className={`flex items-center gap-2 px-5 py-1.5 rounded-full text-sm font-bold ${isSimulating ? 'bg-red-500/20 text-red-500' : 'bg-green-500 text-black'}`}>
                    {isSimulating ? <Square size={14}/> : <Play size={14}/>} {isSimulating ? 'STOP' : 'SIMULATE'}
                </button>
                {selectedWireId && (
                    <button onClick={() => { setWires(w => w.filter(x => x.id !== selectedWireId)); setSelectedWireId(null); }} className="text-red-400 text-xs flex items-center gap-1 hover:text-red-300 ml-4">
                        <Trash2 size={14}/> Delete Wire
                    </button>
                )}
            </div>

            <div className="flex items-center gap-3">
                <div className="flex bg-black p-1 rounded border border-gray-700">
                    <button onClick={() => setWireMode('curve')} className={`p-1 rounded ${wireMode==='curve'?'bg-gray-700 text-white':'text-gray-500'}`} title="Curved Wires"><GitCommit size={14}/></button>
                    <button onClick={() => setWireMode('angled')} className={`p-1 rounded ${wireMode==='angled'?'bg-gray-700 text-white':'text-gray-500'}`} title="Angled Wires"><CornerDownRight size={14}/></button>
                </div>

                <button 
                    onClick={() => setShowAIModal(true)}
                    className="flex items-center gap-2 px-3 py-1.5 bg-blue-500/10 text-blue-400 border border-blue-500/30 rounded-lg hover:bg-blue-500/20 transition-all text-sm font-medium"
                >
                    <Sparkles size={14} /> AI Assistant
                </button>

                <div className="flex bg-black rounded-lg p-1 border border-gray-800">
                    <button onClick={() => setActiveView('canvas')} className={`p-1.5 rounded-md transition-colors ${activeView === 'canvas' ? 'bg-gray-800 text-white' : 'text-gray-500 hover:text-gray-300'}`} title="Canvas"><Zap size={16} /></button>
                    <button onClick={() => setActiveView('both')} className={`p-1.5 rounded-md transition-colors ${activeView === 'both' ? 'bg-gray-800 text-white' : 'text-gray-500 hover:text-gray-300'}`} title="Split"><RotateCw size={16} /></button>
                    <button onClick={() => setActiveView('code')} className={`p-1.5 rounded-md transition-colors ${activeView === 'code' ? 'bg-gray-800 text-white' : 'text-gray-500 hover:text-gray-300'}`} title="Code"><Code size={16} /></button>
                </div>
            </div>
        </div>

        {/* Workspace Split */}
        <div className="flex-1 flex overflow-hidden relative">
            
            {/* --- CANVAS AREA --- */}
            <div className={`relative transition-all duration-300 ${activeView === 'code' ? 'w-0 opacity-0' : activeView === 'both' ? 'w-2/3' : 'w-full'} bg-[#0F0F13] overflow-hidden`}>
                
                {/* Dot Grid */}
                <div 
                    className="absolute inset-0 opacity-20 pointer-events-none"
                    style={{
                        backgroundImage: `radial-gradient(#444 1px, transparent 1px)`,
                        backgroundSize: `${GRID_SIZE}px ${GRID_SIZE}px`
                    }}
                />

                {/* Components Layer (Rendered First = Behind Wires) */}
                {components.map(comp => renderRealisticComponent(comp))}

                {/* SVG Layer (Rendered Second = On Top of Components, z-20) */}
                <svg className="absolute inset-0 w-full h-full pointer-events-none z-20">
                    {/* Wires */}
                    {wires.map(wire => {
                        const start = getPinCoords(wire.startComp, wire.startPin);
                        const end = getPinCoords(wire.endComp, wire.endPin);
                        const isSelected = wire.id === selectedWireId;

                        return (
                            <path 
                                key={wire.id} 
                                d={getWirePath(start, end)} 
                                stroke={isSelected ? "#3B82F6" : wire.color} 
                                strokeWidth={isSelected ? "6" : "4"} 
                                fill="none" 
                                className="cursor-pointer pointer-events-auto hover:opacity-80 transition-all"
                                onClick={(ev) => { ev.stopPropagation(); setSelectedWireId(wire.id); }}
                            />
                        );
                    })}
                    
                    {/* Active Wire Preview */}
                    {wireStart && (
                        <line 
                            x1={getPinCoords(wireStart.compId, wireStart.pinId).x} 
                            y1={getPinCoords(wireStart.compId, wireStart.pinId).y} 
                            x2={mousePos.x - 288} // Sidebar offset approx
                            y2={mousePos.y - 56}  // Header offset approx
                            stroke="#10B981" 
                            strokeWidth="2" 
                            strokeDasharray="5,5" 
                            className="opacity-80"
                        />
                    )}
                </svg>
            </div>

            {/* --- CODE & SERIAL --- */}
            <div className={`${activeView === 'canvas' ? 'hidden' : activeView === 'both' ? 'w-1/3' : 'w-full'} bg-[#0d0d10] border-l border-gray-800 flex flex-col`}>
                
                {/* Code Tab */}
                <div className="flex bg-[#141419] border-b border-gray-800 items-center justify-between pr-2">
                    <div className="px-4 py-2 text-xs font-semibold text-blue-400 border-b-2 border-blue-500 bg-[#1A1A20] flex items-center gap-2">
                        <Code size={12} /> sketch.ino
                    </div>
                    <button 
                        onClick={handleExplainWithVoice}
                        disabled={isGeneratingAI}
                        className={`flex items-center gap-2 text-[10px] px-2 py-1 rounded border transition-all ${isSpeaking ? 'bg-red-500/20 text-red-400 border-red-500/40' : 'bg-gray-800 text-gray-300 border-gray-700 hover:text-white'}`}
                        title="Explain Code with Voice"
                    >
                        {isGeneratingAI && !isSpeaking ? (
                            <Loader2 size={12} className="animate-spin" />
                        ) : isSpeaking ? (
                            <VolumeX size={12} />
                        ) : (
                            <Volume2 size={12} />
                        )}
                        {isSpeaking ? 'Stop Speaking' : (selection.end > selection.start ? 'Explain Selection' : 'Explain Code')}
                    </button>
                </div>

                <div className="flex-1 relative">
                    <textarea 
                        ref={editorRef}
                        value={code}
                        onChange={(e) => setCode(e.target.value)}
                        onSelect={handleCodeSelect}
                        className="absolute inset-0 w-full h-full bg-[#0d0d10] text-gray-300 p-4 font-mono text-sm resize-none focus:outline-none leading-relaxed selection:bg-blue-500/40"
                        spellCheck="false"
                        disabled={isSimulating}
                    />
                </div>

                {/* Serial Monitor */}
                <div className="h-1/3 bg-black border-t border-gray-800 flex flex-col font-mono text-xs">
                    <div className="px-3 py-1 bg-[#141419] flex items-center justify-between text-gray-500 border-b border-gray-800">
                        <div className="flex items-center gap-2">
                            <Terminal size={12} /> <span>Serial Monitor (9600 baud)</span>
                        </div>
                        <button onClick={() => setSerialOutput([])} className="hover:text-white"><Trash2 size={12} /></button>
                    </div>
                    <div className="flex-1 overflow-y-auto p-3 text-green-500 space-y-1 font-semibold">
                        {serialOutput.map((line, i) => <div key={i}>{line}</div>)}
                        <div ref={logsEndRef} />
                    </div>
                </div>
            </div>

        </div>
      </div>
    </div>
  );
}
