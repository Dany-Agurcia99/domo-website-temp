import { ArrowRight, Clock3, MapPin, ShieldCheck } from "lucide-react";

import { ButtonLink } from "@/components/ui/button-link";
import { Container } from "@/components/layout/container";

import { landingHero, landingServices } from "../../_data/landing-data";
import { serviceIcons } from "../../_data/service-icons";
import styles from "./hero-section.module.css";

const heroProofPoints = [
  { icon: ShieldCheck, label: "Verificacion de identidad" },
  { icon: Clock3, label: "Reserva sin llamadas" },
  { icon: MapPin, label: "Piloto en Tegucigalpa" },
] as const;

export function HeroSection() {
  return (
    <section id="top" className={styles.section}>
      <div className={styles.glow} aria-hidden />
      <Container>
        <div className={styles.grid}>
          <div className={styles.copy}>
            <p className={styles.eyebrow}>{landingHero.eyebrow}</p>
            <h1 className={styles.title}>
              {landingHero.titleLead} <span>{landingHero.highlightedTitle}</span>
            </h1>
            <p className={styles.description}>{landingHero.description}</p>

            <div className={styles.actions}>
              <ButtonLink href="#registro">
                {landingHero.cta}
                <ArrowRight aria-hidden size={20} strokeWidth={2.4} />
              </ButtonLink>
              <ButtonLink href="#como-funciona" variant="secondary">
                {landingHero.secondaryCta}
              </ButtonLink>
            </div>

            <ul className={styles.proofList} aria-label="Beneficios DOMO">
              {heroProofPoints.map(({ icon: Icon, label }) => (
                <li key={label}>
                  <Icon aria-hidden size={18} strokeWidth={2.3} />
                  <span>{label}</span>
                </li>
              ))}
            </ul>
          </div>

          <div className={styles.visual} aria-hidden>
            <div className={styles.markWrap}>
              <div className={styles.mockPanel}>
                <div className={styles.mockHeader}>
                  <span>domo</span>
                  <strong>Piloto</strong>
                </div>

                <div className={styles.mockSearch}>
                  <MapPin aria-hidden size={18} strokeWidth={2.4} />
                  <span>Tegucigalpa</span>
                </div>

                <div className={styles.mockGrid}>
                  {landingServices.slice(0, 4).map((service) => {
                    const Icon = serviceIcons[service.icon];

                    return (
                      <div key={service.id} className={styles.mockService}>
                        <Icon aria-hidden size={24} strokeWidth={2.2} />
                        <span>{service.title}</span>
                      </div>
                    );
                  })}
                </div>

                <div className={styles.mockProvider}>
                  <span>CR</span>
                  <div>
                    <strong>Profesional verificado</strong>
                    <small>Disponible hoy 10:30 AM</small>
                  </div>
                </div>
              </div>
            </div>
            <div className={styles.floatCard}>
              <span>DOMO</span>
              <strong>Founders pilot</strong>
            </div>
          </div>
        </div>
      </Container>
    </section>
  );
}
