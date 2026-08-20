import { BadgeCheck, CalendarClock, LayoutGrid } from "lucide-react";

import styles from "../how-it-works-section.module.css";

const stepPreviews = [
  { icon: LayoutGrid, label: "Elegí un servicio" },
  { icon: BadgeCheck, label: "Elegí a tu especialista" },
  { icon: CalendarClock, label: "Agendá día y hora" },
] as const;

export function PhonePreview({ active }: { active: number }) {
  const preview = stepPreviews[active] ?? stepPreviews[0];
  const Icon = preview.icon;

  return (
    <div className={styles.phoneFrame} role="img" aria-label={preview.label}>
      <Icon
        key={active}
        className={styles.stepPreviewIcon}
        aria-hidden
        strokeWidth={1.5}
      />
    </div>
  );
}
