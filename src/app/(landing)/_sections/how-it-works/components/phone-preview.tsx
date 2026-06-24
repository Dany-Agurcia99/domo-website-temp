import Image from "next/image";

import mockScreenshot from "@/assets/mock-screenshot.png";

import styles from "../how-it-works-section.module.css";

const stepScreenshots = [mockScreenshot, mockScreenshot, mockScreenshot] as const;

export function PhonePreview({ active }: { active: number }) {
  return (
    <div className={styles.phoneFrame}>
      <Image
        key={active}
        className={styles.mockScreenshot}
        src={stepScreenshots[active]}
        alt={`Captura de la app domo para el paso ${active + 1}`}
      />
    </div>
  );
}
