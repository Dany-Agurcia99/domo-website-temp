# DOMO preregistro website

Landing page de preregistro para una app de servicios, construida con Next.js App Router.

## Arquitectura

- `src/app/page.tsx`: Server Component (default) con contenido estatico de la landing.
- `src/features/preregistration/components/preregistration-form.tsx`: Client Component solo para interactividad de formulario.
- `src/features/preregistration/actions/submit-preregistration.ts`: Server Action para validacion + insercion en Supabase.
- `src/constants/theme.ts`: fuente unica de colores (background, outline, text, primary).
- `src/constants/site-text.ts`: textos del website centralizados.
- `src/utils/formatters.ts`: formatters y normalizacion de datos.

## Setup local

1. Instala dependencias:

```bash
npm install
```

2. Crea tu archivo `.env.local` tomando como base `.env.example`:

```bash
NEXT_PUBLIC_SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
SUPABASE_PREREGISTRATION_TABLE=preregistrations
```

3. Ejecuta el SQL de `supabase/preregistration.sql` en tu proyecto de Supabase.

4. Levanta el proyecto:

```bash
npm run dev
```

5. Abre `http://localhost:3000`.

## Flujo del formulario

1. El usuario completa el formulario en un Client Component.
2. El form envia a una Server Action (`submitPreregistration`).
3. Se normaliza y valida con `zod`.
4. Se guarda en Supabase y se retorna estado de exito/error.

## Convenciones de escalado

- Mantener todos los textos en `src/constants`.
- Mantener todos los colores solo en `src/constants/theme.ts`.
- Mantener formatters en `src/utils/formatters.ts`.
- Mantener mutaciones de backend en Server Actions dentro de `src/features/*/actions`.
