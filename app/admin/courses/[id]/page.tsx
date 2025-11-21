import { createClient } from '@/lib/supabase/server';
import { upsertCourse, createModule, createLesson, updateLesson } from '@/app/admin/actions';
import { Button } from '@/components/ui/Button';
import ImageUpload from '@/components/admin/ImageUpload';
import { Plus, Save, Video, FileText, HelpCircle } from 'lucide-react';
import LessonEditor from './LessonEditor'; 

export default async function CourseEditor({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const isNew = params.id === 'new';
  
  let course: any = {};
  if (!isNew) {
      const { data } = await supabase.from('courses').select('*, course_modules(*, lessons(*))').eq('id', params.id).single();
      if (data) {
          course = data;
          // Sort
          course.course_modules.sort((a:any,b:any)=>a.order_index-b.order_index);
          course.course_modules.forEach((m:any) => m.lessons.sort((a:any,b:any)=>a.order_index-b.order_index));
      }
  }

  return (
    <div className="space-y-8 pb-20">
       <div className="flex justify-between items-center">
           <h1 className="text-2xl font-bold">{isNew ? 'Create Course' : `Edit: ${course.title}`}</h1>
           <Button form="course-form" type="submit"><Save size={16} className="mr-2"/> Save Changes</Button>
       </div>

       <div className="grid grid-cols-3 gap-8">
          {/* Main Form */}
          <div className="col-span-2 space-y-6">
              <form id="course-form" action={upsertCourse} className="bg-white p-6 rounded-xl border border-slate-200 space-y-4">
                  <input type="hidden" name="id" value={course.id || ''} />
                  
                  <div>
                      <label className="block text-sm font-medium mb-1">Course Title</label>
                      <input name="title" defaultValue={course.title} required className="w-full p-2 border rounded"/>
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                      <div>
                          <label className="block text-sm font-medium mb-1">Slug</label>
                          <input name="slug" defaultValue={course.slug} required className="w-full p-2 border rounded"/>
                      </div>
                      <div>
                          <label className="block text-sm font-medium mb-1">Price (cents)</label>
                          <input name="price" type="number" defaultValue={course.price || 0} className="w-full p-2 border rounded"/>
                      </div>
                  </div>
                  
                  <ImageUpload name="cover_image" label="Thumbnail" defaultValue={course.cover_image}/>
                  <ImageUpload name="banner_image" label="Banner" defaultValue={course.banner_image}/>

                  <div>
                      <label className="block text-sm font-medium mb-1">Short Description</label>
                      <textarea name="short_description" defaultValue={course.short_description} className="w-full p-2 border rounded h-20"/>
                  </div>
                  <div>
                      <label className="block text-sm font-medium mb-1">Full Content (HTML)</label>
                      <textarea name="full_description" defaultValue={course.full_description} className="w-full p-2 border rounded h-40 font-mono text-xs"/>
                  </div>
                  
                  <div className="flex items-center gap-2">
                      <input type="checkbox" name="is_published" defaultChecked={course.is_published} id="pub"/>
                      <label htmlFor="pub" className="text-sm font-medium">Publish Course</label>
                  </div>
              </form>

              {/* Curriculum Manager (Only if course exists) */}
              {!isNew && (
                  <div className="space-y-4">
                      <h2 className="text-xl font-bold">Curriculum</h2>
                      
                      {course.course_modules?.map((mod: any) => (
                          <div key={mod.id} className="bg-white border border-slate-200 rounded-xl overflow-hidden">
                              <div className="bg-slate-50 p-3 border-b border-slate-200 flex justify-between items-center">
                                  <h3 className="font-bold text-slate-700">{mod.title}</h3>
                                  <form action={createLesson.bind(null, mod.id, course.id, 'New Lesson')}>
                                     <button className="text-xs bg-white border px-2 py-1 rounded hover:bg-blue-50 text-blue-600 flex items-center gap-1"><Plus size={12}/> Add Lesson</button>
                                  </form>
                              </div>
                              <div className="divide-y divide-slate-100">
                                  {mod.lessons?.map((lesson: any) => (
                                      <LessonEditor key={lesson.id} lesson={lesson} />
                                  ))}
                                  {mod.lessons?.length === 0 && <div className="p-4 text-center text-slate-400 text-sm">No lessons yet</div>}
                              </div>
                          </div>
                      ))}

                      {/* Add Module */}
                      <form action={createModule.bind(null, course.id, 'New Module')} className="mt-4">
                          <Button variant="secondary" className="w-full border-dashed border-2 border-slate-300 text-slate-500 hover:border-blue-500 hover:text-blue-600"><Plus size={18} className="mr-2"/> Add Module</Button>
                      </form>
                  </div>
              )}
          </div>
       </div>
    </div>
  );
}
