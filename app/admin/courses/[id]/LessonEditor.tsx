'use client';
import { useState } from 'react';
import { updateLesson } from '@/app/admin/actions';
import { ChevronDown, ChevronUp, Save } from 'lucide-react';

export default function LessonEditor({ lesson }: { lesson: any }) {
  const [expanded, setExpanded] = useState(false);
  const [saving, setSaving] = useState(false);

  const handleSave = async (e: React.FormEvent<HTMLFormElement>) => {
      e.preventDefault();
      setSaving(true);
      const formData = new FormData(e.currentTarget);
      const data = {
          title: formData.get('title'),
          type: formData.get('type'),
          video_url: formData.get('video_url'),
          duration: Number(formData.get('duration')),
          content: formData.get('content'),
      };
      await updateLesson(lesson.id, data);
      setSaving(false);
      setExpanded(false);
  };

  return (
    <div className="bg-white">
        <div className="p-3 flex items-center justify-between cursor-pointer hover:bg-slate-50" onClick={() => setExpanded(!expanded)}>
             <div className="flex items-center gap-3">
                 <span className="text-xs font-mono text-slate-400 uppercase w-12">{lesson.type}</span>
                 <span className="font-medium text-sm">{lesson.title}</span>
             </div>
             {expanded ? <ChevronUp size={16} className="text-slate-400"/> : <ChevronDown size={16} className="text-slate-400"/>}
        </div>
        
        {expanded && (
            <form onSubmit={handleSave} className="p-4 bg-slate-50 border-t border-slate-100 space-y-4 text-sm">
                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <label className="block text-xs font-bold text-slate-500 mb-1">Title</label>
                        <input name="title" defaultValue={lesson.title} className="w-full p-2 border rounded"/>
                    </div>
                    <div>
                        <label className="block text-xs font-bold text-slate-500 mb-1">Type</label>
                        <select name="type" defaultValue={lesson.type} className="w-full p-2 border rounded">
                            <option value="video">Video</option>
                            <option value="text">Text</option>
                            <option value="quiz">Quiz</option>
                        </select>
                    </div>
                </div>
                
                <div>
                    <label className="block text-xs font-bold text-slate-500 mb-1">Video URL (YouTube)</label>
                    <input name="video_url" defaultValue={lesson.video_url || ''} className="w-full p-2 border rounded"/>
                </div>

                <div>
                    <label className="block text-xs font-bold text-slate-500 mb-1">Content (HTML)</label>
                    <textarea name="content" defaultValue={lesson.content} className="w-full p-2 border rounded h-32 font-mono text-xs"/>
                </div>
                
                <div className="flex justify-end">
                    <button type="submit" disabled={saving} className="bg-blue-600 text-white px-4 py-2 rounded text-xs font-bold hover:bg-blue-700">
                        {saving ? 'Saving...' : 'Save Lesson'}
                    </button>
                </div>
            </form>
        )}
    </div>
  );
}
