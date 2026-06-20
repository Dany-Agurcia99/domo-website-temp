import Link from "next/link";

import styles from "./site-footer.module.css";

type FooterLink = {
  href: string;
  label: string;
};

type SocialLinks = {
  facebook: string;
  instagram: string;
};

function FacebookIcon() {
  return (
    <svg aria-hidden viewBox="0 0 24 24" width="18" height="18">
      <path
        fill="currentColor"
        d="M14 8h3V4h-3c-3.3 0-5 2-5 5v2H6v4h3v7h4v-7h3l1-4h-4V9c0-.7.3-1 1-1Z"
      />
    </svg>
  );
}

function InstagramIcon() {
  return (
    <svg
      aria-hidden
      viewBox="0 0 24 24"
      width="18"
      height="18"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
    >
      <rect x="3" y="3" width="18" height="18" rx="5" />
      <circle cx="12" cy="12" r="4" />
      <circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none" />
    </svg>
  );
}

export function SiteFooter({
  links,
  socialLinks,
}: {
  links: readonly FooterLink[];
  socialLinks: SocialLinks;
}) {
  return (
    <footer className={styles.footer}>
      <nav className={styles.links} aria-label="Navegacion secundaria">
        {links.map((link) => (
          <Link key={link.href} href={link.href}>
            {link.label}
          </Link>
        ))}
      </nav>

      <div className={styles.wordmarkBackdrop} aria-hidden>
        domo
      </div>

      <div className={styles.bottom}>
        <nav className={styles.legalLinks} aria-label="Enlaces legales">
          <Link href="/terms">Terminos y Condiciones</Link>
          <Link href="/privacy">Politica de Privacidad</Link>
        </nav>

        <div className={styles.company}>
          <div className={styles.socialLinks}>
            <a href={socialLinks.facebook} aria-label="Facebook">
              <FacebookIcon />
            </a>
            <a href={socialLinks.instagram} aria-label="Instagram">
              <InstagramIcon />
            </a>
          </div>
          <span>Grupo NOMA © 2026</span>
        </div>
      </div>
    </footer>
  );
}
