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
            <h2>Reserva tu lugar en la primera ola de DOMO.</h2>
            <p>
              Estamos validando demanda por ciudad y tipo de servicio. Tu registro
              nos ayuda a priorizar zonas, horarios y categorias para el piloto.
            </p>
          </div>

          <PreregistrationForm />
        </div>
      </Container>
    </section>
  );
}
