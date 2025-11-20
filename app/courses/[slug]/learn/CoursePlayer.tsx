'use client';
import React, { useState } from 'react';
import { PlayCircle, FileText, HelpCircle, CheckCircle, Lock, Menu } from 'lucide-react';
import { markLessonComplete, checkCourseCompletion } from '@/app/courses/actions';
import Quiz from '@/components/Quiz';
import Certificate from '@/components/Certificate';
import { useRouter } from 'next/navigation';

export default function CoursePlayer({ course, modules, progress, userProfile }: any) {
  // Flatten lessons for easier navigation
  const allLessons = modules.flatMap((m: any) => m.lessons);
  
  // Find first incomplete lesson or default to first
  const initialLesson = allLessons.find((l: any) => !progress.some((p: any) => p.lesson_id === l.id && p.is_completed)) || allLessons[0];
  
  const [activeLesson, setActiveLesson] = useState(initialLesson);
  const [localProgress, setLocalProgress] = useState(progress); // Optimistic UI
  const [certificate, setCertificate] = useState<any>(null);
  const [sidebarOpen, setSidebarOpen] = useState(true); // Mobile toggle

  // Helper to check completion
  const isCompleted = (lId: string) => localProgress.some((p: any) => p.lesson_id === lId && p.is_completed);

  const handleLessonComplete = async (score?: number) => {
    // 1. Optimistic Update
    const newEntry = { lesson_id: activeLesson.id, is_completed: true, quiz_score: score };
    setLocalProgress([...localProgress, newEntry]);

    // 2. Server Action
    await markLessonComplete(activeLesson.id, score);

    // 3. Check Certificate
    const cert = await checkCourseCompletion(course.id);
    if (cert) setCertificate(cert);

    // 4. Auto-advance (optional, maybe just show "Next" button enabled)
  };

  const handleNext = () => {
    const currIdx = allLessons.findIndex((l: any) => l.id === activeLesson.id);
    if (currIdx < allLessons.length - 1) {
      setActiveLesson(allLessons[currIdx + 1]);
      window.scrollTo(0,0);
    }
  };

  // Calculate Percentage
  const percent = Math.round((localProgress.filter((p: any) => p.is_completed && allLessons.some((l:any)=>l.id===p.lesson_id)).length / allLessons.length) * 100);

  if (certificate) {
      return <Certificate courseName={course.title} userName={userProfile.display_name} date={certificate.issued_at} />;
  }

  return (
    <div className="flex h-[calc(100vh-64px)] bg-slate-50" dir="rtl">
      
      {/* RIGHT SIDEBAR (Navigation) */}
      <div className={`w-80 bg-white border-l border-slate-200 flex-shrink-0 flex flex-col transition-all ${sidebarOpen ? 'translate-x-0' : 'translate-x-full absolute right-0 h-full z-20'}`}>
         <div className="p-4 border-b border-slate-100">
             <h2 className="font-bold text-slate-800">{course.title}</h2>
             <div className="mt-3 bg-slate-100 rounded-full h-2 overflow-hidden">
                 <div className="bg-green-500 h-full transition-all duration-500" style={{width: `${percent}%`}}></div>
             </div>
             <p className="text-xs text-slate-500 mt-1 text-left">{percent}% مكتمل</p>
         </div>
         
         <div className="flex-1 overflow-y-auto p-2 space-y-4">
             {modules.map((mod: any) => (
                 <div key={mod.id}>
                     <div className="px-3 py-2 text-xs font-bold text-slate-500 uppercase tracking-wider">{mod.title}</div>
                     <div className="space-y-1">
                         {mod.lessons.map((lesson: any) => {
                             const active = activeLesson.id === lesson.id;
                             const done = isCompleted(lesson.id);
                             
                             // Lock logic for strict progression (optional)
                             // const locked = !done && index > 0 && !isCompleted(allLessons[index-1].id);

                             return (
                                 <button 
                                    key={lesson.id}
                                    onClick={() => setActiveLesson(lesson)}
                                    className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-colors ${active ? 'bg-blue-50 text-blue-700 font-medium' : 'hover:bg-slate-50 text-slate-700'}`}
                                 >
                                     {done ? <CheckCircle size={16} className="text-green-500"/> : 
                                      lesson.type === 'video' ? <PlayCircle size={16}/> : 
                                      lesson.type === 'quiz' ? <HelpCircle size={16}/> : <FileText size={16}/>}
                                     <span className="truncate">{lesson.title}</span>
                                 </button>
                             )
                         })}
                     </div>
                 </div>
             ))}
         </div>
      </div>

      {/* MAIN CONTENT */}
      <div className="flex-1 overflow-y-auto relative">
         {/* Mobile Toggle */}
         <button onClick={()=>setSidebarOpen(!sidebarOpen)} className="absolute top-4 right-4 md:hidden z-30 bg-white p-2 rounded shadow border"><Menu/></button>

         <div className="max-w-4xl mx-auto p-6 md:p-12">
             <div className="mb-8">
                 <h1 className="text-3xl font-bold text-slate-900 mb-2">{activeLesson.title}</h1>
                 <div className="flex gap-2">
                    <span className="px-2 py-1 bg-slate-100 rounded text-xs text-slate-600">{activeLesson.duration} دقيقة</span>
                    <span className="px-2 py-1 bg-blue-50 text-blue-600 rounded text-xs font-medium uppercase">{activeLesson.type}</span>
                 </div>
             </div>

             {/* CONTENT RENDERER */}
             <div className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden min-h-[400px]">
                 {activeLesson.type === 'video' && activeLesson.video_url && (
                     <div className="aspect-video w-full">
                         <iframe 
                            src={activeLesson.video_url.replace('watch?v=', 'embed/')} 
                            className="w-full h-full" 
                            allowFullScreen 
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                         />
                     </div>
                 )}

                 {activeLesson.type === 'text' && (
                     <div className="p-8 prose prose-lg max-w-none prose-headings:text-slate-900 prose-p:text-slate-700" dangerouslySetInnerHTML={{__html: activeLesson.content}} />
                 )}

                 {activeLesson.type === 'quiz' && (
                     <Quiz questions={activeLesson.quiz_questions} onComplete={(score) => {
                         if (score >= 70) handleLessonComplete(score);
                     }} />
                 )}
             </div>

             {/* FOOTER ACTIONS */}
             <div className="mt-8 flex justify-between items-center">
                 {/* Only show 'Complete' button for non-quiz types, quizzes mark themselves */}
                 {activeLesson.type !== 'quiz' && (
                     <button 
                        onClick={() => handleLessonComplete()}
                        disabled={isCompleted(activeLesson.id)}
                        className={`px-6 py-3 rounded-lg font-bold shadow-sm transition-all ${isCompleted(activeLesson.id) ? 'bg-green-100 text-green-700' : 'bg-blue-600 text-white hover:bg-blue-700'}`}
                     >
                         {isCompleted(activeLesson.id) ? 'تم الإكمال ✅' : 'إكمال الدرس'}
                     </button>
                 )}
                 
                 <button onClick={handleNext} className="text-slate-600 hover:text-blue-600 font-medium flex items-center gap-2">
                    التالي: {allLessons[allLessons.findIndex((l:any)=>l.id===activeLesson.id)+1]?.title || "إنهاء الدورة"} &larr;
                 </button>
             </div>
         </div>
      </div>

    </div>
  );
}
