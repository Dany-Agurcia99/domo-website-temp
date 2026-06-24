# DOMO preregistro website

Landing page de preregistro para una app de servicios, construida con Next.js App Router.

## Arquitectura

- `src/app/(landing)/page.tsx`: entrada de la landing.
- `src/app/(landing)/_sections/registration/components/preregistration-form.tsx`: formulario interactivo.
- `src/app/(landing)/_sections/registration/actions/submit-preregistration.ts`: validacion e insercion segura en Supabase.
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
SUPABASE_SECRET_KEY=
```

3. Enlaza el proyecto y aplica las migraciones:

```bash
npx supabase link --project-ref TU_PROJECT_REF
npx supabase db push
```

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
- Mantener mutaciones de backend en Server Actions dentro de cada seccion.
