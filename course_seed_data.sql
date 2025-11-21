
    -- 1. Ensure Columns Exist
    DO $$ 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='courses' AND column_name='banner_image') THEN
            ALTER TABLE public.courses ADD COLUMN banner_image text;
        END IF;
    END $$;

    -- 2. Cleanup Old Data
    TRUNCATE TABLE public.user_progress CASCADE;
    TRUNCATE TABLE public.certificates CASCADE;
    DELETE FROM public.quiz_questions;
    DELETE FROM public.lessons;
    DELETE FROM public.course_modules;
    DELETE FROM public.courses;
    
    -- 3. Variables for IDs
    DO $$
    DECLARE
        c_id uuid;
        m_id uuid;
        l_id uuid;
    BEGIN
    
        -- Course: Arduino Zero to Hero
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Arduino Zero to Hero', 'arduino-zero-to-hero', 'دورة شاملة من الصفر حتى الاحتراف في برمجة المتحكمات الدقيقة أردوينو.', 'دورة شاملة من الصفر حتى الاحتراف في برمجة المتحكمات الدقيقة أردوينو.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1555664424-778a184335ec?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-7c5lej', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-9cddlw', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-1m3ddt', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-9wglo3', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-wz82wr', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-ycdvou', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-yrnj4h', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-m8v5o5', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-i9n2ie', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: ESP32 IoT Masterclass
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('ESP32 IoT Masterclass', 'esp32-iot-masterclass', 'احتراف إنترنت الأشياء باستخدام شريحة ESP32 القوية.', 'احتراف إنترنت الأشياء باستخدام شريحة ESP32 القوية.', 'Advanced', 4900, true, 'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1553406830-ef2513450d76?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-3sael9', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-86rljs', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-2dzuxg', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-yjrfr2', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-vikmlq', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-bo6pok', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-hnmx26', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-2botqd', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-kicvkg', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Understanding IoT Protocols
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Understanding IoT Protocols', 'iot-protocols', 'فهم عميق لبروتوكولات MQTT, HTTP, CoAP وغيرها.', 'فهم عميق لبروتوكولات MQTT, HTTP, CoAP وغيرها.', 'Intermediate', 0, true, 'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-2tfnsr', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-2ulhzz', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-t34il1', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-wa32t0', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-5rxqhn', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-hwttf5', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-xw44xw', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-d8gi6i', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-8fm2lr', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Circuit Design Fundamentals
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Circuit Design Fundamentals', 'circuit-design', 'أسس تصميم الدوائر الإلكترونية وقراءة المخططات.', 'أسس تصميم الدوائر الإلكترونية وقراءة المخططات.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-hxadcy', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-c1ez13', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-d7imis', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-yxnxza', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-7yjxpt', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-ie1iks', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-z77uz9', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-37thqt', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-o61wkv', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Python for Beginners
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Python for Beginners', 'python-beginners', 'تعلم لغة بايثون من الأساسيات.', 'تعلم لغة بايثون من الأساسيات.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-gnwu94', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-yiv8bf', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-9jfcyf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-jdj6aw', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-xjo7un', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-f2xvgq', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-dxayth', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-xpyffo', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-oi0d9p', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: AI with Python
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('AI with Python', 'ai-python', 'بناء نماذج ذكاء اصطناعي باستخدام بايثون.', 'بناء نماذج ذكاء اصطناعي باستخدام بايثون.', 'Advanced', 9900, true, 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-252hzb', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-wve3xa', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-vmvcb4', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-608kou', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-vvugge', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-w3v7vf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-1l7amq', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-e379e5', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-win0vr', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Computer Vision: Beginner
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Computer Vision: Beginner', 'cv-beginner', 'المدخل إلى معالجة الصور والرؤية الحاسوبية.', 'المدخل إلى معالجة الصور والرؤية الحاسوبية.', 'Beginner', 0, true, 'https://images.unsplash.com/photo-1507146153580-69a1fe6d8aa1?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1507146153580-69a1fe6d8aa1?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-x1fwh5', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-2dpqly', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-y5rhx8', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-nbmrny', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-diim4t', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-zux3m9', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-u15fg6', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-kxdvpt', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-rn4aes', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Computer Vision: Intermediate
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Computer Vision: Intermediate', 'cv-intermediate', 'خوارزميات كشف الكائنات والوجه.', 'خوارزميات كشف الكائنات والوجه.', 'Intermediate', 5900, true, 'https://images.unsplash.com/photo-1555255707-c07966088b7b?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1555255707-c07966088b7b?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-kpjrr8', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-78yn5b', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-x0qr9h', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-myev87', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-eumx21', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-sfx8lf', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-emese6', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-hjxwdu', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-5mcamx', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Computer Vision: Advanced
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Computer Vision: Advanced', 'cv-advanced', 'الشبكات العصبية العميقة للرؤية الحاسوبية.', 'الشبكات العصبية العميقة للرؤية الحاسوبية.', 'Advanced', 12000, true, 'https://images.unsplash.com/photo-1527430253228-e93688616381?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1527430253228-e93688616381?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-jos5a8', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-1zcskv', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-s4vipe', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-0fxkaf', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-4sg623', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-e2yaum', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-0fyqim', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-crli0c', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-onlbbj', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
        -- Course: Prompt Engineering Mastery
        INSERT INTO public.courses (title, slug, short_description, full_description, level, price, is_published, cover_image, banner_image)
        VALUES ('Prompt Engineering Mastery', 'prompt-engineering', 'كيفية التحدث مع الذكاء الاصطناعي للحصول على أفضل النتائج.', 'كيفية التحدث مع الذكاء الاصطناعي للحصول على أفضل النتائج.', 'Intermediate', 3900, true, 'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=800&q=80', 'https://images.unsplash.com/photo-1677442136019-21780ecad995?auto=format&fit=crop&w=1920&q=80')
        RETURNING id INTO c_id;
        
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 1: أساسيات ومفاهيم', 1)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-q1c2si', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-h0xef8', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-grqc70', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 2: أساسيات ومفاهيم', 2)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-tj3zvj', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-ybpvr7', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-eypzlb', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
            INSERT INTO public.course_modules (course_id, title, order_index)
            VALUES (c_id, 'الوحدة 3: أساسيات ومفاهيم', 3)
            RETURNING id INTO m_id;
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, video_url, duration, order_index, is_free_preview)
            VALUES (c_id, m_id, 'درس فيديو: مقدمة عملية', 'video-wx91u5', 'video', '<p>شاهد هذا الفيديو.</p>', 'https://www.youtube.com/watch?v=zJ-LqeX_fLU', 10, 1, true);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'درس قراءة: الشرح', 'text-3ldib2', 'text', '<h2>شرح نظري</h2><p>محتوى نصي...</p>', 15, 2);
            
            INSERT INTO public.lessons (course_id, module_id, title, slug, type, content, duration, order_index)
            VALUES (c_id, m_id, 'اختبار قصير', 'quiz-ocjf6g', 'quiz', 'اختبر معلوماتك', 5, 3)
            RETURNING id INTO l_id;

            INSERT INTO public.quiz_questions (lesson_id, question, options, correct_index)
            VALUES 
            (l_id, 'ما هو الجهد التشغيلي للأردوينو أونو؟', '["3.3V", "5V", "12V"]'::jsonb, 1),
            (l_id, 'لغة البرمجة؟', '["Java", "Python", "C++"]'::jsonb, 2);
            
END $$;