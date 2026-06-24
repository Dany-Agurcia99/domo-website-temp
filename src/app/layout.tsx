import type { CSSProperties } from "react";
import type { Metadata } from "next";
import { Outfit, Plus_Jakarta_Sans } from "next/font/google";

import { SiteFooter } from "@/components/layout/site-footer";
import {
  siteFooterLinks,
  siteSocialLinks,
  siteText,
} from "@/constants/site-text";
import { themeCssVariables } from "@/constants/theme";

import "./globals.css";
import styles from "./layout.module.css";

const plusJakartaSans = Plus_Jakarta_Sans({
  variable: "--font-main",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
});

const outfit = Outfit({
  variable: "--font-display",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
});

export const metadata: Metadata = {
  title: siteText.metadata.title,
  description: siteText.metadata.description,
  icons: {
    icon: [{ url: "/domo-icon-white.png", type: "image/png" }],
    shortcut: "/domo-icon-white.png",
    apple: "/domo-icon-white.png",
  },
};

const cssVariables = themeCssVariables as CSSProperties;

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="es"
      className={`${plusJakartaSans.variable} ${outfit.variable} h-full antialiased`}
    >
      <body style={cssVariables}>
        <div className={styles.pageLayer}>{children}</div>
        <div className={styles.footerRevealSpace} aria-hidden="true" />
        <SiteFooter links={siteFooterLinks} socialLinks={siteSocialLinks} />
      </body>
    </html>
  );
}
