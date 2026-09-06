# Domo Website

Frontend web de Domo construido con Next.js App Router. El backend y la API
compartidos viven en el repositorio `domo-server`.

## Arquitectura

- `src/app/(landing)/page.tsx`: entrada de la landing.
- `src/app/(landing)/_sections/registration/components/preregistration-form.tsx`: formulario interactivo.
- `src/app/(landing)/_sections/registration/actions/submit-preregistration.ts`: validación del formulario y consumo de la API.
- `src/lib/domo-api.ts`: cliente de la API pública expuesta por `domo-server`.
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
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=
```

3. Levanta el proyecto:

```bash
npm run dev
```

4. Abre `http://localhost:3000`.

## Flujo del formulario

1. El usuario completa el formulario en un Client Component.
2. El formulario ejecuta la acción cliente `submitPreregistration`.
3. Se normaliza y valida con `zod`.
4. La acción consume la Edge Function `preregistration` de `domo-server`.
5. El server aplica nuevamente validación, rate limit e inserción.

## Convenciones de escalado

- Mantener todos los textos en `src/constants`.
- Mantener todos los colores solo en `src/constants/theme.ts`.
- Mantener formatters en `src/utils/formatters.ts`.
- Mantener adaptadores de formulario junto a cada sección.
- Mantener migraciones, RLS, secretos y Edge Functions exclusivamente en `domo-server`.
