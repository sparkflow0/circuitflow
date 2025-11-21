import type { Metadata } from "next";
import { Tajawal } from "next/font/google";
import "./globals.css";
import { LanguageProvider } from "@/lib/LanguageContext";

const tajawal = Tajawal({
  subsets: ["arabic", "latin"],
  weight: ["200", "300", "400", "500", "700", "800", "900"],
  variable: '--font-tajawal'
});

export const metadata: Metadata = {
  title: "Arduino Education Platform",
  description: "Master Arduino with AI Simulation",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ar" dir="rtl">
      <body className={`${tajawal.className} antialiased bg-[#0f0f13] text-gray-100 min-h-screen`}>
        <LanguageProvider>
            {children}
        </LanguageProvider>
      </body>
    </html>
  );
}
