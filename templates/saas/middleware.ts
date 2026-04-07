import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs';
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

// Routes that require authentication
const PROTECTED_ROUTES = ['/dashboard', '/settings', '/billing'];

// Routes only for unauthenticated users
const AUTH_ROUTES = ['/login', '/signup'];

export async function middleware(req: NextRequest) {
  const res = NextResponse.next();
  const supabase = createMiddlewareClient({ req, res });

  const {
    data: { session },
  } = await supabase.auth.getSession();

  const { pathname } = req.nextUrl;

  // Redirect authenticated users away from auth pages
  if (session && AUTH_ROUTES.some(r => pathname.startsWith(r))) {
    return NextResponse.redirect(new URL('/dashboard', req.url));
  }

  // Redirect unauthenticated users away from protected pages
  if (!session && PROTECTED_ROUTES.some(r => pathname.startsWith(r))) {
    const loginUrl = new URL('/login', req.url);
    loginUrl.searchParams.set('next', pathname);
    return NextResponse.redirect(loginUrl);
  }

  return res;
}

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico|icons).*)'],
};
