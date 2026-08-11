import { Container } from "@/components/layout/container";
import { SectionHeader } from "@/components/ui/section-header";
import { Clock3, Handshake, Megaphone, WalletCards } from "lucide-react";

import { landingTaskerTrustCards } from "../../_data/landing-data";
import styles from "./tasker-trust-section.module.css";

const taskerIcons = {
  Clock3,
  Handshake,
  Megaphone,
  WalletCards,
} as const;

export function TaskerTrustSection() {
  return (
    <section id="taskers" className={styles.section}>
      <Container>
        <SectionHeader eyebrow="Taskers">
          Crece con <span>respaldo real</span>
        </SectionHeader>
      </Container>

      <div className={styles.grid}>
        {landingTaskerTrustCards.map((card) => {
          const Icon = taskerIcons[card.icon];

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
