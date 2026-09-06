import Image from "next/image";
import { ArrowRight } from "lucide-react";
import { unstable_noStore as noStore } from "next/cache";

import domoIsotipo from "@/assets/domo-isotipo-hd.png";
import { ButtonLink } from "@/components/ui/button-link";
import { Container } from "@/components/layout/container";
import { getPreregistrationCount } from "@/lib/domo-api";

import { landingCta } from "../../_data/landing-data";
import styles from "./main-cta-section.module.css";

const founderOffset = 350;

async function getFounderCount(): Promise<number | null> {
  noStore();

  try {
    return (await getPreregistrationCount()) + founderOffset;
  } catch (error) {
    console.error("[main-cta] failed to fetch preregistration count", error);
    return null;
  }
}

export async function MainCtaSection() {
  const founderCount = await getFounderCount();

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
            {founderCount !== null ? ` ${founderCount}` : ""}
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
