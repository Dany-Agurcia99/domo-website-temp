import type { ReactNode } from "react";

import styles from "./button-link.module.css";

type ButtonLinkVariant = "primary" | "secondary";

export function ButtonLink({
  children,
  href,
  variant = "primary",
  className,
}: {
  children: ReactNode;
  href: string;
  variant?: ButtonLinkVariant;
  className?: string;
}) {
  const classes = [styles.button, styles[variant], className]
    .filter(Boolean)
    .join(" ");

  return (
    <a className={classes} href={href}>
      {children}
    </a>
  );
}
