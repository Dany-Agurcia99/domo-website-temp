export const landingHero = {
  description:
    "Encuentra profesionales cercanos para reparaciones y mejoras, todo en un mismo lugar.",
  cta: "Unirse al Piloto",
} as const;

export const landingServices = [
  {
    id: "fontaneria",
    title: "Fontaneria",
  },
  {
    id: "electricidad",
    title: "Electricidad",
  },
  {
    id: "limpieza",
    title: "Limpieza",
  },
  {
    id: "cerrajeria",
    title: "Cerrajeria",
  },
  {
    id: "electrodomesticos",
    title: "Electrodomesticos",
  },
] as const;

export const landingSteps = [
  {
    number: "01",
    title: "Elegí un servicio",
    description:
      "Escoge la categoría que necesites y describe tu solicitud.",
    icon: "LayoutGrid",
  },
  {
    number: "02",
    title: "Escoge tu especialista",
    description:
      "Compara profesionales verificados que más se ajuste a tu situación.",
    icon: "BadgeCheck",
  },
  {
    number: "03",
    title: "Agenda día y hora",
    description:
      "Elige día y hora según a tu conveniencia.",
    icon: "CalendarClock",
  },
] as const;

export const landingTrustCards = [
  {
    title: "Perfil verificado",
    description:
      "Cada tasker valida su identidad, experiencia y referencias antes de ofrecer servicios en domo.",
    icon: "ShieldCheck",
  },
  {
    title: "Pago sin sorpresas",
    description:
      "El pago se confirma solo cuando el trabajo esté como acordaron y tú des tu aprobación final.",
    icon: "ReceiptText",
  },
  {
    title: "Califica tu experiencia",
    description:
      "Al finalizar, puedes valorar el servicio y compartir tu opinión para ayudar a otros clientes.",
    icon: "Star",
  },
  {
    title: "Soporte siempre cerca",
    description:
      "Si surge algún inconveniente, nuestro equipo te acompaña para resolverlo de forma rápida y clara.",
    icon: "Headset",
  },
] as const;

export const landingTaskerTrustCards = [
  {
    title: "Seguridad de pagos",
    description:
      "Tu pago se libera al finalizar el trabajo, con reglas claras para que cobres a tiempo.",
    icon: "WalletCards",
  },
  {
    title: "Mayor visibilidad",
    description:
      "Cada buen servicio mejora tu reputación y te ayuda a conseguir más solicitudes dentro de la app.",
    icon: "Megaphone",
  },
  {
    title: "Trabajo a tu ritmo",
    description:
      "Tú eliges horarios, clientes y tipos de trabajo para construir tu crecimiento como tasker.",
    icon: "Clock3",
  },
  {
    title: "Respaldo constante",
    description:
      "No trabajas solo: cuentas con soporte y herramientas para seguir creciendo paso a paso.",
    icon: "Handshake",
  },
] as const;

export const landingCta = {
  availability: "Usuarios registrados:",
  titleLead: "Únete al piloto.",
  titleHighlight: "Ayúdanos",
  titleTail: "a construirlo.",
  description:
    "Los primeros miembros reciben acceso anticipado y una sorpresa cuando domo active sus servicios ;).",
  cta: "Asegurar mi lugar",
} as const;
