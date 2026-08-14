import { Container } from "@/components/layout/container";
import { SectionHeader } from "@/components/ui/section-header";
import { Headset, ReceiptText, ShieldCheck, Star } from "lucide-react";

import { landingTrustCards } from "../../_data/landing-data";
import styles from "./trust-section.module.css";

const trustIcons = {
  Headset,
  ReceiptText,
  ShieldCheck,
  Star,
} as const;

export function TrustSection() {
  return (
    <section id="confianza" className={styles.section}>
      <Container>
        <SectionHeader eyebrow="Confianza">
          Garantizá tu <span>satisfacción!</span>
        </SectionHeader>
      </Container>

      <div className={styles.grid}>
        {landingTrustCards.map((card) => {
          const Icon = trustIcons[card.icon];

          return (
            <article key={card.title} className={styles.card}>
              <span className={styles.iconWrap}>
                <Icon aria-hidden size={36} strokeWidth={2.15} />
              </span>
              <div className={styles.content}>
                <h3>{card.title}</h3>
                <p>{card.description}</p>
              </div>
            </article>
          );
        })}
      </div>
    </section>
  );
}
