
    -- CLEANUP (Reset courses to avoid duplicates)
    TRUNCATE TABLE public.user_progress CASCADE;
    TRUNCATE TABLE public.certificates CASCADE;
    DELETE FROM public.quiz_questions;
    DELETE FROM public.lessons;
    DELETE FROM public.course_modules;
    DELETE FROM public.courses;
    
    -- VARIABLES FOR IDs
    DO $$
    DECLARE
        c_id uuid;
        m_id uuid;
        l_id uuid;
    BEGIN
    
        -- Course: Arduino Zero to Hero
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Arduino Zero to Hero', 'arduino-zero-to-hero', 'دورة شاملة من الصفر حتى الاحتراف في برمجة المتحكمات الدقيقة أردوينو.', 'دورة شاملة من الصفر حتى الاحتراف في برمجة المتحكمات الدقيقة أردوينو.', 'Beginner', 0, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-kltock', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-52op2u', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-zvaw4k', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-xy7667', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-0g5hbe', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-luwyjk', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-37nbd4', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-j6a4bw', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-z2bh4b', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: ESP32 IoT Masterclass
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('ESP32 IoT Masterclass', 'esp32-iot-masterclass', 'احتراف إنترنت الأشياء باستخدام شريحة ESP32 القوية.', 'احتراف إنترنت الأشياء باستخدام شريحة ESP32 القوية.', 'Advanced', 4900, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-szq4xe', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-agbu4y', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-4fo6pf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-5oryhb', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-5yrtxc', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-jj8jv1', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-b404eo', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-z17xjb', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-gyfm2b', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Understanding IoT Protocols
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Understanding IoT Protocols', 'iot-protocols', 'فهم عميق لبروتوكولات MQTT, HTTP, CoAP وغيرها.', 'فهم عميق لبروتوكولات MQTT, HTTP, CoAP وغيرها.', 'Intermediate', 0, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-f9999w', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-k2jmsa', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-o7iu7m', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-leuv8u', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-0bqbev', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-5j4rmf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-752wwn', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-wflvqw', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-y7flt7', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Circuit Design Fundamentals
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Circuit Design Fundamentals', 'circuit-design', 'أسس تصميم الدوائر الإلكترونية وقراءة المخططات.', 'أسس تصميم الدوائر الإلكترونية وقراءة المخططات.', 'Beginner', 0, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-9h8cvc', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-29hj3j', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-f2jxzv', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-e24kgm', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-kyi27b', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-nq3laq', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-j5u4ol', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-rongbz', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-ed2k1o', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Python for Beginners
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Python for Beginners', 'python-beginners', 'تعلم لغة بايثون من الأساسيات.', 'تعلم لغة بايثون من الأساسيات.', 'Beginner', 0, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-sy3hve', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-81mw0z', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-wbfv9k', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-3q3mei', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-y6c311', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-xp4nxw', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-koqt1z', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-j4xw5a', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-lcyqtv', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: AI with Python
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('AI with Python', 'ai-python', 'بناء نماذج ذكاء اصطناعي باستخدام بايثون.', 'بناء نماذج ذكاء اصطناعي باستخدام بايثون.', 'Advanced', 9900, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-e6qp9i', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-0hm11p', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-dnfuxn', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-1aqb4o', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-ujlpd4', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-dm8ufi', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-bdz3wp', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-7xh04c', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-dtdws2', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Computer Vision: Beginner
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Computer Vision: Beginner', 'cv-beginner', 'المدخل إلى معالجة الصور والرؤية الحاسوبية.', 'المدخل إلى معالجة الصور والرؤية الحاسوبية.', 'Beginner', 0, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-pyulao', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-7abofm', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-o3m9ef', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-x9nrh5', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-41kx0f', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-2vinvc', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-61l4ig', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-l7llzj', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-1kvgpd', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Computer Vision: Intermediate
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Computer Vision: Intermediate', 'cv-intermediate', 'خوارزميات كشف الكائنات والوجه.', 'خوارزميات كشف الكائنات والوجه.', 'Intermediate', 5900, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-xasg8j', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-kunwfb', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-rr3fn6', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-vu6clb', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-e10gr4', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-ndnxzi', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-k1y4bl', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-rjx1x8', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-n8qruy', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Computer Vision: Advanced
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Computer Vision: Advanced', 'cv-advanced', 'الشبكات العصبية العميقة للرؤية الحاسوبية.', 'الشبكات العصبية العميقة للرؤية الحاسوبية.', 'Advanced', 12000, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-hasf38', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-3j1a0q', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-r0ecxf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-g93ceu', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-gprx61', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-z6qdb0', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-i5lewb', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-qnq9oh', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-qaqqwf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
        -- Course: Prompt Engineering Mastery
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published)
        VALUES ('Prompt Engineering Mastery', 'prompt-engineering', 'كيفية التحدث مع الذكاء الاصطناعي للحصول على أفضل النتائج.', 'كيفية التحدث مع الذكاء الاصطناعي للحصول على أفضل النتائج.', 'Intermediate', 3900, true)
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-xilpch', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-ipjz61', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-2uldj0', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-gi56lj', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-ndv77y', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-qhbqvx', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-lesson-9i8zd5', 'video', '<p>شاهد هذا الفيديو للتعرف على المفاهيم الأساسية.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح التفصيلي', 'text-lesson-2c7hng', 'text', '<h2>المفاهيم النظرية</h2><p>في هذا الدرس سنتناول الجوانب النظرية...</p><ul><li>مفهوم 1</li><li>مفهوم 2</li></ul>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-lesson-gvh86a', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V", "24V"]'::jsonb, 1),
            (l_id, 'ما هي لغة البرمجة المستخدمة؟', '["Java", "Python", "C++", "Swift"]'::jsonb, 2);
            
END $$;