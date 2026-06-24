"use client";

import type { StaticImageData } from "next/image";
import Image from "next/image";
import { useEffect, useRef, useState } from "react";

import appliancesIcon from "@/assets/appliances_icon.png";
import cleaningIcon from "@/assets/cleaning_icon.png";
import electricalIcon from "@/assets/electrical-icon.png";
import lockIcon from "@/assets/lock_icon.png";
import plumbingIcon from "@/assets/plumbing-icon.png";
import { Container } from "@/components/layout/container";
import { SectionHeader } from "@/components/ui/section-header";

import { landingServices } from "../../_data/landing-data";
import styles from "./services-section.module.css";

type Service = (typeof landingServices)[number];

const serviceImages: Record<Service["id"], StaticImageData> = {
  fontaneria: plumbingIcon,
  electricidad: electricalIcon,
  limpieza: cleaningIcon,
  cerrajeria: lockIcon,
  electrodomesticos: appliancesIcon,
};

const serviceVideos: Record<Service["id"], string> = {
  fontaneria: "/videos/plomeria.mp4",
  electricidad: "/videos/electricista%201.mp4",
  limpieza: "/videos/limpieza%20maybe.mp4",
  cerrajeria: "/videos/cerrajeria.mp4",
  electrodomesticos: "/videos/electrodomesticos%201.mp4",
};

export function ServicesSection() {
  const [activeService, setActiveService] = useState<Service["id"] | null>(
    null,
  );

  return (
    <section id="servicios" className={styles.section}>
      <Container>
        <SectionHeader eyebrow="Servicios">
          Todo para tu hogar, <span>en una sola app.</span>
        </SectionHeader>
      </Container>

      <div className={styles.grid} aria-label="Servicios domo">
        {landingServices.map((service) => (
          <ServiceTile
            key={service.id}
            service={service}
            active={activeService === service.id}
            onToggle={() =>
              setActiveService((current) =>
                current === service.id ? null : service.id,
              )
            }
          />
        ))}
      </div>

      <p className={styles.comingSoon}>Más servicios disponibles próximamente</p>
    </section>
  );
}

function ServiceTile({
  service,
  active,
  onToggle,
}: {
  service: Service;
  active: boolean;
  onToggle: () => void;
}) {
  const videoRef = useRef<HTMLVideoElement>(null);

  const playVideo = () => {
    void videoRef.current?.play().catch(() => undefined);
  };

  const resetVideo = () => {
    const video = videoRef.current;
    if (!video) return;

    video.pause();
    video.currentTime = 0;
  };

  useEffect(() => {
    if (active) playVideo();
    else resetVideo();
  }, [active]);

  return (
    <button
      type="button"
      className={`${styles.card} ${active ? styles.active : ""}`}
      aria-pressed={active}
      aria-label={`${service.title}: reproducir vista previa`}
      onClick={() => {
        if (window.matchMedia("(hover: none), (pointer: coarse)").matches) {
          onToggle();
        }
      }}
      onPointerEnter={(event) => {
        if (event.pointerType === "mouse") playVideo();
      }}
      onPointerLeave={(event) => {
        if (event.pointerType === "mouse") resetVideo();
      }}
      onFocus={playVideo}
      onBlur={resetVideo}
    >
      <video
        ref={videoRef}
        className={styles.serviceVideo}
        src={serviceVideos[service.id]}
        muted
        loop
        playsInline
        preload="metadata"
        aria-hidden="true"
      />
      <div className={styles.visual} aria-hidden>
        <Image
          className={styles.serviceIcon}
          src={serviceImages[service.id]}
          alt=""
        />
      </div>
      <h3>{service.title}</h3>
    </button>
  );
}
