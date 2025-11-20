# Arduino Education Platform (Unified)

A Next.js 14+ (App Router) platform that includes the Arduino Simulator, training courses, and digital store in a single application.

## Tech Stack
- **Framework**: Next.js 14+ (TypeScript)
- **Styling**: Tailwind CSS
- **Auth & Database**: Supabase
- **Payments**: Stripe
- **AI**: Google Gemini (via API)

## Getting Started

### 1. Environment Setup
Create a `.env.local` file in the root:

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_for_admin_tasks

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# App Config
NEXT_PUBLIC_BASE_URL=http://localhost:3000

# AI Integration
NEXT_PUBLIC_GEMINI_API_KEY=your_gemini_api_key
```

### 2. Database Setup
Run the contents of `schema.sql` in your Supabase SQL Editor to set up tables, RLS policies, and triggers.

### 3. Install Dependencies
```bash
npm install
```

### 4. Run Locally
```bash
npm run dev
```
