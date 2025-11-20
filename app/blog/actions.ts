'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

export async function addComment(postId: string, content: string) {
  const supabase = createClient()
  
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    throw new Error('Must be logged in to comment')
  }

  const { error } = await supabase
    .from('comments')
    .insert({
      post_id: postId,
      user_id: user.id,
      content: content
    })

  if (error) {
    console.error('Error adding comment:', error)
    throw new Error('Failed to add comment')
  }

  // Revalidate the blog post page to show the new comment
  revalidatePath(`/blog/[slug]`, 'page')
}
