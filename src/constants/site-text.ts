export const siteText = {
  metadata: {
    title: "domo | Únete al piloto",
    description:
      "Pre-registro para el piloto de domo, la app hondureña de servicios para el hogar.",
  },
  form: {
    title: "Reservá tu lugar",
    description:
      "Completá tus datos para avisarte cuando domo llegue a tu zona.",
    labels: {
      fullName: "Nombre",
      email: "Correo",
      phone: "Teléfono (opcional)",
      department: "Departamento",
      platform: "Plataforma",
      interest: "Me interesa ser",
    },
    placeholders: {
      fullName: "Ej: Ana López",
      email: "tu-correo@dominio.com",
      phone: "+504 9999-9999",
      department: "Seleccioná tu departamento",
    },
    cta: "Unirme al piloto",
    pendingCta: "Enviando registro...",
    successMessage:
      "Tu registro fue recibido. Te contactaremos cuando abramos el acceso.",
    invalidMessage: "Revisá los campos marcados e intentá de nuevo.",
    rateLimitMessage:
      "Hiciste varios intentos. Esperá unos minutos antes de intentarlo nuevamente.",
    serverErrorMessage:
      "No pudimos guardar tu registro ahora. Intentá nuevamente en unos minutos.",
    missingConfigMessage:
      "Falta configurar Supabase para guardar registros. Revisá las variables de entorno.",
  },
} as const;

export const hondurasDepartments = [
  "Atlántida",
  "Choluteca",
  "Colón",
  "Comayagua",
  "Copán",
  "Cortés",
  "El Paraíso",
  "Francisco Morazán",
  "Gracias a Dios",
  "Intibucá",
  "Islas de la Bahía",
  "La Paz",
  "Lempira",
  "Ocotepeque",
  "Olancho",
  "Santa Bárbara",
  "Valle",
  "Yoro",
] as const;

export const platformOptions = ["iOS", "Android"] as const;

export const interestOptions = ["Cliente", "Tasker", "Ambos"] as const;

export const siteFooterLinks = [
  { label: "Inicio", href: "/#top" },
  { label: "Servicios", href: "/#servicios" },
  { label: "Cómo funciona", href: "/#como-funciona" },
  { label: "Confianza", href: "/#confianza" },
  { label: "Taskers", href: "/#taskers" },
  { label: "Únete al piloto", href: "/#piloto" },
  { label: "Registro", href: "/#registro" },
] as const;

export const siteNavItems = siteFooterLinks;

export const siteSocialLinks = {
  facebook:
    "https://www.instagram.com/domoapphn/?utm_source=ig_web_button_share_sheet",
  instagram:
    "https://www.instagram.com/domoapphn/?utm_source=ig_web_button_share_sheet",
} as const;
