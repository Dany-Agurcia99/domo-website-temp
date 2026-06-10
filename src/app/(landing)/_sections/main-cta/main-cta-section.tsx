import { ArrowRight } from "lucide-react";

import { ButtonLink } from "@/components/ui/button-link";
import { Container } from "@/components/layout/container";

import { landingCta } from "../../_data/landing-data";
import styles from "./main-cta-section.module.css";

export function MainCtaSection() {
  return (
    <section className={styles.section}>
      <div className={styles.backdrop} aria-hidden />
      <Container>
        <div className={styles.panel}>
          <p className={styles.availability}>
            <span aria-hidden />
            {landingCta.availability}
          </p>
          <h2>{landingCta.title}</h2>
          <p>{landingCta.description}</p>
          <ButtonLink href="#registro">
            {landingCta.cta}
            <ArrowRight aria-hidden size={20} strokeWidth={2.4} />
          </ButtonLink>
        </div>
      </Container>
    </section>
  );
}
