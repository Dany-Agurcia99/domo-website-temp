import { z } from "zod";

import {
  hondurasDepartments,
  interestOptions,
  platformOptions,
} from "@/constants/site-text";

const hondurasPhoneRegex = /^\+504\d{8}$/;

export const preregistrationSchema = z.object({
  fullName: z
    .string()
    .min(3, "Ingresa al menos 3 caracteres en tu nombre.")
    .max(80, "El nombre no puede exceder 80 caracteres."),
  email: z.string().email("Ingresa un correo valido."),
  phone: z.union([
    z.literal(""),
    z.string().regex(
      hondurasPhoneRegex,
      "Ingresa un teléfono hondureño válido de 8 dígitos.",
    ),
  ]),
  department: z.enum(
    hondurasDepartments,
    "Selecciona un departamento válido.",
  ),
  platform: z.enum(platformOptions, "Selecciona una plataforma."),
  interest: z.enum(interestOptions, "Selecciona qué te interesa ser."),
});
