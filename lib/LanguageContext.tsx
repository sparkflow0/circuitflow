'use client';
import React, { createContext, useContext, useState, useEffect } from 'react';
import { translations, Language } from './translations';

type LanguageContextType = {
  lang: Language;
  t: typeof translations['ar'];
  toggleLanguage: () => void;
  setLanguage: (lang: Language) => void;
  dir: 'rtl' | 'ltr';
};

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  // Default to Arabic ('ar')
  const [lang, setLang] = useState<Language>('ar');

  // Persist language preference
  useEffect(() => {
    const savedLang = localStorage.getItem('app-lang') as Language;
    if (savedLang) setLang(savedLang);
  }, []);

  const toggleLanguage = () => {
    const newLang = lang === 'ar' ? 'en' : 'ar';
    setLang(newLang);
    localStorage.setItem('app-lang', newLang);
  };

  const setLanguage = (newLang: Language) => {
    setLang(newLang);
    localStorage.setItem('app-lang', newLang);
  };

  const dir = lang === 'ar' ? 'rtl' : 'ltr';
  const t = translations[lang];

  // Update HTML dir attribute dynamically
  useEffect(() => {
    document.documentElement.dir = dir;
    document.documentElement.lang = lang;
  }, [dir, lang]);

  return (
    <LanguageContext.Provider value={{ lang, t, toggleLanguage, setLanguage, dir }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}
