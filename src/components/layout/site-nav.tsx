"use client";

import { useEffect, useState } from "react";
import { Menu, X } from "lucide-react";
import Image from "next/image";
import Link from "next/link";

import domoLogo from "@/assets/domo-logo-white-nobackground.png";

import styles from "./site-nav.module.css";

type NavItem = {
  href: string;
  label: string;
};

export function SiteNav({ items }: { items: readonly NavItem[] }) {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 16);

    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });

    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    if (!menuOpen) return;

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape") setMenuOpen(false);
    };

    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [menuOpen]);

  return (
    <header className={`${styles.shell} ${scrolled ? styles.shellScrolled : ""}`}>
      <nav className={styles.nav} aria-label="Navegacion principal">
        <Link
          className={styles.logoLink}
          href="/#top"
          aria-label="domo inicio"
          onClick={() => setMenuOpen(false)}
        >
          <Image
            className={styles.logo}
            src={domoLogo}
            alt="domo"
            priority
          />
        </Link>

        <div className={styles.links}>
          {items.map((item) => (
            <Link key={item.href} href={item.href}>
              {item.label}
            </Link>
          ))}
        </div>

        <button
          className={styles.menuToggle}
          type="button"
          aria-label={menuOpen ? "Cerrar menu" : "Abrir menu"}
          aria-controls="mobile-navigation"
          aria-expanded={menuOpen}
          onClick={() => setMenuOpen((open) => !open)}
        >
          {menuOpen ? (
            <X aria-hidden size={25} strokeWidth={2.2} />
          ) : (
            <Menu aria-hidden size={27} strokeWidth={2.2} />
          )}
        </button>

        {menuOpen && (
          <div id="mobile-navigation" className={styles.mobileMenu}>
            {items.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setMenuOpen(false)}
              >
                {item.label}
              </Link>
            ))}
          </div>
        )}
      </nav>
    </header>
  );
}
