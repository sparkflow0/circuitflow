
export type Language = 'ar' | 'en';

export const translations = {
  ar: {
    // Navbar
    brand: 'Circuit Flow',
    courses: 'الدورات',
    store: 'المتجر',
    blog: 'المدونة',
    simulator: 'المحاكي',
    dashboard: 'لوحة التحكم',
    signin: 'تسجيل الدخول',
    getStarted: 'ابدأ الآن',
    
    // Landing Page
    heroTitle: 'احترف الأردوينو بدون أجهزة',
    heroSubtitle: 'محاكي متطور مدعوم بالذكاء الاصطناعي مع دورات تعليمية احترافية. صمم الدوائر، اكتب الكود، واكتشف الأخطاء في متصفحك.',
    ctaStart: 'جرب المحاكي مجاناً',
    ctaCourses: 'تصفح الدورات',
    featureSim: 'محاكي المتصفح',
    featureSimDesc: 'محاكاة فورية للدوائر مع دعم ESP32. لا حاجة للتثبيت.',
    featureLearn: 'التعليم التفاعلي',
    featureLearnDesc: 'اتبع أدلة خطوة بخطوة تتزامن مباشرة مع مساحة العمل الخاصة بك.',
    featureAssets: 'الأصول الرقمية',
    featureAssetsDesc: 'اشترِ قوالب المشاريع، وتخطيطات PCB، ومكتبات المكونات المتقدمة.',

    // Simulator
    stop: 'إيقاف',
    simulate: 'تشغيل المحاكاة',
    aiAssistant: 'مساعد الذكاء الاصطناعي',
    deleteWire: 'حذف السلك',
    deleteComponents: 'حذف المكونات',
    curve: 'منحني',
    angled: 'زاوية',
    grid: 'الشبكة',
    sketch: 'الكود البرمجي',
    debug: 'تصحيح الأخطاء',
    explain: 'شرح الكود',
    serialMonitor: 'الشاشة التسلسلية',
    
    // AI Modal
    aiTitle: 'مساعد الذكاء الاصطناعي',
    aiPlaceholder: 'وصف الدائرة (مثال: وميض LED على الرجل 13)...',
    aiGenerate: 'توليد',
    aiGenerating: 'جاري التوليد...',
    aiSuccess: 'تمت العملية بنجاح!',
    aiApply: 'تطبيق',
    aiDiscard: 'إلغاء',
    
    // Generation Options
    genCircuit: 'مخطط الدائرة',
    genCode: 'كود الأردوينو',
    genFlowchart: 'مخطط التدفق',
    genBlock: 'مخطط الكتل',
  },
  en: {
    // Navbar
    brand: 'Circuit Flow',
    courses: 'Courses',
    store: 'Store',
    blog: 'Blog',
    simulator: 'Simulator',
    dashboard: 'Dashboard',
    signin: 'Sign In',
    getStarted: 'Get Started',

    // Landing Page
    heroTitle: 'Master Arduino without the Hardware',
    heroSubtitle: 'An advanced AI-powered simulator combined with expert-led courses. Design circuits, write code, and debug in your browser.',
    ctaStart: 'Start Simulating Free',
    ctaCourses: 'Explore Courses',
    featureSim: 'Browser Simulator',
    featureSimDesc: 'Real-time circuit simulation with ESP32 support. No installation required.',
    featureLearn: 'Interactive Learning',
    featureLearnDesc: 'Follow step-by-step guides that sync directly with your simulator workspace.',
    featureAssets: 'Digital Assets',
    featureAssetsDesc: 'Buy project templates, PCB layouts, and advanced component libraries.',

    // Simulator
    stop: 'STOP',
    simulate: 'SIMULATE',
    aiAssistant: 'AI Assistant',
    deleteWire: 'Delete Wire',
    deleteComponents: 'Delete Components',
    curve: 'Curve',
    angled: 'Angled',
    grid: 'Grid',
    sketch: 'sketch.ino',
    debug: 'Debug',
    explain: 'Explain',
    serialMonitor: 'Serial Monitor',

    // AI Modal
    aiTitle: 'AI Assistant',
    aiPlaceholder: 'Describe circuit (e.g. Blink an LED on pin 13)...',
    aiGenerate: 'Generate',
    aiGenerating: 'Generating...',
    aiSuccess: 'Success!',
    aiApply: 'Apply',
    aiDiscard: 'Discard',

    // Generation Options
    genCircuit: 'Circuit Diagram',
    genCode: 'Arduino Code',
    genFlowchart: 'Flowchart',
    genBlock: 'Block Diagram',
  }
};
