"use client";

import { useEffect, useState } from "react";
import { ArrowRight } from "lucide-react";
import Link from "next/link";

import { Wordmark } from "@/components/brand/wordmark";

import styles from "./site-nav.module.css";

type NavItem = {
  href: string;
  label: string;
};

export function SiteNav({ items }: { items: readonly NavItem[] }) {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 16);

    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });

    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <header className={`${styles.shell} ${scrolled ? styles.shellScrolled : ""}`}>
      <nav className={styles.nav} aria-label="Navegacion principal">
        <Link className={styles.logoLink} href="/#top" aria-label="DOMO inicio">
          <Wordmark />
        </Link>

        <div className={styles.links}>
          {items.map((item) => (
            <Link key={item.href} href={item.href}>
              {item.label}
            </Link>
          ))}
        </div>

        <Link className={styles.cta} href="/#registro">
          <span>Unete</span>
          <ArrowRight aria-hidden size={17} strokeWidth={2.4} />
        </Link>
      </nav>
    </header>
  );
}
