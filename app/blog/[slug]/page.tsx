import { createClient } from '@/lib/supabase/server';
import Navbar from '@/components/Navbar';
import CommentSection from '@/components/CommentSection';
import { notFound } from 'next/navigation';
import { Calendar, User as UserIcon } from 'lucide-react';

export const revalidate = 0;

export default async function BlogPost({ params }: { params: { slug: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();

  // Fetch Post
  const { data: post } = await supabase
    .from('blog_posts')
    .select('*')
    .eq('slug', params.slug)
    .single();

  if (!post) notFound();

  // Fetch Comments
  const { data: comments } = await supabase
    .from('comments')
    .select('*, profiles(display_name)')
    .eq('post_id', post.id)
    .order('created_at', { ascending: false });

  return (
    <div className="min-h-screen bg-white font-sans">
      <Navbar />
      
      <article className="container mx-auto px-4 py-12 max-w-4xl" dir="rtl">
        {/* Header */}
        <header className="mb-10 text-center">
            <span className="inline-block py-1 px-3 rounded-full bg-blue-50 text-blue-600 text-xs font-bold mb-4">
                تعليمي
            </span>
            <h1 className="text-4xl md:text-5xl font-extrabold text-slate-900 mb-6 leading-tight">
                {post.title}
            </h1>
            <div className="flex items-center justify-center gap-6 text-slate-500 text-sm">
                <div className="flex items-center gap-2">
                    <Calendar size={16} />
                    <span>{new Date(post.published_at).toLocaleDateString('ar-EG')}</span>
                </div>
                <div className="flex items-center gap-2">
                    <UserIcon size={16} />
                    <span>فريق المحتوى</span>
                </div>
            </div>
        </header>

        {/* Hero Image */}
        {post.cover_image && (
            <div className="mb-10 rounded-2xl overflow-hidden shadow-lg">
                <img src={post.cover_image} alt={post.title} className="w-full h-auto max-h-[500px] object-cover" />
            </div>
        )}

        {/* Content */}
        <div 
            className="prose prose-lg max-w-none prose-headings:text-slate-900 prose-p:text-slate-700 prose-a:text-blue-600 hover:prose-a:text-blue-700 prose-img:rounded-xl"
            dangerouslySetInnerHTML={{ __html: post.content }} 
        />

        {/* Comments */}
        <CommentSection postId={post.id} comments={comments || []} user={user} />
      </article>
    </div>
  );
}
