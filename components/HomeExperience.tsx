'use client';

import React, { useState, FormEvent, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import {
  ArrowLeft,
  ArrowRight,
  BarChart,
  Bell,
  BookMarked,
  BookOpen,
  Calendar,
  CheckCircle2,
  ChevronRight,
  CircuitBoard,
  Clock,
  Cpu,
  FileText,
  GraduationCap,
  Heart,
  LayoutDashboard,
  Layers,
  LogOut,
  Menu,
  MessageSquare,
  Play,
  Plus,
  Search,
  Send,
  Settings,
  Share2,
  ShoppingBag,
  ShoppingCart,
  Star,
  Terminal,
  User as UserIcon,
  Wifi,
  X as XIcon,
  Zap,
} from 'lucide-react';

import { formatCurrency } from '@/lib/utils';

// Types for incoming data
export type Course = {
  id: number;
  slug: string;
  title: string;
  cover_image?: string | null;
  banner_image?: string | null;
  level?: string | null;
  short_description?: string | null;
  description?: string | null;
  full_description?: string | null;
  price?: number | null;
  duration?: number | null;
  duration_minutes?: number | null;
  lessons?: number | null;
  lessons_count?: number | null;
  progress?: number | null;
  syllabus?: string[] | null;
};

export type BlogPost = {
  id: number;
  slug: string;
  title: string;
  author?: string | null;
  cover_image?: string | null;
  content?: string | null;
  excerpt?: string | null;
  published_at?: string | null;
  read_time?: string | null;
  category?: string | null;
};

export type Product = {
  id: number;
  slug: string;
  title: string;
  description?: string | null;
  cover_image?: string | null;
  file_url?: string | null;
  category?: string | null;
  price?: number | null;
  specs?: string[] | null;
  variants?: { name: string; price_mod?: number | null }[] | null;
};

const formatFeedCurrency = (amount?: number | null) => formatCurrency(amount ?? 0);

const Card = ({
  title,
  subtitle,
  meta,
  imageColor,
  imageUrl,
  icon: Icon,
  onClick,
}: {
  title: string;
  subtitle?: string;
  meta: React.ReactNode;
  imageColor?: string;
  imageUrl?: string | null;
  icon?: React.ComponentType<{ size?: number | string }>;
  onClick?: () => void;
}) => (
  <div
    onClick={onClick}
    className="bg-[#1e1e24] rounded-xl overflow-hidden hover:transform hover:-translate-y-1 hover:shadow-xl hover:shadow-blue-900/10 transition-all duration-300 border border-gray-800 cursor-pointer group flex flex-col h-full"
  >
    <div className={`h-32 relative ${imageUrl ? '' : imageColor ?? 'bg-gray-800'} overflow-hidden`}>
      {imageUrl ? (
        <img src={imageUrl} alt={title} className="w-full h-full object-cover" />
      ) : null}
      {Icon && (
        <div className="absolute p-2 rounded-lg text-white backdrop-blur-sm right-4 top-4 bg-black/30">
          <Icon size={20} />
        </div>
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-[#1e1e24] to-transparent opacity-60" />
    </div>
    <div className="p-4 flex-1 flex flex-col">
      <h3 className="font-bold text-gray-100 mb-1 group-hover:text-blue-400 transition-colors line-clamp-2">{title}</h3>
      {subtitle && <p className="text-xs text-gray-400 mb-3 line-clamp-1">{subtitle}</p>}
      <div className="mt-auto flex items-center justify-between text-xs text-gray-500 font-medium">{meta}</div>
    </div>
  </div>
);

const SectionHeader = ({ title, action, onAction }: { title: string; action?: string; onAction?: () => void }) => (
  <div className="flex justify-between items-center mb-6">
    <h2 className="text-xl font-bold text-white">{title}</h2>
    {action && (
      <button
        onClick={onAction}
        className="text-sm text-blue-400 hover:text-blue-300 flex items-center gap-1 transition-colors"
      >
        {action} <ChevronRight size={14} />
      </button>
    )}
  </div>
);

const SidebarItem = ({ icon: Icon, label, active, onClick }: any) => (
  <div
    onClick={onClick}
    className={`flex items-center gap-3 px-4 py-3 rounded-lg cursor-pointer transition-all duration-200 group
      ${active ? 'bg-blue-600 text-white shadow-lg shadow-blue-900/20' : 'text-gray-400 hover:bg-gray-800 hover:text-white'}
    `}
  >
    <Icon size={20} className={`${active ? 'text-white' : 'text-gray-400 group-hover:text-white'}`} />
    <span className="font-medium text-sm">{label}</span>
  </div>
);

const CommentSection = ({ postId }: { postId: number }) => {
  const [comments, setComments] = useState([
    { id: 101, user: 'Sarah Tech', content: 'This was super helpful, thanks!', date: 'قبل ساعات' },
    { id: 102, user: 'Mike Circuits', content: 'I always forget about decoupling capacitors. Good reminder.', date: 'قبل 5 ساعات' },
  ]);
  const [newComment, setNewComment] = useState('');

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (!newComment.trim()) return;

    const comment = {
      id: Date.now(),
      user: 'John Smith',
      content: newComment,
      date: 'الآن',
    };

    setComments([comment, ...comments]);
    setNewComment('');
  };

  return (
    <div className="mt-12 border-t border-gray-800 pt-8">
      <h3 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
        <MessageSquare size={20} className="text-blue-500" />
        المناقشة ({comments.length})
      </h3>

      <form onSubmit={handleSubmit} className="mb-8 relative">
        <div className="relative">
          <input
            type="text"
            value={newComment}
            onChange={(e) => setNewComment(e.target.value)}
            placeholder="أضف تعليقك..."
            className="w-full bg-[#25252b] border border-gray-700 rounded-xl py-3.5 pl-4 pr-12 text-gray-200 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all placeholder:text-gray-500"
          />
          <button
            type="submit"
            disabled={!newComment.trim()}
            className="absolute right-2 top-2 p-1.5 bg-blue-600 text-white rounded-lg hover:bg-blue-500 disabled:opacity-50 disabled:hover:bg-blue-600 transition-colors"
          >
            <Send size={16} />
          </button>
        </div>
      </form>

      <div className="space-y-4">
        {comments.map((comment) => (
          <div key={comment.id} className="bg-[#1e1e24] p-4 rounded-xl border border-gray-800">
            <div className="flex justify-between items-start mb-2">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-emerald-500 to-teal-500 flex items-center justify-center text-xs font-bold text-white">
                  {comment.user[0]}
                </div>
                <div>
                  <div className="text-sm font-bold text-white">{comment.user}</div>
                  <div className="text-[10px] text-gray-500">{comment.date}</div>
                </div>
              </div>
            </div>
            <p className="text-gray-300 text-sm ml-10">{comment.content}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

const CommunityCircuits = [
  { id: 1, title: 'Smart Home Temp Sensor', author: 'AlexDev', likes: 124 },
  { id: 2, title: 'Traffic Light System', author: 'CircuitMaster', likes: 89 },
  { id: 3, title: 'Robot Arm Controller', author: 'RoboFan', likes: 256 },
  { id: 4, title: 'Binary Counter', author: 'LogicWhiz', likes: 45 },
];

const UserProjects = [
  { id: 1, name: 'My First Circuit', edited: 'منذ ساعتين' },
  { id: 2, name: 'Automatic Plant Waterer', edited: 'منذ يوم' },
  { id: 3, name: 'LED Matrix Display', edited: 'منذ 3 أيام' },
];

type ExperienceProps = {
  courses: Course[];
  blogs: BlogPost[];
  products: Product[];
};

export default function HomeExperience({ courses, blogs, products }: ExperienceProps) {
  const router = useRouter();

  const [activeTab, setActiveTab] = useState<'dashboard' | 'learn' | 'community' | 'shop'>('dashboard');
  const [selectedCourseId, setSelectedCourseId] = useState<number | null>(null);
  const [selectedBlogId, setSelectedBlogId] = useState<number | null>(null);
  const [selectedProductId, setSelectedProductId] = useState<number | null>(null);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const normalizedCourses = useMemo(
    () =>
      courses.map((course) => ({
        ...course,
        level: course.level ?? 'Beginner',
        duration: course.duration ?? (course.duration_minutes ? Math.ceil(course.duration_minutes / 60) : 2),
        lessons: course.lessons ?? course.lessons_count ?? 8,
        progress: course.progress ?? 0,
        cover_image: course.cover_image ?? undefined,
        short_description: course.short_description ?? course.description ?? course.full_description ?? '',
        description: course.full_description ?? course.description ?? course.short_description ?? '',
        syllabus: Array.isArray(course.syllabus) ? course.syllabus : [],
        price: course.price ?? 0,
      })),
    [courses],
  );

  const normalizedBlogs = useMemo(
    () =>
      blogs.map((blog) => ({
        ...blog,
        author: blog.author ?? 'فريق CircuitFlow',
        category: blog.category ?? 'تعليمي',
        cover_image: blog.cover_image ?? undefined,
        content: blog.content ?? blog.excerpt ?? '',
        read_time:
          blog.read_time ??
          `${Math.max(1, Math.round((blog.content ?? blog.excerpt ?? '').split(/\s+/).length / 200))} دقائق`,
      })),
    [blogs],
  );

  const normalizedProducts = useMemo(
    () =>
      products.map((product) => ({
        ...product,
        title: product.title,
        description: product.description ?? '',
        cover_image: product.cover_image ?? product.file_url ?? undefined,
        category: product.category ?? 'منتج رقمي',
        price: product.price ?? 0,
        specs: Array.isArray(product.specs)
          ? product.specs
          : Array.isArray(product.variants)
            ? product.variants.map((variant) => variant.name)
            : [],
      })),
    [products],
  );

  const resetViews = () => {
    setSelectedCourseId(null);
    setSelectedBlogId(null);
    setSelectedProductId(null);
  };

  const handleTabChange = (tab: typeof activeTab) => {
    setActiveTab(tab);
    resetViews();
  };

  const handleCourseClick = (id: number) => {
    setSelectedCourseId(id);
    setSelectedBlogId(null);
    setActiveTab('learn');
  };

  const handleBlogClick = (id: number) => {
    setSelectedBlogId(id);
    setSelectedCourseId(null);
    setActiveTab('learn');
  };

  const handleProductClick = (id: number) => {
    setSelectedProductId(id);
    setActiveTab('shop');
  };

  const CourseDetail = ({ id }: { id: number }) => {
    const course = normalizedCourses.find((c) => c.id === id);
    if (!course) return null;

    return (
      <div className="animate-in fade-in slide-in-from-right-4 duration-300 space-y-6 pb-10">
        <button onClick={resetViews} className="flex items-center gap-2 text-gray-400 hover:text-white mb-4">
          <ArrowLeft size={16} /> العودة للدورات
        </button>

        <div className="relative rounded-2xl overflow-hidden">
          <div className="h-64 bg-gray-800 w-full overflow-hidden">
            {course.cover_image ? (
              <img src={course.cover_image} className="w-full h-full object-cover opacity-60" />
            ) : (
              <div className="w-full h-full bg-gradient-to-r from-blue-900 to-indigo-900" />
            )}
            <div className="absolute inset-0 bg-gradient-to-t from-[#131316] to-transparent" />
          </div>
          <div className="absolute bottom-0 left-0 p-8 w-full">
            <div className="flex items-center gap-3 mb-4">
              <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-xs font-bold">{course.level}</span>
              <span className="flex items-center gap-1 text-white/80 text-xs">
                <Clock size={12} /> {course.duration} ساعات
              </span>
            </div>
            <h1 className="text-4xl font-bold text-white mb-4">{course.title}</h1>
            <p className="text-gray-200 max-w-2xl text-lg">{course.description}</p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-2 space-y-6">
            <div className="bg-[#1e1e24] rounded-xl p-6 border border-gray-800">
              <div className="flex justify-between items-center mb-6">
                <h3 className="text-xl font-bold text-white">الخطة الدراسية</h3>
                <span className="text-sm text-gray-400">{course.lessons} دروس</span>
              </div>
              <div className="space-y-3">
                {(course.syllabus && course.syllabus.length > 0 ? course.syllabus : ['المقدمة']).map((item, idx) => (
                  <div
                    key={idx}
                    className="flex items-start gap-4 p-4 rounded-lg bg-[#25252b] hover:bg-[#2a2a32] transition-colors cursor-pointer group"
                  >
                    <div className="w-8 h-8 rounded-full bg-gray-800 text-gray-400 flex items-center justify-center text-sm font-bold group-hover:bg-blue-600 group-hover:text-white transition-colors">
                      {idx + 1}
                    </div>
                    <div className="flex-1">
                      <h4 className="text-gray-200 font-medium group-hover:text-white">{item}</h4>
                      <p className="text-xs text-gray-500 mt-1">15 دقيقة • فيديو واختبار</p>
                    </div>
                    {idx === 0 ? <CheckCircle2 size={20} className="text-green-500" /> : <div className="w-5 h-5 rounded-full border-2 border-gray-700" />}
                  </div>
                ))}
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <div className="bg-[#1e1e24] rounded-xl p-6 border border-gray-800 sticky top-4">
              <div className="text-3xl font-bold text-white mb-2">
                {course.price === 0 ? 'مجاني' : formatFeedCurrency(course.price)}
              </div>
              <p className="text-sm text-gray-400 mb-6">وصول مدى الحياة</p>
              <button className="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-lg transition-colors flex items-center justify-center gap-2 mb-4">
                <Play size={18} fill="currentColor" /> ابدأ التعلم الآن
              </button>
              <div className="text-xs text-gray-500 text-center">ضمان استرجاع لمدة 30 يومًا</div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  const BlogDetail = ({ id }: { id: number }) => {
    const blog = normalizedBlogs.find((b) => b.id === id);
    if (!blog) return null;

    return (
      <div className="animate-in fade-in slide-in-from-bottom-4 duration-300 max-w-4xl mx-auto pb-10">
        <button onClick={resetViews} className="flex items-center gap-2 text-gray-400 hover:text-white mb-8 transition-colors">
          <ArrowLeft size={16} /> العودة للمقالات
        </button>

        <article className="bg-[#1e1e24] rounded-2xl border border-gray-800 p-8 md:p-12">
          <header className="mb-10 text-center">
            <span className="inline-block py-1 px-3 rounded-full bg-blue-500/10 text-blue-400 text-xs font-bold mb-4 border border-blue-500/20">
              {blog.category}
            </span>
            <h1 className="text-3xl md:text-5xl font-extrabold text-white mb-6 leading-tight">{blog.title}</h1>
            <div className="flex items-center justify-center gap-6 text-gray-400 text-sm">
              <div className="flex items-center gap-2">
                <Calendar size={16} />
                <span>{blog.published_at ? new Date(blog.published_at).toLocaleDateString('ar-EG') : 'غير محدد'}</span>
              </div>
              <div className="flex items-center gap-2">
                <UserIcon size={16} />
                <span>{blog.author}</span>
              </div>
              <div className="flex items-center gap-2">
                <Clock size={16} />
                <span>{blog.read_time}</span>
              </div>
            </div>
          </header>

          <div className="mb-10 rounded-2xl overflow-hidden shadow-2xl aspect-video bg-gray-800 relative">
            {blog.cover_image ? (
              <img src={blog.cover_image} alt={blog.title} className="w-full h-full object-cover" />
            ) : (
              <div className="absolute inset-0 flex items-center justify-center text-white/20">
                <FileText size={64} />
              </div>
            )}
            <div className="absolute inset-0 bg-black/30" />
          </div>

          <div
            className="prose prose-lg prose-invert max-w-none prose-headings:text-white prose-p:text-gray-300 prose-a:text-blue-400 hover:prose-a:text-blue-300 prose-strong:text-white prose-li:text-gray-300"
            dangerouslySetInnerHTML={{ __html: blog.content ?? '' }}
          />

          <CommentSection postId={blog.id} />
        </article>
      </div>
    );
  };

  const ProductDetail = ({ id }: { id: number }) => {
    const product = normalizedProducts.find((p) => p.id === id);
    if (!product) return null;

    return (
      <div className="animate-in fade-in zoom-in-95 duration-300 pb-10">
        <button onClick={resetViews} className="flex items-center gap-2 text-gray-400 hover:text-white mb-6">
          <ArrowLeft size={16} /> العودة للمتجر
        </button>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
          <div className="aspect-square rounded-2xl bg-gradient-to-br from-emerald-900 to-teal-900 flex items-center justify-center p-8 relative overflow-hidden group">
            {product.cover_image ? (
              <img src={product.cover_image} alt={product.title} className="w-full h-full object-cover" />
            ) : (
              <CircuitBoard size={200} className="text-white/20 group-hover:scale-110 transition-transform duration-500" />
            )}
            <div className="absolute bottom-4 right-4">
              <button className="p-3 bg-white/10 backdrop-blur rounded-full hover:bg-white/20 text-white">
                <Share2 size={20} />
              </button>
            </div>
          </div>

          <div className="flex flex-col justify-center space-y-6">
            <div>
              <div className="text-emerald-400 font-bold text-sm mb-2 uppercase tracking-wider">{product.category}</div>
              <h1 className="text-4xl font-bold text-white mb-2">{product.title}</h1>
              <div className="flex items-center gap-4">
                <span className="text-3xl font-bold text-white">{formatFeedCurrency(product.price)}</span>
                <div className="flex text-yellow-500 text-sm">
                  <Star fill="currentColor" size={16} />
                  <Star fill="currentColor" size={16} />
                  <Star fill="currentColor" size={16} />
                  <Star fill="currentColor" size={16} />
                  <Star fill="currentColor" size={16} />
                  <span className="text-gray-500 ml-2">(124 مراجعة)</span>
                </div>
              </div>
            </div>

            <p className="text-gray-300 text-lg leading-relaxed">{product.description}</p>

            <div className="space-y-4 pt-4 border-t border-gray-800">
              <h3 className="text-sm font-bold text-gray-400 uppercase">المواصفات</h3>
              <div className="grid grid-cols-2 gap-4">
                {(product.specs && product.specs.length > 0 ? product.specs : ['ملف رقمي جاهز']).map((spec, i) => (
                  <div key={i} className="flex items-center gap-2 text-sm text-gray-300">
                    <div className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                    {spec}
                  </div>
                ))}
              </div>
            </div>

            <div className="flex gap-4 pt-6">
              <button className="flex-1 bg-emerald-600 hover:bg-emerald-500 text-white py-4 rounded-xl font-bold text-lg transition-all shadow-lg shadow-emerald-900/20 flex items-center justify-center gap-3">
                <ShoppingCart size={20} /> أضف للسلة
              </button>
              <button className="px-6 py-4 rounded-xl border border-gray-700 hover:bg-gray-800 text-white transition-colors">
                <Heart size={20} />
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  };

  const DashboardView = () => (
    <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2 bg-gradient-to-br from-blue-600 to-purple-700 rounded-2xl p-8 text-white relative overflow-hidden shadow-2xl">
          <div className="relative z-10">
            <h2 className="text-3xl font-bold mb-2">مرحباً بعودتك!</h2>
            <p className="text-blue-100 mb-6 max-w-md">ابدأ مشروعك التالي أو عد إلى الدروس التي تتابعها.</p>
            <div className="flex flex-wrap gap-3">
              <button
                onClick={() => router.push('/simulator')}
                className="bg-white text-blue-600 px-6 py-2.5 rounded-lg font-bold hover:bg-blue-50 transition-colors flex items-center gap-2 shadow-lg"
              >
                <Zap size={18} /> افتح المحاكي
              </button>
              <button className="bg-blue-800/50 text-white border border-blue-400/30 px-6 py-2.5 rounded-lg font-bold hover:bg-blue-800 transition-colors backdrop-blur-sm">
                مشروع جديد
              </button>
            </div>
          </div>
          <div className="absolute -right-10 -bottom-10 opacity-20 rotate-12">
            <Cpu size={200} />
          </div>
        </div>

        <div className="bg-[#1e1e24] rounded-2xl p-6 border border-gray-800 flex flex-col">
          <div className="flex justify-between items-center mb-4">
            <h3 className="font-bold text-white flex items-center gap-2">
              <LayoutDashboard size={18} className="text-blue-500" /> مشاريعك
            </h3>
            <button className="text-xs text-gray-400 hover:text-white">عرض الكل</button>
          </div>
          <div className="flex-1 space-y-3 overflow-y-auto custom-scrollbar max-h-48 md:max-h-none">
            {UserProjects.map((p) => (
              <div
                key={p.id}
                className="group flex items-center justify-between p-3 rounded-lg bg-[#25252b] hover:bg-[#2a2a32] cursor-pointer border border-transparent hover:border-gray-700 transition-all"
              >
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded bg-blue-900/50 text-blue-400 flex items-center justify-center shrink-0">
                    <CircuitBoard size={16} />
                  </div>
                  <div className="min-w-0">
                    <div className="text-sm font-medium text-gray-200 group-hover:text-white truncate">{p.name}</div>
                    <div className="text-[10px] text-gray-500">تم التعديل {p.edited}</div>
                  </div>
                </div>
                <button className="text-gray-600 hover:text-blue-400 opacity-0 group-hover:opacity-100 transition-opacity">
                  <Play size={14} />
                </button>
              </div>
            ))}
            <button className="w-full py-3 border border-dashed border-gray-700 rounded-lg text-gray-500 text-sm hover:border-gray-500 hover:text-gray-300 transition-all flex items-center justify-center gap-2">
              <Plus size={16} /> أنشئ مشروع جديد
            </button>
          </div>
        </div>
      </div>

      <div>
        <SectionHeader title="واصل التعلم" action="اذهب للتعلم" onAction={() => setActiveTab('learn')} />
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          {normalizedCourses
            .filter((c) => (c.progress ?? 0) > 0)
            .slice(0, 2)
            .map((course) => (
              <Card
                key={course.id}
                title={course.title}
                subtitle={`${course.level} • ${course.duration} ساعة`}
                onClick={() => handleCourseClick(course.id)}
                meta={
                  <div className="w-full">
                    <div className="flex justify-between text-[10px] mb-1">
                      <span>التقدم</span>
                      <span>{course.progress}%</span>
                    </div>
                    <div className="h-1 bg-gray-700 rounded-full overflow-hidden">
                      <div className="h-full bg-yellow-500" style={{ width: `${course.progress}%` }} />
                    </div>
                  </div>
                }
                imageUrl={course.cover_image}
                icon={BookOpen}
              />
            ))}
          {normalizedBlogs.slice(0, 2).map((blog) => (
            <Card
              key={blog.id}
              title={blog.title}
              subtitle={`بواسطة ${blog.author}`}
              onClick={() => handleBlogClick(blog.id)}
              meta={
                <span className="flex items-center gap-1 text-gray-400">
                  <Clock size={12} /> {blog.read_time}
                </span>
              }
              imageUrl={blog.cover_image}
              icon={FileText}
            />
          ))}
        </div>
      </div>
    </div>
  );

  const LearnView = () => {
    const [filter, setFilter] = useState<'all' | 'courses' | 'tutorials'>('all');

    if (selectedCourseId) return <CourseDetail id={selectedCourseId} />;
    if (selectedBlogId) return <BlogDetail id={selectedBlogId} />;

    return (
      <div className="space-y-10 animate-in fade-in zoom-in-95 duration-300">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h2 className="text-3xl font-bold text-white mb-1">مركز التعلم</h2>
            <p className="text-gray-400">تعلم الإلكترونيات والبرمجة بدورات احترافية.</p>
          </div>
          <div className="flex gap-2 overflow-x-auto pb-2 md:pb-0">
            <button
              onClick={() => setFilter('all')}
              className={`px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap transition-colors ${
                filter === 'all' ? 'bg-blue-600 text-white' : 'bg-[#1e1e24] text-gray-400 hover:text-white border border-gray-700'
              }`}
            >
              الكل
            </button>
            <button
              onClick={() => setFilter('courses')}
              className={`px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap transition-colors ${
                filter === 'courses'
                  ? 'bg-blue-600 text-white'
                  : 'bg-[#1e1e24] text-gray-400 hover:text-white border border-gray-700'
              }`}
            >
              الدورات
            </button>
            <button
              onClick={() => setFilter('tutorials')}
              className={`px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap transition-colors ${
                filter === 'tutorials'
                  ? 'bg-blue-600 text-white'
                  : 'bg-[#1e1e24] text-gray-400 hover:text-white border border-gray-700'
              }`}
            >
              المقالات
            </button>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div
            onClick={() => normalizedCourses[0] && handleCourseClick(normalizedCourses[0].id)}
            className="lg:col-span-2 bg-[#1e1e24] rounded-2xl overflow-hidden border border-gray-800 relative group cursor-pointer min-h-[300px]"
          >
            <div className="absolute inset-0 bg-gradient-to-r from-blue-900/90 to-purple-900/90 z-10" />
            <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&q=80')] bg-cover bg-center opacity-50 mix-blend-overlay transition-transform duration-700 group-hover:scale-105" />
            <div className="relative z-20 p-8 h-full flex flex-col justify-end">
              <span className="bg-blue-500 text-white text-xs font-bold px-2 py-1 rounded w-fit mb-3">مسار مميز</span>
              <h3 className="text-3xl font-bold text-white mb-2">
                {normalizedCourses[0]?.title ?? 'ابدأ رحلتك مع الأردوينو'}
              </h3>
              <p className="text-gray-300 mb-6 max-w-xl">
                {normalizedCourses[0]?.short_description ?? 'تعلم الأساسيات خطوة بخطوة مع مشاريع عملية.'}
              </p>
              <button className="bg-white text-gray-900 px-6 py-2.5 rounded-lg font-bold hover:bg-blue-50 transition-colors w-fit flex items-center gap-2">
                ابدأ التعلم <ArrowRight size={16} />
              </button>
            </div>
          </div>

          <div className="bg-[#1e1e24] rounded-2xl p-6 border border-gray-800 flex flex-col">
            <h3 className="font-bold text-white mb-4 flex items-center gap-2">
              <BookMarked size={18} className="text-green-500" /> الدورات الحالية
            </h3>
            <div className="space-y-4 flex-1 overflow-y-auto max-h-[200px] custom-scrollbar">
              {normalizedCourses.filter((c) => (c.progress ?? 0) > 0).length > 0 ? (
                normalizedCourses
                  .filter((c) => (c.progress ?? 0) > 0)
                  .map((course) => (
                    <div
                      key={course.id}
                      onClick={() => handleCourseClick(course.id)}
                      className="bg-[#25252b] p-3 rounded-lg hover:bg-[#2a2a32] cursor-pointer transition-colors"
                    >
                      <div className="flex justify-between text-xs text-gray-400 mb-1">
                        <span className="font-medium text-gray-300 truncate max-w-[120px]">{course.title}</span>
                        <span>{course.progress}%</span>
                      </div>
                      <div className="h-1.5 bg-gray-700 rounded-full overflow-hidden">
                        <div className="h-full bg-green-500 rounded-full" style={{ width: `${course.progress}%` }} />
                      </div>
                    </div>
                  ))
              ) : (
                <p className="text-sm text-gray-500">لا توجد دورات نشطة حالياً.</p>
              )}
            </div>
            <button className="w-full mt-6 text-sm text-blue-400 hover:text-blue-300 text-center p-2 rounded hover:bg-blue-500/10 transition-colors">
              عرض السجل الكامل
            </button>
          </div>
        </div>

        {(filter === 'all' || filter === 'courses') && (
          <div>
            <SectionHeader title="كل الدورات" />
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {normalizedCourses.map((course) => (
                <div
                  key={course.id}
                  onClick={() => handleCourseClick(course.id)}
                  className="group block bg-[#1e1e24] rounded-2xl border border-gray-800 overflow-hidden hover:shadow-xl hover:shadow-blue-900/20 transition-all hover:-translate-y-1 cursor-pointer"
                >
                  <div className="h-48 bg-gray-800 relative overflow-hidden">
                    {course.cover_image ? (
                      <img
                        src={course.cover_image}
                        alt={course.title}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                      />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-gray-600">لا توجد صورة</div>
                    )}
                    <div className="absolute top-3 right-3 bg-[#131316]/90 backdrop-blur px-3 py-1 rounded-full text-xs font-bold text-blue-400 border border-blue-500/20">
                      {course.level}
                    </div>
                  </div>

                  <div className="p-6">
                    <h3 className="font-bold text-xl mb-3 text-white group-hover:text-blue-400 transition-colors">{course.title}</h3>
                    <p className="text-gray-400 text-sm mb-6 line-clamp-2 leading-relaxed">{course.short_description}</p>

                    <div className="flex justify-between items-center border-t border-gray-800 pt-4">
                      <div className="flex items-center gap-4 text-gray-500 text-xs">
                        <span className="flex items-center gap-1">
                          <BookOpen size={14} /> {course.lessons} دروس
                        </span>
                        <span className="flex items-center gap-1">
                          <Clock size={14} /> {course.duration} ساعة
                        </span>
                      </div>
                      <span className={`font-bold text-lg ${course.price === 0 ? 'text-green-500' : 'text-blue-500'}`}>
                        {course.price === 0 ? 'مجاني' : formatFeedCurrency(course.price)}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {(filter === 'all' || filter === 'tutorials') && (
          <div>
            <SectionHeader title="آخر المقالات" />
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
              {normalizedBlogs.map((blog) => (
                <Card
                  key={blog.id}
                  title={blog.title}
                  subtitle={`بواسطة ${blog.author}`}
                  onClick={() => handleBlogClick(blog.id)}
                  meta={
                    <span className="text-gray-400 flex items-center gap-1">
                      <Clock size={12} /> {blog.read_time}
                    </span>
                  }
                  imageUrl={blog.cover_image}
                  icon={FileText}
                />
              ))}
            </div>
          </div>
        )}
      </div>
    );
  };

  const CommunityView = () => (
    <div className="space-y-8 animate-in fade-in zoom-in-95 duration-300">
      <div className="text-center max-w-2xl mx-auto mb-12 pt-8">
        <h2 className="text-4xl font-bold text-white mb-4">دوائر المجتمع</h2>
        <p className="text-gray-400 text-lg">استكشف دوائر أنشأها مجتمع CircuitFlow وقم بتجربتها.</p>
        <div className="mt-8 relative max-w-lg mx-auto">
          <input
            type="text"
            placeholder="ابحث عن دائرة (مثال: مؤقت، راديو، آلة حاسبة)"
            className="w-full bg-[#1e1e24] border border-gray-700 rounded-full py-3.5 pl-12 pr-4 text-gray-200 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
          />
          <Search className="absolute left-4 top-3.5 text-gray-500" size={20} />
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {CommunityCircuits.map((c) => (
          <div
            key={c.id}
            className="bg-[#1e1e24] rounded-xl overflow-hidden border border-gray-800 hover:border-gray-600 transition-all cursor-pointer hover:-translate-y-1 shadow-lg"
          >
            <div className="h-40 bg-gray-800 flex items-center justify-center relative">
              <div className="absolute inset-0 bg-black/20" />
              <CircuitBoard size={48} className="text-white/50 relative z-10" />
            </div>
            <div className="p-4">
              <h3 className="font-bold text-white text-lg mb-1">{c.title}</h3>
              <div className="flex justify-between items-center mt-4 pt-4 border-t border-gray-800">
                <div className="flex items-center gap-2 text-sm text-gray-400">
                  <div className="w-6 h-6 rounded-full bg-gradient-to-br from-blue-500 to-purple-500 flex items-center justify-center text-[10px] text-white font-bold">
                    {c.author[0]}
                  </div>
                  {c.author}
                </div>
                <div className="flex items-center gap-1 text-xs text-gray-500 hover:text-red-400 transition-colors">
                  <Heart size={14} /> {c.likes}
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const ShopView = () => {
    if (selectedProductId) return <ProductDetail id={selectedProductId} />;

    return (
      <div className="space-y-8 animate-in fade-in zoom-in-95 duration-300">
        <div className="bg-gradient-to-r from-emerald-900 to-teal-900 rounded-2xl p-8 text-white flex flex-col md:flex-row justify-between items-center gap-8 shadow-xl relative overflow-hidden">
          <div className="relative z-10">
            <h2 className="text-3xl font-bold mb-2">المتجر الرسمي</h2>
            <p className="text-emerald-100 mb-6 max-w-lg">ملفات ومشاريع جاهزة لتسريع عملك.</p>
            <button className="bg-white text-emerald-900 px-8 py-3 rounded-lg font-bold hover:bg-emerald-50 transition-colors shadow-lg">
              عروض خاصة
            </button>
          </div>
          <ShoppingBag
            size={140}
            className="text-emerald-500/20 absolute right-0 bottom-0 rotate-[-15deg] transform translate-x-10 translate-y-10 md:translate-x-0 md:translate-y-0 md:relative"
          />
        </div>

        <div>
          <div className="flex justify-between items-center mb-6">
            <h3 className="text-xl font-bold text-white">منتجات مميزة</h3>
            <div className="flex gap-2">
              <button className="text-xs bg-[#1e1e24] text-white px-3 py-1 rounded-full border border-gray-700">الكل</button>
              <button className="text-xs text-gray-400 px-3 py-1 rounded-full hover:bg-[#1e1e24]">كيت</button>
              <button className="text-xs text-gray-400 px-3 py-1 rounded-full hover:bg-[#1e1e24]">لوحات</button>
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {normalizedProducts.map((p) => (
              <div
                key={p.id}
                onClick={() => handleProductClick(p.id)}
                className="bg-[#1e1e24] rounded-xl overflow-hidden border border-gray-800 hover:border-emerald-500/50 transition-all group cursor-pointer hover:shadow-lg hover:shadow-emerald-900/10"
              >
                <div className={`h-48 relative p-4 flex items-center justify-center bg-gray-900`}>
                  {p.cover_image ? (
                    <img src={p.cover_image} alt={p.title} className="w-full h-full object-cover" />
                  ) : (
                    <CircuitBoard size={48} className="text-emerald-400" />
                  )}
                  <div className="absolute top-3 right-3 bg-black/60 backdrop-blur px-2.5 py-1 rounded-md text-xs font-bold text-white shadow-sm">
                    {formatFeedCurrency(p.price)}
                  </div>
                  <div className="absolute top-3 left-3 bg-black/30 px-2 py-1 rounded text-[10px] font-medium text-white/80">
                    {p.category}
                  </div>
                </div>
                <div className="p-5">
                  <h3 className="font-bold text-white mb-4 group-hover:text-emerald-400 transition-colors text-lg">{p.title}</h3>
                  <button className="w-full py-2.5 bg-gray-800 hover:bg-emerald-600 text-gray-300 hover:text-white rounded-lg text-sm font-bold transition-all flex items-center justify-center gap-2">
                    <ShoppingCart size={16} /> أضف للسلة
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  };

  return (
    <div className="flex h-[calc(100vh-64px)] w-full bg-[#131316] font-sans text-gray-300 overflow-hidden selection:bg-blue-500/30 rounded-3xl shadow-2xl border border-gray-800 mt-6">
      <div
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-[#18181d] border-r border-gray-800 transform transition-transform duration-300 md:relative md:translate-x-0 ${
          mobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="h-full flex flex-col">
          <div className="h-16 flex items-center gap-3 px-6 border-b border-gray-800">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-1.5 rounded-lg shadow-lg shadow-blue-900/20">
              <Zap size={20} className="text-white" fill="currentColor" />
            </div>
            <span className="text-xl font-bold text-white tracking-tight">CircuitFlow</span>
            <button className="md:hidden ml-auto text-gray-400 hover:text-white" onClick={() => setMobileMenuOpen(false)}>
              <XIcon size={20} />
            </button>
          </div>

          <div className="flex-1 py-6 px-3 space-y-1 custom-scrollbar overflow-y-auto">
            <SidebarItem icon={LayoutDashboard} label="لوحة التحكم" active={activeTab === 'dashboard'} onClick={() => handleTabChange('dashboard')} />
            <SidebarItem icon={BookOpen} label="التعلم" active={activeTab === 'learn'} onClick={() => handleTabChange('learn')} />
            <div className="my-3 px-3">
              <button className="flex items-center gap-3 px-4 py-3 rounded-lg bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/20 hover:shadow-blue-900/40 transition-all group w-full">
                <Cpu size={20} className="animate-pulse" />
                <span className="font-bold text-sm">فتح المحاكي</span>
              </button>
            </div>
            <SidebarItem icon={Layers} label="المجتمع" active={activeTab === 'community'} onClick={() => handleTabChange('community')} />
            <SidebarItem icon={ShoppingBag} label="المتجر" active={activeTab === 'shop'} onClick={() => handleTabChange('shop')} />
          </div>

          <div className="p-4 border-t border-gray-800 space-y-2">
            <SidebarItem icon={Settings} label="الإعدادات" />
            {isLoggedIn ? (
              <div className="flex items-center gap-3 px-4 py-3 mt-2 bg-[#25252b] rounded-lg border border-gray-800 cursor-pointer hover:border-gray-700 transition-colors">
                <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-500 to-purple-500 flex items-center justify-center text-white font-bold text-xs shadow-inner">
                  JS
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-bold text-white truncate">John Smith</div>
                  <div className="text-xs text-gray-500 truncate">Pro Member</div>
                </div>
                <button onClick={(e) => { e.stopPropagation(); setIsLoggedIn(false); }} className="text-gray-500 hover:text-red-400 transition-colors">
                  <LogOut size={16} />
                </button>
              </div>
            ) : (
              <button
                onClick={() => setIsLoggedIn(true)}
                className="w-full bg-[#25252b] hover:bg-[#2a2a32] text-white py-2.5 rounded-lg font-medium text-sm transition-colors border border-gray-700 hover:border-gray-600"
              >
                تسجيل الدخول
              </button>
            )}
          </div>
        </div>
      </div>

      <div className="flex-1 flex flex-col min-w-0 h-full overflow-hidden">
        <div className="h-16 border-b border-gray-800 bg-[#131316]/90 backdrop-blur-md flex items-center justify-between px-6 sticky top-0 z-40">
          <div className="flex items-center gap-4 flex-1 max-w-2xl">
            <button className="md:hidden text-gray-400 hover:text-white" onClick={() => setMobileMenuOpen(true)}>
              <Menu size={24} />
            </button>
            <div className="relative w-full max-w-md hidden md:block">
              <Search className="absolute left-3 top-2.5 text-gray-500" size={16} />
              <input
                type="text"
                placeholder="ابحث في المشاريع أو المكونات أو المقالات..."
                className="w-full bg-[#1e1e24] border border-gray-700 rounded-full py-1.5 pl-9 pr-4 text-sm text-gray-300 focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all placeholder:text-gray-600"
              />
            </div>
          </div>

          <div className="flex items-center gap-5">
            <button className="relative text-gray-400 hover:text-white transition-colors">
              <Bell size={20} />
              <span className="absolute top-0.5 right-0.5 w-2 h-2 bg-red-500 rounded-full border-2 border-[#131316]"></span>
            </button>
            {!isLoggedIn && (
              <div className="flex items-center gap-3">
                <button onClick={() => setIsLoggedIn(true)} className="text-sm font-medium text-gray-400 hover:text-white hidden sm:block transition-colors">
                  تسجيل
                </button>
                <button onClick={() => setIsLoggedIn(true)} className="text-sm font-bold bg-white text-black px-4 py-1.5 rounded-full hover:bg-gray-200 transition-colors">
                  إنشاء حساب
                </button>
              </div>
            )}
          </div>
        </div>

        <main className="flex-1 overflow-y-auto p-6 md:p-8 custom-scrollbar">
          <div className="max-w-7xl mx-auto pb-10">
            {activeTab === 'dashboard' && <DashboardView />}
            {activeTab === 'learn' && <LearnView />}
            {activeTab === 'community' && <CommunityView />}
            {activeTab === 'shop' && <ShopView />}
          </div>
        </main>
      </div>
    </div>
  );
}
