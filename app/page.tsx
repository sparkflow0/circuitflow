import Navbar from '@/components/Navbar';
import HomeExperience, { BlogPost, Course, Product } from '@/components/HomeExperience';
import { createClient } from '@/lib/supabase/server';

export const revalidate = 0;

export default async function LandingPage() {
  const supabase = createClient();

  const { data: courses } = await supabase
    .from('courses')
    .select('*')
    .eq('is_published', true);

  const { data: posts } = await supabase
    .from('blog_posts')
    .select('*')
    .eq('is_published', true)
    .order('published_at', { ascending: false });

  const { data: products } = await supabase
    .from('products')
    .select('*')
    .eq('is_published', true)
    .order('created_at', { ascending: false });

  return (
    <div className="min-h-screen bg-[#0f0f13] px-4 pb-10">
      <Navbar />
      <HomeExperience
        courses={(courses as Course[] | null) ?? []}
        blogs={(posts as BlogPost[] | null) ?? []}
        products={(products as Product[] | null) ?? []}
      />
    </div>
  );
}
