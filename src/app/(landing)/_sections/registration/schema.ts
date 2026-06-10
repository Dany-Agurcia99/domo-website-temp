import { z } from "zod";

const phoneRegex = /^\+?\d{8,15}$/;

export const preregistrationSchema = z.object({
  fullName: z
    .string()
    .min(3, "Ingresa al menos 3 caracteres en tu nombre.")
    .max(80, "El nombre no puede exceder 80 caracteres."),
  email: z.string().email("Ingresa un correo valido."),
  phone: z
    .string()
    .regex(phoneRegex, "El telefono debe tener entre 8 y 15 digitos."),
  city: z
    .string()
    .min(2, "Ingresa una ciudad valida.")
    .max(80, "La ciudad no puede exceder 80 caracteres."),
  serviceType: z
    .string()
    .min(1, "Selecciona un servicio.")
    .max(80, "Servicio invalido."),
  leadSource: z
    .string()
    .min(1, "Selecciona como nos conociste.")
    .max(80, "Origen invalido."),
  details: z.string().max(500, "El comentario no puede exceder 500 caracteres."),
});

export type PreregistrationPayload = z.infer<typeof preregistrationSchema>;
