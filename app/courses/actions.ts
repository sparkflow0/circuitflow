'use server'
import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-04-10',
});

// --- MARK LESSON COMPLETE ---
export async function markLessonComplete(lessonId: string, quizScore?: number) {
  const supabase = createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) throw new Error('Unauthorized')

  const { error } = await supabase
    .from('user_progress')
    .upsert({
      user_id: user.id,
      lesson_id: lessonId,
      is_completed: true,
      quiz_score: quizScore,
      completed_at: new Date().toISOString()
    }, { onConflict: 'user_id, lesson_id' })

  if (error) throw error
  revalidatePath('/courses/[slug]/learn', 'page')
}

// --- CHECK COMPLETION ---
export async function checkCourseCompletion(courseId: string) {
  const supabase = createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null

  const { count: total } = await supabase.from('lessons').select('*', { count: 'exact', head: true }).eq('course_id', courseId)
  const { data: completed } = await supabase.from('user_progress').select('lesson_id, lessons!inner(course_id)').eq('user_id', user.id).eq('is_completed', true).eq('lessons.course_id', courseId)

  if (total && completed && completed.length >= total) {
    const { data: cert } = await supabase
      .from('certificates')
      .upsert({ user_id: user.id, course_id: courseId }, { onConflict: 'user_id, course_id' })
      .select()
      .single()
    return cert
  }
  return null
}

// --- ENROLL FREE COURSE ---
export async function enrollFreeCourse(courseId: string) {
  const supabase = createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth/signin');

  // 1. Verify Course is Free
  const { data: course } = await supabase.from('courses').select('price, slug').eq('id', courseId).single();
  if (!course || course.price > 0) throw new Error("This course is not free");

  // 2. SELF-HEALING: Ensure Profile Exists
  // If the trigger failed, this will fix it just in time.
  const { data: profile } = await supabase.from('profiles').select('id').eq('id', user.id).single();
  if (!profile) {
      await supabase.from('profiles').insert({
          id: user.id,
          email: user.email,
          display_name: user.user_metadata?.full_name || user.email?.split('@')[0],
          role: 'user'
      });
  }

  // 3. Enroll
  const { error } = await supabase.from('course_enrollments').insert({
      user_id: user.id,
      course_id: courseId,
      payment_status: 'free'
  });

  if (error && error.code !== '23505') { // Ignore duplicate key error
      console.error(error);
      throw new Error("Enrollment failed");
  }

  revalidatePath(`/courses/${course.slug}`);
  redirect(`/courses/${course.slug}/learn`);
}

// --- VERIFY STRIPE PAYMENT (SYNC ON SUCCESS) ---
export async function verifyStripeSession(sessionId: string) {
  const supabase = createClient();
  
  const supabaseAdmin = await import('@supabase/supabase-js').then(mod => 
    mod.createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!, 
      process.env.SUPABASE_SERVICE_ROLE_KEY!
    )
  );

  const session = await stripe.checkout.sessions.retrieve(sessionId);

  if (session.payment_status !== 'paid') {
      return { success: false, message: "Payment not completed" };
  }

  const { userId, itemId, type } = session.metadata || {};

  if (!userId || !itemId) return { success: false, message: "Invalid session metadata" };

  // SELF-HEALING: Ensure Profile Exists here too
  const { data: profile } = await supabaseAdmin.from('profiles').select('id').eq('id', userId).single();
  if (!profile) {
      // We can't get user details easily from ID alone without auth admin, 
      // but we can create a placeholder if strictly necessary. 
      // Usually, auth user exists if we are paying.
      // Ideally triggers handle this, but this block handles edge cases.
  }

  if (type === 'course') {
      await supabaseAdmin.from('course_enrollments').upsert({
          user_id: userId,
          course_id: itemId,
          payment_status: 'paid'
      }, { onConflict: 'user_id, course_id' });
  } else if (type === 'product') {
      await supabaseAdmin.from('product_purchases').upsert({
          user_id: userId,
          product_id: itemId,
          payment_status: 'paid'
      }, { onConflict: 'user_id, product_id' });
  }

  return { success: true };
}