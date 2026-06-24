export const siteText = {
  metadata: {
    title: "domo | Unete al piloto",
    description:
      "Pre-registro para el piloto de domo, la app hondurena de servicios para el hogar.",
  },
  form: {
    title: "Reserva tu lugar",
    description:
      "Completa tus datos para avisarte cuando domo llegue a tu zona.",
    labels: {
      fullName: "Nombre",
      email: "Correo",
      phone: "Teléfono (opcional)",
      department: "Departamento",
      platform: "Plataforma",
      interest: "Me interesa ser",
    },
    placeholders: {
      fullName: "Ej: Ana Lopez",
      email: "tu-correo@dominio.com",
      phone: "+504 9999-9999",
      department: "Selecciona tu departamento",
    },
    cta: "Asegurar mi lugar",
    pendingCta: "Enviando registro...",
    successMessage:
      "Tu registro fue recibido. Te contactaremos cuando abramos acceso.",
    invalidMessage: "Revisa los campos marcados e intenta de nuevo.",
    rateLimitMessage:
      "Has realizado varios intentos. Espera unos minutos antes de intentarlo nuevamente.",
    serverErrorMessage:
      "No pudimos guardar tu registro ahora. Intenta nuevamente en unos minutos.",
    missingConfigMessage:
      "Falta configurar Supabase para guardar registros. Revisa las variables de entorno.",
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
