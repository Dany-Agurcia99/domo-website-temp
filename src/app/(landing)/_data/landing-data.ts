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
    title: "Profesionales verificados",
    description:
      "Cada proveedor pasa por revision de identidad, referencias y criterios de servicio antes de aceptar trabajos.",
  },
  {
    title: "Acuerdos sin sorpresas",
    description:
      "No se te cobrará hasta que tu trabajo quede como vos querés.",
  },
  {
    title: "Califica tu Tasker",
    description:
      "Deja tu opinión después de cada trabajo!",
  },
] as const;

export const landingCta = {
  availability: "Lugares limitados para fundadores",
  titleLead: "Únete al piloto.",
  titleHighlight: "Ayúdanos",
  titleTail: "a construirlo.",
  description:
    "Los primeros miembros reciben acceso anticipado y una sorpresa cuando domo active sus servicios ;).",
  cta: "Asegurar mi lugar",
} as const;
