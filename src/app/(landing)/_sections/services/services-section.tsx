import { Container } from "@/components/layout/container";
import { SectionHeader } from "@/components/ui/section-header";

import { landingServices } from "../../_data/landing-data";
import { serviceIcons } from "../../_data/service-icons";
import styles from "./services-section.module.css";

type Service = (typeof landingServices)[number];

export function ServicesSection() {
  return (
    <section id="servicios" className={styles.section}>
      <Container>
        <SectionHeader eyebrow="Servicios">
          Todo para tu hogar, <span>en una sola app.</span>
        </SectionHeader>
      </Container>

      <div className={styles.grid} aria-label="Servicios DOMO">
        {landingServices.map((service) => (
          <ServiceTile key={service.id} service={service} />
        ))}
      </div>
    </section>
  );
}

function ServiceTile({ service }: { service: Service }) {
  const Icon = serviceIcons[service.icon];

  return (
    <article className={styles.card}>
      <div className={styles.placeholder} aria-hidden>
        <Icon size={74} strokeWidth={1.7} />
      </div>

      <div className={styles.iconBadge} aria-hidden>
        <Icon size={24} strokeWidth={2.4} />
      </div>

      <div className={styles.content}>
        <h3>{service.title}</h3>
        <p>{service.description}</p>
      </div>
    </article>
  );
}
