'use server'
import { createClient } from '@/lib/supabase/server'
import { createClient as createSupabaseClient } from '@supabase/supabase-js'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

// --- HELPER: Get Admin Client ---
// Checks if current user is admin, then returns a SERVICE ROLE client 
// that has permission to write to the database.
async function getAdminClient() {
  const supabaseUser = createClient()
  const { data: { user } } = await supabaseUser.auth.getUser()
  
  if (!user) redirect('/auth/signin')
  
  const { data: profile } = await supabaseUser
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()
    
  if (profile?.role !== 'admin') redirect('/dashboard')

  // Return Super Admin Client for DB Writes
  return createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  )
}

// --- COURSES ---
export async function upsertCourse(formData: FormData) {
  const supabase = await getAdminClient()
  
  const id = formData.get('id') as string
  const data = {
    title: formData.get('title'),
    slug: formData.get('slug'),
    price: Number(formData.get('price')),
    level: formData.get('level'),
    short_description: formData.get('short_description'),
    full_description: formData.get('full_description'),
    cover_image: formData.get('cover_image'),
    banner_image: formData.get('banner_image'),
    is_published: formData.get('is_published') === 'on'
  }

  let error;
  if (id) {
    const res = await supabase.from('courses').update(data).eq('id', id)
    error = res.error
  } else {
    const res = await supabase.from('courses').insert(data)
    error = res.error
  }

  if (error) {
      console.error("Course Save Error:", error)
      throw new Error("Failed to save course")
  }

  revalidatePath('/admin/courses')
  revalidatePath('/courses') // Update public list
  redirect('/admin/courses')
}

export async function deleteCourse(id: string) {
  const supabase = await getAdminClient()
  await supabase.from('courses').delete().eq('id', id)
  revalidatePath('/admin/courses')
}

// --- MODULES & LESSONS ---
export async function createModule(courseId: string, title: string) {
  const supabase = await getAdminClient()
  await supabase.from('course_modules').insert({ course_id: courseId, title, order_index: 99 })
  revalidatePath(`/admin/courses/${courseId}`)
}

export async function createLesson(moduleId: string, courseId: string, title: string) {
  const supabase = await getAdminClient()
  const slug = title.toLowerCase().replace(/ /g, '-') + '-' + Math.random().toString(36).substr(2,5)
  
  await supabase.from('lessons').insert({ 
    module_id: moduleId, 
    course_id: courseId, 
    title, 
    slug,
    type: 'text',
    order_index: 99 
  })
  revalidatePath(`/admin/courses/${courseId}`)
}

export async function updateLesson(lessonId: string, data: any) {
  const supabase = await getAdminClient()
  await supabase.from('lessons').update(data).eq('id', lessonId)
  revalidatePath('/admin/courses/[id]', 'page') 
}

// --- PRODUCTS ---
export async function upsertProduct(formData: FormData) {
  const supabase = await getAdminClient()
  const id = formData.get('id') as string
  
  const data = {
    title: formData.get('title'),
    slug: formData.get('slug'),
    price: Number(formData.get('price')),
    description: formData.get('description'),
    file_url: formData.get('file_url'),
    variants: JSON.parse(formData.get('variants') as string || '[]'),
    is_published: formData.get('is_published') === 'on'
  }

  if (id) {
    await supabase.from('products').update(data).eq('id', id)
  } else {
    await supabase.from('products').insert(data)
  }
  revalidatePath('/admin/products')
  revalidatePath('/store')
  redirect('/admin/products')
}

export async function deleteProduct(id: string) {
  const supabase = await getAdminClient()
  await supabase.from('products').delete().eq('id', id)
  revalidatePath('/admin/products')
}

// --- BLOG ---
export async function upsertBlogPost(formData: FormData) {
  const supabase = await getAdminClient()
  const id = formData.get('id') as string
  
  const data = {
    title: formData.get('title'),
    slug: formData.get('slug'),
    excerpt: formData.get('excerpt'),
    content: formData.get('content'),
    cover_image: formData.get('cover_image'),
    is_published: formData.get('is_published') === 'on',
    published_at: new Date().toISOString()
  }

  if (id) {
    await supabase.from('blog_posts').update(data).eq('id', id)
  } else {
    await supabase.from('blog_posts').insert(data)
  }
  revalidatePath('/admin/blog')
  revalidatePath('/blog')
  redirect('/admin/blog')
}

export async function deleteBlogPost(id: string) {
  const supabase = await getAdminClient()
  await supabase.from('blog_posts').delete().eq('id', id)
  revalidatePath('/admin/blog')
}
