
    -- CLEANUP
    TRUNCATE TABLE public.comments CASCADE;
    DELETE FROM public.blog_posts;

    -- INSERT POSTS
    
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'البداية مع الأردوينو: وميض LED',
            'arduino-blink',
            'تعلم كل ما يخص البداية مع الأردوينو: وميض LED في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>البداية مع الأردوينو: وميض LED</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-01 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استخدام الزر الانضغاطي مع الأردوينو',
            'arduino-button',
            'تعلم كل ما يخص استخدام الزر الانضغاطي مع الأردوينو في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استخدام الزر الانضغاطي مع الأردوينو</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-02 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قراءة الجهد المتغير (Potentiometer)',
            'arduino-potentiometer',
            'تعلم كل ما يخص قراءة الجهد المتغير (Potentiometer) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قراءة الجهد المتغير (Potentiometer)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-03 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في سطوع LED باستخدام PWM',
            'arduino-pwm',
            'تعلم كل ما يخص التحكم في سطوع LED باستخدام PWM في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في سطوع LED باستخدام PWM</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-04 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في ألوان RGB LED',
            'arduino-rgb',
            'تعلم كل ما يخص التحكم في ألوان RGB LED في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في ألوان RGB LED</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Arduino</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-05 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قياس الحرارة والرطوبة بـ DHT11',
            'arduino-dht11',
            'تعلم كل ما يخص قياس الحرارة والرطوبة بـ DHT11 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قياس الحرارة والرطوبة بـ DHT11</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-06 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قياس المسافة بحساس الموجات فوق الصوتية',
            'arduino-ultrasonic',
            'تعلم كل ما يخص قياس المسافة بحساس الموجات فوق الصوتية في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قياس المسافة بحساس الموجات فوق الصوتية</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-07 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'كشف الحركة باستخدام حساس PIR',
            'arduino-pir',
            'تعلم كل ما يخص كشف الحركة باستخدام حساس PIR في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>كشف الحركة باستخدام حساس PIR</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-08 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'نظام الإضاءة التلقائي باستخدام LDR',
            'arduino-ldr',
            'تعلم كل ما يخص نظام الإضاءة التلقائي باستخدام LDR في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>نظام الإضاءة التلقائي باستخدام LDR</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-09 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استشعار الصوت باستخدام الميكروفون',
            'arduino-sound',
            'تعلم كل ما يخص استشعار الصوت باستخدام الميكروفون في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استشعار الصوت باستخدام الميكروفون</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-10 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'قياس رطوبة التربة للزراعة الذكية',
            'arduino-soil',
            'تعلم كل ما يخص قياس رطوبة التربة للزراعة الذكية في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>قياس رطوبة التربة للزراعة الذكية</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-11 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'كشف المطر باستخدام حساس Rain Sensor',
            'arduino-rain',
            'تعلم كل ما يخص كشف المطر باستخدام حساس Rain Sensor في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>كشف المطر باستخدام حساس Rain Sensor</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-12 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استخدام حساس الميل (Tilt Switch)',
            'arduino-tilt',
            'تعلم كل ما يخص استخدام حساس الميل (Tilt Switch) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استخدام حساس الميل (Tilt Switch)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-13 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'حساس الحرارة التماثلي LM35',
            'arduino-lm35',
            'تعلم كل ما يخص حساس الحرارة التماثلي LM35 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>حساس الحرارة التماثلي LM35</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Sensors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-14 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'عرض النصوص على شاشة LCD 16x2',
            'arduino-lcd',
            'تعلم كل ما يخص عرض النصوص على شاشة LCD 16x2 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>عرض النصوص على شاشة LCD 16x2</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Displays</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-15 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'الرسومات المتقدمة على شاشة OLED',
            'arduino-oled',
            'تعلم كل ما يخص الرسومات المتقدمة على شاشة OLED في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>الرسومات المتقدمة على شاشة OLED</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Displays</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-16 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'العد التنازلي باستخدام 7-Segment',
            'arduino-7segment',
            'تعلم كل ما يخص العد التنازلي باستخدام 7-Segment في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>العد التنازلي باستخدام 7-Segment</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Displays</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-17 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم الدقيق بمحرك سيرفو',
            'arduino-servo',
            'تعلم كل ما يخص التحكم الدقيق بمحرك سيرفو في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم الدقيق بمحرك سيرفو</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Motors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-18 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في سرعة واتجاه محرك DC',
            'arduino-dc-motor',
            'تعلم كل ما يخص التحكم في سرعة واتجاه محرك DC في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في سرعة واتجاه محرك DC</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Motors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-19 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'دقة الحركة مع المحركات الخطوية (Stepper)',
            'arduino-stepper',
            'تعلم كل ما يخص دقة الحركة مع المحركات الخطوية (Stepper) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>دقة الحركة مع المحركات الخطوية (Stepper)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Motors</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-20 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'لوحة المفاتيح الرقمية (Keypad 4x4)',
            'arduino-keypad',
            'تعلم كل ما يخص لوحة المفاتيح الرقمية (Keypad 4x4) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>لوحة المفاتيح الرقمية (Keypad 4x4)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-21 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم بالألعاب باستخدام Joystick',
            'arduino-joystick',
            'تعلم كل ما يخص التحكم بالألعاب باستخدام Joystick في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم بالألعاب باستخدام Joystick</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-22 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'أنظمة الأمان باستخدام بطاقات RFID',
            'arduino-rfid',
            'تعلم كل ما يخص أنظمة الأمان باستخدام بطاقات RFID في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1581092335397-9583eb92d232?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>أنظمة الأمان باستخدام بطاقات RFID</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-23 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'توليد النغمات والموسيقى (Piezo Buzzer)',
            'arduino-buzzer',
            'تعلم كل ما يخص توليد النغمات والموسيقى (Piezo Buzzer) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>توليد النغمات والموسيقى (Piezo Buzzer)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-24 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم في الأجهزة المنزلية باستخدام Relay',
            'arduino-relay',
            'تعلم كل ما يخص التحكم في الأجهزة المنزلية باستخدام Relay في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم في الأجهزة المنزلية باستخدام Relay</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>IO</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-25 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'مقدمة إلى شريحة ESP32 الخارقة',
            'esp32-intro',
            'تعلم كل ما يخص مقدمة إلى شريحة ESP32 الخارقة في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>مقدمة إلى شريحة ESP32 الخارقة</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-26 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'بناء خادم ويب للتحكم عبر الواي فاي',
            'esp32-web-server',
            'تعلم كل ما يخص بناء خادم ويب للتحكم عبر الواي فاي في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>بناء خادم ويب للتحكم عبر الواي فاي</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-27 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'ربط ESP32 بشبكة المنزل (Station Mode)',
            'esp32-station-mode',
            'تعلم كل ما يخص ربط ESP32 بشبكة المنزل (Station Mode) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>ربط ESP32 بشبكة المنزل (Station Mode)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-28 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'جعل ESP32 نقطة اتصال (Access Point)',
            'esp32-access-point',
            'تعلم كل ما يخص جعل ESP32 نقطة اتصال (Access Point) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>جعل ESP32 نقطة اتصال (Access Point)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-29 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'التحكم عبر البلوتوث (Bluetooth Classic)',
            'esp32-bluetooth',
            'تعلم كل ما يخص التحكم عبر البلوتوث (Bluetooth Classic) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>التحكم عبر البلوتوث (Bluetooth Classic)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-30 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تقنية البلوتوث منخفض الطاقة (BLE)',
            'esp32-ble',
            'تعلم كل ما يخص تقنية البلوتوث منخفض الطاقة (BLE) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تقنية البلوتوث منخفض الطاقة (BLE)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-10-31 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'استخدام دبابيس اللمس (Touch Pins)',
            'esp32-touch',
            'تعلم كل ما يخص استخدام دبابيس اللمس (Touch Pins) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>استخدام دبابيس اللمس (Touch Pins)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-01 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'مستشعر المجال المغناطيسي المدمج',
            'esp32-hall-effect',
            'تعلم كل ما يخص مستشعر المجال المغناطيسي المدمج في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>مستشعر المجال المغناطيسي المدمج</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-02 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'توفير الطاقة باستخدام وضع النوم العميق',
            'esp32-deep-sleep',
            'تعلم كل ما يخص توفير الطاقة باستخدام وضع النوم العميق في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>توفير الطاقة باستخدام وضع النوم العميق</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-03 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'حفظ البيانات في الذاكرة الدائمة (Preferences)',
            'esp32-preferences',
            'تعلم كل ما يخص حفظ البيانات في الذاكرة الدائمة (Preferences) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>حفظ البيانات في الذاكرة الدائمة (Preferences)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-04 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'نظام الملفات SPIFFS في ESP32',
            'esp32-spiffs',
            'تعلم كل ما يخص نظام الملفات SPIFFS في ESP32 في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>نظام الملفات SPIFFS في ESP32</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-05 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'بروتوكول MQTT لإنترنت الأشياء',
            'esp32-mqtt',
            'تعلم كل ما يخص بروتوكول MQTT لإنترنت الأشياء في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>بروتوكول MQTT لإنترنت الأشياء</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-06 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'إرسال رسائل تنبيه إلى تيليجرام',
            'esp32-telegram',
            'تعلم كل ما يخص إرسال رسائل تنبيه إلى تيليجرام في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>إرسال رسائل تنبيه إلى تيليجرام</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-07 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'إرسال بريد إلكتروني عند كشف الحركة',
            'esp32-email',
            'تعلم كل ما يخص إرسال بريد إلكتروني عند كشف الحركة في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>إرسال بريد إلكتروني عند كشف الحركة</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-08 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'رسم المخططات البيانية لحظياً على الويب',
            'esp32-web-plotter',
            'تعلم كل ما يخص رسم المخططات البيانية لحظياً على الويب في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>رسم المخططات البيانية لحظياً على الويب</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-09 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تحديث الكود عن بعد (OTA Updates)',
            'esp32-ota',
            'تعلم كل ما يخص تحديث الكود عن بعد (OTA Updates) في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تحديث الكود عن بعد (OTA Updates)</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-10 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'بث الفيديو باستخدام ESP32-CAM',
            'esp32-cam',
            'تعلم كل ما يخص بث الفيديو باستخدام ESP32-CAM في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>بث الفيديو باستخدام ESP32-CAM</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>ESP32</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-11 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'فهم المقاطعات (Interrupts) في الأردوينو',
            'arduino-interrupts',
            'تعلم كل ما يخص فهم المقاطعات (Interrupts) في الأردوينو في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>فهم المقاطعات (Interrupts) في الأردوينو</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Advanced</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-12 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تعدد المهام باستخدام millis()',
            'arduino-millis',
            'تعلم كل ما يخص تعدد المهام باستخدام millis() في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تعدد المهام باستخدام millis()</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Advanced</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-13 22:36:10'
        );
        
        INSERT INTO public.blog_posts (title, slug, excerpt, cover_image, content, is_published, published_at)
        VALUES (
            'تخزين الإعدادات في EEPROM',
            'arduino-eeprom',
            'تعلم كل ما يخص تخزين الإعدادات في EEPROM في هذا الدرس الشامل. خطوات عملية وكود جاهز.',
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80',
            '
    <div class="blog-post-content" dir="rtl">
      <p class="lead text-xl text-gray-600 mb-6">
        في هذا الدرس التعليمي الممتع، سوف نتعلم بالتفصيل عن <strong>تخزين الإعدادات في EEPROM</strong>. 
        سواء كنت مبتدئاً أو محترفاً، هذا المشروع سيضيف الكثير لمهاراتك في عالم الإلكترونيات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">نظرة عامة</h2>
      <p>
        يعتبر هذا المشروع من التطبيقات الأساسية في مجال <strong>Advanced</strong>. 
        الهدف الرئيسي هنا هو فهم كيفية الربط بين العتاد (Hardware) والبرمجيات (Software) للوصول إلى النتيجة المطلوبة.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">المكونات المطلوبة</h2>
      <ul class="list-disc list-inside space-y-2 bg-gray-50 p-4 rounded-lg border border-gray-200">
        <li>لوحة Arduino Uno أو ESP32</li>
        <li>أسلاك توصيل (Jumper Wires)</li>
        <li>لوحة تجارب (Breadboard)</li>
        <li>مكونات إضافية حسب المشروع (مقاومات، حساسات، إلخ)</li>
      </ul>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">مخطط التوصيل</h2>
      <p class="mb-4">
        قم بتوصيل المكونات كما هو موضح. تأكد من توصيل الطرف الموجب (VCC) بمصدر الطاقة 5V أو 3.3V حسب الحاجة، والطرف السالب (GND) بالأرضي.
        دائماً راجع الدائرة قبل توصيل الكهرباء لتجنب التلف.
      </p>
      
      <div class="bg-blue-50 border-r-4 border-blue-500 p-4 my-4">
        <strong>نصيحة:</strong> استخدم ألواناً مختلفة للأسلاك لتسهيل التتبع (الأحمر للطاقة، الأسود للأرضي).
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الكود البرمجي</h2>
      <p class="mb-4">انسخ الكود التالي وقم برفعه إلى اللوحة باستخدام Arduino IDE:</p>
      
      <div class="relative">
        <pre class="bg-[#1e1e1e] text-gray-100 p-4 rounded-lg overflow-x-auto text-sm font-mono" dir="ltr">void setup() {
  // تهيئة الاتصال التسلسلي
  Serial.begin(9600);
  
  // إعداد الأرجل
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  // الكود الرئيسي
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  
  Serial.println("Working...");
}</pre>
      </div>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">شرح الكود</h2>
      <p>
        في دالة <code>setup()</code> نقوم بتهيئة المنافذ وتحديد ما إذا كانت مدخلات (INPUT) أو مخرجات (OUTPUT).
        أما في دالة <code>loop()</code>، نقوم بكتابة المنطق الذي سيتكرر باستمرار، مثل قراءة الحساسات أو تشغيل المحركات.
      </p>

      <h2 class="text-2xl font-bold text-gray-800 mt-8 mb-4">الخاتمة</h2>
      <p>
        الآن أنت جاهز لتجربة المشروع! حاول التعديل على الكود، تغيير فترات الانتظار، أو إضافة شروط جديدة لجعل المشروع أكثر ذكاءً.
        شاركنا تجربتك في التعليقات بالأسفل.
      </p>
    </div>
    ',
            true,
            '2025-11-14 22:36:10'
        );
        