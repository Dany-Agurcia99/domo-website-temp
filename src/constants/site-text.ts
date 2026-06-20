export const siteText = {
  metadata: {
    title: "DOMO | Unete al piloto",
    description:
      "Pre-registro para el piloto de DOMO, la app hondurena de servicios para el hogar.",
  },
  badge: "Piloto fundador",
  hero: {
    eyebrow: "Servicios a domicilio sin friccion",
    title: "Preregistro abierto para la primera ola de usuarios DOMO",
    subtitle:
      "Dejanos tus datos para priorizar tu acceso al piloto en Honduras.",
    bullets: [
      "Alta prioridad para los primeros registros.",
      "Notificacion cuando abramos el piloto privado.",
      "Sin costo para reservar tu lugar.",
    ],
  },
  form: {
    title: "Reserva tu lugar",
    description:
      "Cuatro datos rapidos para avisarte cuando DOMO llegue a tu zona.",
    labels: {
      fullName: "Nombre completo",
      email: "Correo",
      phone: "Telefono",
      city: "Ciudad",
      serviceType: "Servicio principal",
      leadSource: "Como te enteraste de DOMO",
      details: "Comentarios opcionales",
    },
    placeholders: {
      fullName: "Ej: Ana Lopez",
      email: "tu-correo@dominio.com",
      phone: "+504 9999 9999",
      city: "Ej: Tegucigalpa",
      details: "Ej: Me interesa limpieza semanal en mi colonia.",
    },
    cta: "Asegurar mi lugar",
    pendingCta: "Enviando registro...",
    successMessage:
      "Tu registro fue recibido. Te contactaremos cuando abramos acceso.",
    invalidMessage: "Revisa los campos marcados e intenta de nuevo.",
    serverErrorMessage:
      "No pudimos guardar tu registro ahora. Intenta nuevamente en unos minutos.",
    missingConfigMessage:
      "Falta configurar Supabase para guardar registros. Revisa las variables de entorno.",
  },
  footer: "DOMO Honduras 2026",
} as const;

export const serviceOptions = [
  "Plomeria",
  "Limpieza",
  "Cerrajeria",
  "Electricidad",
  "Jardineria",
  "Otro",
] as const;

export const leadSourceOptions = [
  "Instagram",
  "TikTok",
  "Recomendacion",
  "Busqueda web",
  "WhatsApp",
  "Otro",
] as const;

export const siteFooterLinks = [
  { label: "Como funciona", href: "/#como-funciona" },
  { label: "Servicios", href: "/#servicios" },
  { label: "Confianza", href: "/#confianza" },
  { label: "Registro", href: "/#registro" },
  { label: "Contacto", href: "mailto:hola@domo.hn" },
] as const;

export const siteNavItems = siteFooterLinks.slice(0, 4);

export const siteSocialLinks = {
  facebook: "#",
  instagram: "#",
} as const;
