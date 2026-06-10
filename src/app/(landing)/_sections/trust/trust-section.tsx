import { Container } from "@/components/layout/container";
import { SectionHeader } from "@/components/ui/section-header";

import { landingTrustCards } from "../../_data/landing-data";
import styles from "./trust-section.module.css";

export function TrustSection() {
  return (
    <section id="confianza" className={styles.section}>
      <Container>
        <SectionHeader eyebrow="Confianza">
          Una app que se toma <span>en serio tu hogar.</span>
        </SectionHeader>
      </Container>

      <div className={styles.grid}>
        {landingTrustCards.map((card) => (
          <article key={card.title} className={styles.card}>
            <h3>{card.title}</h3>
            <p>{card.description}</p>
          </article>
        ))}
      </div>
    </section>
  );
}
