import Image from "next/image";

import domoIcon from "@/assets/domo-icon-white.png";
import { ButtonLink } from "@/components/ui/button-link";

import { landingHero } from "../../_data/landing-data";
import styles from "./hero-section.module.css";

export function HeroSection() {
  return (
    <section id="top" className={styles.section}>
      <div className={styles.content}>
        <Image
          className={styles.icon}
          src={domoIcon}
          alt=""
          aria-hidden="true"
          priority
        />

        <h1 className={styles.title}>
          <span className={styles.firstLine}>soluciones más rápidas</span>
          <span className={styles.secondLine}>
            <span className={styles.greenText}>para tu hogar</span>
          </span>
        </h1>

        <p className={styles.description}>{landingHero.description}</p>

        <ButtonLink className={styles.cta} href="#registro">
          {landingHero.cta}
        </ButtonLink>
      </div>
    </section>
  );
}
