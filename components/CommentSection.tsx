'use client';
import { useState } from 'react';
import { addComment } from '@/app/blog/actions';
import { Button } from './ui/Button';
import { User, Send } from 'lucide-react';

interface Comment {
  id: string;
  content: string;
  created_at: string;
  profiles: {
    display_name: string;
  };
}

export default function CommentSection({ postId, comments, user }: { postId: string, comments: Comment[], user: any }) {
  const [newComment, setNewComment] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newComment.trim()) return;
    
    setIsSubmitting(true);
    try {
      await addComment(postId, newComment);
      setNewComment('');
    } catch (error) {
      alert('Failed to post comment. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="mt-12 border-t border-gray-200 pt-8">
      <h3 className="text-2xl font-bold text-gray-900 mb-6 font-sans" dir="rtl">التعليقات ({comments.length})</h3>

      {/* Comment Form */}
      {user ? (
        <form onSubmit={handleSubmit} className="mb-10 bg-gray-50 p-4 rounded-xl border border-gray-200" dir="rtl">
          <label className="block text-sm font-medium text-gray-700 mb-2">أضف تعليقاً</label>
          <textarea
            value={newComment}
            onChange={(e) => setNewComment(e.target.value)}
            className="w-full p-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 outline-none min-h-[100px]"
            placeholder="شاركنا رأيك..."
            required
          />
          <div className="mt-3 flex justify-end">
            <Button type="submit" disabled={isSubmitting} className="flex items-center gap-2">
              <Send size={16} className="ml-1"/> إرسال
            </Button>
          </div>
        </form>
      ) : (
        <div className="bg-yellow-50 border border-yellow-200 p-4 rounded-lg text-center mb-8 text-yellow-800" dir="rtl">
          يرجى تسجيل الدخول للمشاركة في التعليقات.
        </div>
      )}

      {/* Comments List */}
      <div className="space-y-6" dir="rtl">
        {comments.map((comment) => (
          <div key={comment.id} className="flex gap-4 bg-white p-4 rounded-xl shadow-sm border border-gray-100">
            <div className="flex-shrink-0">
              <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                <User size={20} />
              </div>
            </div>
            <div className="flex-1">
              <div className="flex items-center justify-between mb-1">
                <h4 className="font-bold text-gray-900">{comment.profiles?.display_name || 'مستخدم'}</h4>
                <span className="text-xs text-gray-500">
                  {new Date(comment.created_at).toLocaleDateString('ar-EG')}
                </span>
              </div>
              <p className="text-gray-700 leading-relaxed">{comment.content}</p>
            </div>
          </div>
        ))}
        
        {comments.length === 0 && (
          <p className="text-center text-gray-500 py-4">لا توجد تعليقات بعد. كن أول من يعلق!</p>
        )}
      </div>
    </div>
  );
}
