import type { ReactNode } from "react";

import styles from "./section-header.module.css";

export function SectionHeader({
  eyebrow,
  children,
  tone = "light",
}: {
  eyebrow: string;
  children: ReactNode;
  tone?: "light" | "dark";
}) {
  return (
    <div className={styles.header}>
      <p className={tone === "dark" ? styles.eyebrowDark : styles.eyebrow}>
        {eyebrow}
      </p>
      <h2 className={tone === "dark" ? styles.titleDark : styles.title}>
        {children}
      </h2>
    </div>
  );
}
