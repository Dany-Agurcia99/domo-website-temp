import { CheckCircle2, Star } from "lucide-react";

import { landingServices } from "../../../_data/landing-data";
import { serviceIcons } from "../../../_data/service-icons";
import styles from "../how-it-works-section.module.css";

export function PhonePreview({ active }: { active: number }) {
  return (
    <div
      className={styles.phoneFrame}
      role="img"
      aria-label="Vista previa de la app DOMO"
    >
      <div className={styles.phoneNotch} aria-hidden />
      <div className={styles.phoneScreen}>
        <div className={styles.phoneStatus}>
          <span>8:42</span>
          <span>DOMO</span>
        </div>

        <div className={styles.phoneContent}>
          {active === 0 ? <CategoriesScreen /> : null}
          {active === 1 ? <ScheduleScreen /> : null}
          {active === 2 ? <ProsScreen /> : null}
        </div>
      </div>
    </div>
  );
}

function CategoriesScreen() {
  return (
    <div className={styles.appScreen}>
      <div className={styles.appScreenHead}>
        <span>Categorias</span>
        <small>Ver mas</small>
      </div>
      <div className={styles.appCategoryGrid}>
        {landingServices.slice(0, 4).map((service) => {
          const Icon = serviceIcons[service.icon];

          return (
            <div key={service.id} className={styles.appCategory}>
              <span>
                <Icon aria-hidden size={34} strokeWidth={2} />
              </span>
              <strong>{service.title}</strong>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function ScheduleScreen() {
  const days = ["Lun", "Mar", "Mie", "Jue", "Vie"];
  const times = ["9:00", "10:30", "12:00", "2:00", "4:30", "6:00"];

  return (
    <div className={styles.appScreen}>
      <div className={styles.appScreenHead}>
        <span>Agenda tu visita</span>
      </div>
      <div className={styles.dayGrid}>
        {days.map((day, index) => (
          <span key={day} className={index === 2 ? styles.activeDay : ""}>
            <small>{day}</small>
            <strong>{index + 1}</strong>
          </span>
        ))}
      </div>
      <div className={styles.timeGrid}>
        {times.map((time, index) => (
          <span key={time} className={index === 1 ? styles.activeTime : ""}>
            {time}
          </span>
        ))}
      </div>
    </div>
  );
}

function ProsScreen() {
  return (
    <div className={styles.appScreen}>
      <div className={styles.appScreenHead}>
        <span>Especialistas</span>
        <small>Cerca de vos</small>
      </div>
      {["Carlos Reyes", "Maria Banegas"].map((name, index) => (
        <article key={name} className={styles.proCard}>
          <div className={styles.proAvatar}>{index === 0 ? "CR" : "MB"}</div>
          <div>
            <strong>{name}</strong>
            <span>
              <Star aria-hidden size={13} fill="currentColor" />
              {index === 0 ? "4.9" : "5.0"} verificado
            </span>
            <small>
              <CheckCircle2 aria-hidden size={13} />
              Precio claro antes de confirmar
            </small>
          </div>
        </article>
      ))}
    </div>
  );
}
