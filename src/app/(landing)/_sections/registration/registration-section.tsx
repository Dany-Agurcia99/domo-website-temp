import { Container } from "@/components/layout/container";

import { PreregistrationForm } from "./components/preregistration-form";
import styles from "./registration-section.module.css";

export function RegistrationSection() {
  return (
    <section id="registro" className={styles.section}>
      <Container>
        <div className={styles.grid}>
          <div className={styles.copy}>
            <p className={styles.eyebrow}>Registro</p>
            <h2>Reservá tu lugar</h2>
            <p>
              Estamos preparando el piloto. Tu registro nos ayuda a conocer
              cómo querés formar parte de domo.
            </p>
          </div>

          <PreregistrationForm />
        </div>
      </Container>
    </section>
  );
}
