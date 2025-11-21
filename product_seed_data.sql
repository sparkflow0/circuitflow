
    -- CLEANUP (Reset products to avoid duplicates)
    TRUNCATE TABLE public.product_purchases CASCADE;
    DELETE FROM public.products;
    
    -- INSERT PRODUCTS
    
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Edge-AI Voice Command Controller', 
            'edge-ai-voice-command-controller-vfaf', 
            'لوحة مدمجة تعتمد على ESP32 وميكروفون I2S MEMS. تتيح التعرف على الأوامر الصوتية محلياً باستخدام TensorFlow Lite Micro دون الحاجة للإنترنت. مثالية للتحكم في المنزل الذكي.', 
            2500, 
            'https://images.unsplash.com/photo-1589254065878-42c9da997008?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Based Image Detection Sensor', 
            'ai-based-image-detection-sensor-rtez', 
            'نظام رؤية حاسوبية منخفض الدقة باستخدام ESP32-S3 وكاميرا. يكتشف الحركة والإيماءات والأشخاص محلياً. ممتاز لأنظمة الحضور والأمن الذكي.', 
            3000, 
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Predictive Maintenance Sensor Node', 
            'predictive-maintenance-sensor-node-nysp', 
            'PCB يدمج ESP32 مع مقياس تسارع للكشف عن شذوذ الاهتزازات في المحركات والمضخات باستخدام الذكاء الاصطناعي. يمنع الأعطال قبل حدوثها.', 
            4500, 
            'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Smart Energy Usage Classifier', 
            'smart-energy-usage-classifier-fggp', 
            'راقب استهلاك الطاقة بذكاء. يستخدم ESP32 وحساسات التيار لتحديد نوع الجهاز المشغل بناءً على بصمة استهلاكه الكهربائي.', 
            2000, 
            'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Powered Environmental Monitor', 
            'ai-powered-environmental-monitor-bksk', 
            'راقب جودة الهواء (CO2, PM2.5) وتوقع الاتجاهات البيئية باستخدام نماذج ML مدمجة. مثالي للمباني الخضراء والمدارس.', 
            3500, 
            'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Assisted Smart Door Lock', 
            'ai-assisted-smart-door-lock-lpwn', 
            'قفل ذكي متكامل (لوحة مفاتيح، بصمة، NFC) يتعلم أنماط الاستخدام ليقوم بالقفل التلقائي بذكاء وتوفير أمان تكيفي.', 
            4000, 
            'https://images.unsplash.com/photo-1558002038-1091a16627a3?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'License-Plate Edge Detector', 
            'license-plate-edge-detector-phwv', 
            'نظام خفيف جداً للتعرف على لوحات السيارات ورموز QR باستخدام ESP32-S3. حل مثالي ومنخفض التكلفة لمواقف السيارات والبوابات.', 
            5000, 
            'https://images.unsplash.com/photo-1597733336794-12d05021d510?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Intelligent Classroom Sensor Hub', 
            'intelligent-classroom-sensor-hub-jgap', 
            'محطة استشعار للفصول الذكية تقيس الحضور، ومستوى الضوضاء، وجودة الهواء لتهيئة بيئة تعليمية مثالية تلقائياً.', 
            3500, 
            'https://images.unsplash.com/photo-1509062522246-37559cc792f9?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Smart Agriculture Node', 
            'smart-agriculture-node-phgt', 
            'عقدة زراعية ذكية تتنبأ باحتياجات الري بناءً على رطوبة التربة والعوامل الجوية باستخدام خوارزميات تعلم الآلة.', 
            2800, 
            'https://images.unsplash.com/photo-1530836369250-ef720383e600?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Based Traffic Counter', 
            'ai-based-traffic-counter-iaqu', 
            'محلل حركة مرور باستخدام ESP32-CAM. يميز بين السيارات والدراجات والمشاة للمساعدة في تخطيط المدن الذكية.', 
            3200, 
            'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Gesture-Control Pad', 
            'gesture-control-pad-qtoy', 
            'لوحة تحكم بالإيماءات تعتمد على حساس APDS-9960 ونماذج ML لتصنيف حركات اليد المخصصة. رائعة للألعاب والأجهزة التفاعلية.', 
            2200, 
            'https://images.unsplash.com/photo-1616469829941-c7200edec809?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Powered Sound Classifier', 
            'ai-powered-sound-classifier-oyna', 
            'جهاز استماع ذكي يصنف الأصوات المحيطة (مثل تكسر الزجاج، بكاء الطفل، نباح الكلب) ويرسل تنبيهات فورية.', 
            2900, 
            'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Occupancy Radar Detector', 
            'occupancy-radar-detector-hbzd', 
            'كاشف حضور فائق الدقة باستخدام رادار mmWave والذكاء الاصطناعي للتنبؤ بأنماط الإشغال وتحسين الإضاءة والتكييف.', 
            4200, 
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Driven Smart Relay Board', 
            'ai-driven-smart-relay-board-mpaj', 
            'لوحة تحكم بـ 16 مرحل (Relay) تتنبأ بمواعيد التشغيل والإيقاف المثلى للأحمال الكهربائية بناءً على البيانات التاريخية.', 
            3800, 
            'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI Audio Control for Mosques', 
            'ai-audio-control-for-mosques-jmlj', 
            'نظام ذكي لإدارة الصوتيات في المساجد والقاعات. يضبط مستويات الصوت تلقائياً بناءً على الضجيج المحيط وعدد الحضور.', 
            5500, 
            'https://images.unsplash.com/photo-1564121211835-e88c852648ab?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Predictive Water Tank Controller', 
            'ai-predictive-water-tank-controller-bryc', 
            'وحدة تحكم في المضخات تتنبأ بمعدلات استهلاك المياه وجداول الملء التلقائي لضمان توفر المياه وكفاءة الطاقة.', 
            2400, 
            'https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI Camera Trap for Wildlife', 
            'ai-camera-trap-for-wildlife-zlac', 
            'كاميرا ذكية للمحميات والمزارع تعمل بـ ESP32. تميز بين الحيوانات والبشر لتقليل الإنذارات الكاذبة.', 
            3100, 
            'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'Smart Inventory Shelf', 
            'smart-inventory-shelf-ciiz', 
            'رف ذكي مزود بخلايا وزن (Load Cells) يتنبأ بنفاذ المخزون ويرسل طلبات إعادة التعبئة تلقائياً.', 
            4600, 
            'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Motion for Physiotherapy', 
            'ai-motion-for-physiotherapy-ziqp', 
            'جهاز قابل للارتداء يصنف التمارين الرياضية ويعد التكرارات بدقة باستخدام حساسات IMU ونماذج تعلم الآلة.', 
            3300, 
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        
        INSERT INTO public.products (title, slug, description, price, file_url, is_published, variants)
        VALUES (
            'AI-Edge Safety System', 
            'ai-edge-safety-system-wckq', 
            'نظام أمان للورش والمصانع يكتشف الأحداث الخطرة (سقوط، تشغيل مفاجئ للآلات) باستخدام الصوت والاهتزاز.', 
            4800, 
            'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?auto=format&fit=crop&w=800&q=80', 
            true,
            '[{"name": "Standard License (Personal)", "price_mod": 0}, {"name": "Commercial License (Resale)", "price_mod": 5000}]'::jsonb
        );
        