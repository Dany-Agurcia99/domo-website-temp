import {
  BadgeCheck,
  CalendarClock,
  LayoutGrid,
} from "lucide-react";

import { landingSteps } from "../../../_data/landing-data";
import styles from "../how-it-works-section.module.css";

const stepIcons = {
  BadgeCheck,
  CalendarClock,
  LayoutGrid,
} as const;

type Step = (typeof landingSteps)[number];

export function StepCard({
  step,
  active,
  onSelect,
}: {
  step: Step;
  active: boolean;
  onSelect: () => void;
}) {
  const Icon = stepIcons[step.icon];

  return (
    <button
      type="button"
      className={`${styles.stepCard} ${active ? styles.stepCardActive : ""}`}
      onClick={onSelect}
      aria-pressed={active}
    >
      <span className={styles.stepNumber}>{step.number}</span>
      <span className={styles.stepIcon}>
        <Icon aria-hidden size={22} strokeWidth={2.4} />
      </span>
      <span className={styles.stepText}>
        <strong>{step.title}</strong>
        <span>{step.description}</span>
      </span>
    </button>
  );
}
