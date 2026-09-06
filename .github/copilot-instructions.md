# Contrato de frontend - Domo Website

Este repositorio contiene exclusivamente el website de Domo construido con
Next.js. `domo-server` es la fuente de verdad del backend compartido por el
website, la app móvil y el dashboard.

## Límites

- No agregues migraciones, RLS, funciones SQL, Edge Functions ni configuración
  de Supabase en este repositorio.
- No uses `service_role`, secret keys ni acceso privilegiado a tablas.
- Las mutaciones se realizan contra APIs o RPC públicas definidas en
  `domo-server`; el website solo adapta formularios y experiencia de usuario.
- Solo se permiten variables públicas necesarias para consumir el backend.
- Todo cambio de contrato debe coordinarse con `domo-server`.

## Validación

Ejecuta `npm run lint` y `npm run build` antes de cerrar cambios funcionales.