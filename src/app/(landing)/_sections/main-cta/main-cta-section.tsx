import Image from "next/image";
import { ArrowRight } from "lucide-react";

import domoIsotipo from "@/assets/domo-isotipo-hd.png";
import { ButtonLink } from "@/components/ui/button-link";
import { Container } from "@/components/layout/container";

import { landingCta } from "../../_data/landing-data";
import styles from "./main-cta-section.module.css";

export function MainCtaSection() {
  return (
    <section id="piloto" className={styles.section}>
      <div className={styles.backdrop} aria-hidden>
        <Image
          className={styles.backdropImage}
          src={domoIsotipo}
          alt=""
          fill
          sizes="100vw"
          quality={100}
        />
      </div>
      <Container>
        <div className={styles.panel}>
          <p className={styles.availability}>
            <span aria-hidden />
            {landingCta.availability}
          </p>
          <h2>
            <span className={styles.titleDark}>{landingCta.titleLead}</span>{" "}
            <span className={styles.titleHighlight}>
              {landingCta.titleHighlight}
            </span>{" "}
            <span className={styles.titleDark}>{landingCta.titleTail}</span>
          </h2>
          <p>{landingCta.description}</p>
          <ButtonLink className={styles.ctaButton} href="#registro">
            {landingCta.cta}
            <ArrowRight aria-hidden size={20} strokeWidth={2.4} />
          </ButtonLink>
        </div>
      </Container>
    </section>
  );
}
