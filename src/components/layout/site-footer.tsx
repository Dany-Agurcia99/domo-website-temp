import { Wordmark } from "@/components/brand/wordmark";

import styles from "./site-footer.module.css";

type FooterLink = {
  href: string;
  label: string;
};

export function SiteFooter({ links }: { links: readonly FooterLink[] }) {
  return (
    <footer className={styles.footer}>
      <div className={styles.top}>
        <a href="#top" aria-label="DOMO inicio">
          <Wordmark />
        </a>

        <nav className={styles.links} aria-label="Navegacion secundaria">
          {links.map((link) => (
            <a key={link.href} href={link.href}>
              {link.label}
            </a>
          ))}
        </nav>
      </div>

      <div className={styles.wordmarkBackdrop} aria-hidden>
        domo
      </div>

      <div className={styles.bottom}>
        <span>DOMO Honduras 2026</span>
        <span>Una empresa de Grupo NOMA</span>
      </div>
    </footer>
  );
}
