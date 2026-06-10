import styles from "./wordmark.module.css";

export function Wordmark({ className }: { className?: string }) {
  return (
    <span className={className ? `${styles.wordmark} ${className}` : styles.wordmark}>
      domo
    </span>
  );
}
