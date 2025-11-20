import Link from 'next/link'
import { signup } from '../actions'
import { Button } from '@/components/ui/Button'

export default function SignUpPage({ searchParams }: { searchParams: { error?: string } }) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 px-4">
      <div className="max-w-md w-full space-y-8 bg-white p-8 rounded-xl shadow-sm border border-slate-200">
        <div className="text-center">
          <h2 className="mt-6 text-3xl font-extrabold text-slate-900">Create your account</h2>
          <p className="mt-2 text-sm text-slate-600">
            Start simulating in seconds
          </p>
        </div>

        <form className="mt-8 space-y-6">
          <div className="rounded-md shadow-sm -space-y-px">
             <div>
              <input
                id="full_name"
                name="full_name"
                type="text"
                required
                className="appearance-none rounded-none relative block w-full px-3 py-2 border border-slate-300 placeholder-slate-500 text-slate-900 rounded-t-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                placeholder="Full Name"
              />
            </div>
            <div>
              <input
                id="email"
                name="email"
                type="email"
                autoComplete="email"
                required
                className="appearance-none rounded-none relative block w-full px-3 py-2 border border-slate-300 placeholder-slate-500 text-slate-900 focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                placeholder="Email address"
              />
            </div>
            <div>
              <input
                id="password"
                name="password"
                type="password"
                required
                className="appearance-none rounded-none relative block w-full px-3 py-2 border border-slate-300 placeholder-slate-500 text-slate-900 rounded-b-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                placeholder="Password"
              />
            </div>
          </div>

          {searchParams?.error && (
            <div className="text-red-500 text-sm text-center">{searchParams.error}</div>
          )}

          <div>
            <Button formAction={signup} className="w-full" size="lg">
              Sign Up
            </Button>
          </div>
          
          <div className="text-center text-sm">
            Already have an account? <Link href="/auth/signin" className="font-medium text-blue-600 hover:text-blue-500">Sign in</Link>
          </div>
        </form>
      </div>
    </div>
  )
}
