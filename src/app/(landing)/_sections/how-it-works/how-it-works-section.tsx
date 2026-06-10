"use client";

import { useEffect, useRef, useState } from "react";

import { Container } from "@/components/layout/container";
import { SectionHeader } from "@/components/ui/section-header";

import { landingSteps } from "../../_data/landing-data";
import { PhonePreview } from "./components/phone-preview";
import { StepCard } from "./components/step-card";
import styles from "./how-it-works-section.module.css";

export function HowItWorksSection() {
  const sectionRef = useRef<HTMLElement>(null);
  const [active, setActive] = useState(0);

  useEffect(() => {
    let frame = 0;

    const update = () => {
      if (frame) return;

      frame = window.requestAnimationFrame(() => {
        frame = 0;
        const section = sectionRef.current;

        if (!section) return;

        const rect = section.getBoundingClientRect();
        const scrollable = section.offsetHeight - window.innerHeight;
        const scrolled = Math.min(Math.max(-rect.top, 0), Math.max(scrollable, 1));
        const progress = scrollable > 0 ? scrolled / scrollable : 0;
        const nextIndex = Math.min(
          landingSteps.length - 1,
          Math.floor(progress * landingSteps.length * 0.999),
        );

        setActive(nextIndex);
      });
    };

    update();
    window.addEventListener("scroll", update, { passive: true });
    window.addEventListener("resize", update);

    return () => {
      window.removeEventListener("scroll", update);
      window.removeEventListener("resize", update);
      if (frame) window.cancelAnimationFrame(frame);
    };
  }, []);

  return (
    <section id="como-funciona" ref={sectionRef} className={styles.section}>
      <div className={styles.sticky}>
        <Container>
          <SectionHeader eyebrow="Como funciona" tone="dark">
            Tu hogar resuelto <span>en tres pasos.</span>
          </SectionHeader>

          <div className={styles.grid}>
            <div className={styles.stepList} aria-label="Pasos para usar DOMO">
              {landingSteps.map((step, index) => (
                <StepCard
                  key={step.number}
                  step={step}
                  active={active === index}
                  onSelect={() => setActive(index)}
                />
              ))}
            </div>

            <PhonePreview active={active} />
          </div>
        </Container>
      </div>
    </section>
  );
}
