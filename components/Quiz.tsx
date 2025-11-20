'use client';
import { useState } from 'react';
import { Button } from './ui/Button';
import { CheckCircle, XCircle } from 'lucide-react';

export default function Quiz({ questions, onComplete }: { questions: any[], onComplete: (score: number) => void }) {
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [submitted, setSubmitted] = useState(false);
  const [score, setScore] = useState(0);

  const handleSelect = (qId: string, opIdx: number) => {
    if (submitted) return;
    setAnswers(prev => ({ ...prev, [qId]: opIdx }));
  };

  const handleSubmit = () => {
    let correct = 0;
    questions.forEach(q => {
      if (answers[q.id] === q.correct_index) correct++;
    });
    const finalScore = Math.round((correct / questions.length) * 100);
    setScore(finalScore);
    setSubmitted(true);
    onComplete(finalScore);
  };

  return (
    <div className="space-y-8 p-6 max-w-2xl mx-auto" dir="rtl">
      {questions.map((q, idx) => (
        <div key={q.id} className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
          <h3 className="text-lg font-bold text-slate-900 mb-4">{idx + 1}. {q.question}</h3>
          <div className="space-y-3">
            {q.options.map((opt: string, oIdx: number) => {
              const isSelected = answers[q.id] === oIdx;
              const isCorrect = q.correct_index === oIdx;
              
              let style = "border-slate-200 hover:bg-slate-50";
              if (isSelected) style = "border-blue-500 bg-blue-50 ring-1 ring-blue-500";
              if (submitted) {
                if (isCorrect) style = "border-green-500 bg-green-50 ring-1 ring-green-500";
                else if (isSelected && !isCorrect) style = "border-red-500 bg-red-50 ring-1 ring-red-500";
              }

              return (
                <div 
                  key={oIdx}
                  onClick={() => handleSelect(q.id, oIdx)}
                  className={`p-4 rounded-lg border cursor-pointer flex items-center justify-between transition-all ${style}`}
                >
                  <span>{opt}</span>
                  {submitted && isCorrect && <CheckCircle className="text-green-600" size={20}/>}
                  {submitted && isSelected && !isCorrect && <XCircle className="text-red-600" size={20}/>}
                </div>
              );
            })}
          </div>
        </div>
      ))}
      
      {!submitted ? (
        <Button onClick={handleSubmit} className="w-full py-4 text-lg" disabled={Object.keys(answers).length < questions.length}>
          اعتماد الإجابات
        </Button>
      ) : (
        <div className={`p-6 rounded-xl text-center ${score >= 70 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
           <h3 className="text-2xl font-bold mb-2">النتيجة: {score}%</h3>
           <p>{score >= 70 ? 'أحسنت! لقد اجتزت الاختبار.' : 'حاول مرة أخرى لتحسين نتيجتك.'}</p>
        </div>
      )}
    </div>
  );
}
