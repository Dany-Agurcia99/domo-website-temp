export const landingHero = {
  eyebrow: "Piloto en Honduras",
  titleLead: "La app que arregla tu hogar",
  highlightedTitle: "en un solo toque.",
  description:
    "Plomeria, limpieza, electricidad, cerrajeria y mas. Profesionales verificados, precio acordado y una experiencia pensada para dejar atras los grupos de WhatsApp.",
  cta: "Unete al piloto",
  secondaryCta: "Ver como funciona",
} as const;

export const landingServices = [
  {
    id: "plomeria",
    title: "Plomeria",
    description: "Fugas, instalaciones, calentadores y reparaciones del dia a dia.",
    icon: "Wrench",
  },
  {
    id: "limpieza",
    title: "Limpieza",
    description: "Limpieza recurrente, profunda y apoyo despues de mudanzas.",
    icon: "BrushCleaning",
  },
  {
    id: "cerrajeria",
    title: "Cerrajeria",
    description: "Cambios de chapa, aperturas y soporte rapido para accesos.",
    icon: "KeyRound",
  },
  {
    id: "electricidad",
    title: "Electricidad",
    description: "Instalaciones, diagnosticos y mantenimiento electrico seguro.",
    icon: "Zap",
  },
  {
    id: "jardineria",
    title: "Jardineria",
    description: "Cuidado exterior, mantenimiento verde y arreglos puntuales.",
    icon: "Sprout",
  },
] as const;

export const landingSteps = [
  {
    number: "01",
    title: "Elegi un servicio",
    description:
      "Escoge la categoria que necesitas y describe el trabajo en minutos.",
    icon: "LayoutGrid",
  },
  {
    number: "02",
    title: "Agenda dia y hora",
    description:
      "Reserva el momento que mejor te queda sin llamadas ni vueltas.",
    icon: "CalendarClock",
  },
  {
    number: "03",
    title: "Recibi especialistas",
    description:
      "Compara profesionales verificados con precio claro desde el inicio.",
    icon: "BadgeCheck",
  },
] as const;

export const landingTrustCards = [
  {
    title: "Profesionales verificados",
    description:
      "Cada proveedor pasa por revision de identidad, referencias y criterios de servicio antes de aceptar trabajos.",
  },
  {
    title: "Precio claro",
    description:
      "Acordas el alcance antes de confirmar para reducir sorpresas y mensajes interminables.",
  },
  {
    title: "Primero Tegucigalpa",
    description:
      "El piloto inicia en la capital y se expande zona por zona segun demanda registrada.",
  },
] as const;

export const landingCta = {
  availability: "Lugares limitados para fundadores",
  title: "Unete al piloto. Ayudanos a construirlo.",
  description:
    "Los primeros miembros reciben acceso anticipado y prioridad cuando DOMO active su primera ola de servicios.",
  cta: "Asegurar mi lugar",
} as const;
