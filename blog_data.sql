
-- 1. Create Comments Table
create table if not exists public.comments (
  id uuid default uuid_generate_v4() primary key,
  post_id uuid references public.blog_posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  content text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS on Comments
alter table public.comments enable row level security;

-- Policy: Everyone can read comments
create policy "Comments are viewable by everyone" on comments for select using (true);

-- Policy: Authenticated users can insert comments
create policy "Users can insert their own comments" on comments for insert with check (auth.uid() = user_id);

-- 2. Add Cover Image Column to Blog Posts if missing
do $$ 
begin
    if not exists (select 1 from information_schema.columns where table_name='blog_posts' and column_name='cover_image') then
        alter table public.blog_posts add column cover_image text;
    end if;
end $$;

-- 3. Clear existing posts to avoid duplicates during testing
truncate table public.comments;
delete from public.blog_posts;

-- 4. Insert Arabic Blog Posts (Inspired by Random Nerd Tutorials)

-- Post 1: ESP32 Web Server
insert into public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
values (
  'إنشاء خادم ويب للتحكم في المخرجات باستخدام ESP32',
  'esp32-web-server-arabic',
  'تعلم كيفية بناء خادم ويب بسيط باستخدام لوحة ESP32 للتحكم في مصابيح LED عن بُعد عبر شبكة الواي فاي.',
  'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
  '
  <h2>المقدمة</h2>
  <p>في هذا الدرس التعليمي، سنقوم بإنشاء خادم ويب مستقل باستخدام لوحة ESP32 للتحكم في المخرجات (مثل مصابيح LED) عبر أي جهاز متصل بالشبكة المحلية.</p>
  
  <img src="https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80" alt="ESP32" class="rounded-lg my-4 w-full object-cover h-64"/>

  <h3>الأدوات المطلوبة:</h3>
  <ul class="list-disc list-inside mb-4">
    <li>لوحة ESP32 Development Board</li>
    <li>2x مصابيح LED (أحمر وأخضر)</li>
    <li>2x مقاومات 220 أوم</li>
    <li>لوحة تجارب (Breadboard) وأسلاك توصيل</li>
  </ul>

  <h3>الدائرة الكهربائية</h3>
  <p>قم بتوصيل مصابيح LED بالأرجل رقم 26 و 27 في لوحة ESP32. تأكد من توصيل المقاومات على التوالي لحماية المصابيح.</p>

  <h3>الكود البرمجي</h3>
  <pre class="bg-gray-900 text-gray-100 p-4 rounded overflow-x-auto">
#include <WiFi.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

WiFiServer server(80);

void setup() {
  Serial.begin(115200);
  pinMode(26, OUTPUT);
  pinMode(27, OUTPUT);
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  server.begin();
}

void loop() {
  // logic code here
}
  </pre>
  <p>بعد رفع الكود، افتح الشاشة التسلسلية (Serial Monitor) لمعرفة عنوان IP الخاص بـ ESP32، ثم افتحه في المتصفح.</p>
  ',
  true,
  now()
);

-- Post 2: DHT11/DHT22 Web Server
insert into public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
values (
  'قراءة درجة الحرارة والرطوبة وعرضها على الويب باستخدام ESP32',
  'esp32-dht11-dht22-web-server',
  'مشروع متكامل لبناء محطة أرصاد جوية مصغرة باستخدام مستشعر DHT وعرض البيانات لحظياً.',
  'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
  '
  <h2>نظرة عامة</h2>
  <p>يعد مستشعر DHT11 أو DHT22 من أشهر المستشعرات لقياس الرطوبة ودرجة الحرارة. سنقوم بربطه مع ESP32 وعرض القراءات على واجهة ويب جذابة.</p>

  <h3>المكونات:</h3>
  <ul class="list-disc list-inside mb-4">
    <li>ESP32</li>
    <li>مستشعر DHT11 أو DHT22</li>
    <li>مقاومة 4.7k أوم</li>
  </ul>

  <h3>طريقة العمل</h3>
  <p>يستخدم المستشعر بروتوكول اتصال خاص بسلك واحد. سنستخدم مكتبة <code>DHT.h</code> لقراءة البيانات.</p>
  
  <div class="bg-blue-50 p-4 border-l-4 border-blue-500 my-4">
    <strong>ملاحظة:</strong> مستشعر DHT22 أكثر دقة من DHT11، ولكنه أغلى قليلاً. الكود يعمل مع الاثنين بتغيير بسيط.
  </div>

  <h3>تحديث صفحة الويب تلقائياً</h3>
  <p>لجعل الصفحة تعرض درجات الحرارة الجديدة دون الحاجة لتحديث الصفحة يدوياً، سنستخدم تقنية AJAX في كود HTML/JavaScript المضمن داخل الأردوينو.</p>
  ',
  true,
  now()
);

-- Post 3: PWM LED Control
insert into public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
values (
  'التحكم في سطوع LED باستخدام تقنية PWM في الأردوينو',
  'arduino-pwm-led-control',
  'دليل للمبتدئين لفهم إشارات التماثلية (Analog) وكيفية محاكاتها باستخدام PWM للتحكم في الإضاءة.',
  'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
  '
  <h2>ما هو PWM؟</h2>
  <p>تقنية تعديل عرض النبضة (Pulse Width Modulation) هي طريقة للحصول على نتائج تماثلية (Analog) باستخدام وسائل رقمية (Digital). من خلال تشغيل وإيقاف الإشارة بسرعة كبيرة، يمكننا التحكم في كمية الطاقة المرسلة إلى LED.</p>

  <img src="https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80" alt="Arduino Board" class="rounded-lg my-4 w-full object-cover h-64"/>

  <h3>التطبيق العملي</h3>
  <p>سنستخدم الدالة <code>analogWrite()</code> في بيئة Arduino IDE. هذه الدالة تأخذ قيماً من 0 (مطفأ تماماً) إلى 255 (إضاءة كاملة).</p>

  <h3>الكود: تأثير التنفس (Fading)</h3>
  <pre class="bg-gray-900 text-gray-100 p-4 rounded overflow-x-auto">
int ledPin = 9;    // LED connected to digital pin 9

void setup() {
  // nothing happens in setup
}

void loop() {
  // fade in from min to max in increments of 5 points:
  for (int fadeValue = 0 ; fadeValue <= 255; fadeValue += 5) {
    analogWrite(ledPin, fadeValue);
    delay(30);
  }

  // fade out from max to min in increments of 5 points:
  for (int fadeValue = 255 ; fadeValue >= 0; fadeValue -= 5) {
    analogWrite(ledPin, fadeValue);
    delay(30);
  }
}
  </pre>
  ',
  true,
  now()
);
