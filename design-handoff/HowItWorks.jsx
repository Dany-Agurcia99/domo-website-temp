/* =========================================================================
   DOMO — Colors & Type tokens
   Honduras-based home-services super-app.
   Palette derived from the official "Logo_horizontal_azul.png":
     - Navy   #111627  (wordmark, primary text, dark UI)
     - DeepTeal #19535A (mark gradient endpoint, primary accent)
   Imported by every preview / UI kit file.
   ========================================================================= */

/* --- Web fonts (Google Fonts — see README "Fonts" section for substitution notes) --- */
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

:root {
  /* ============ Brand core (logo-derived) ============ */
  --domo-navy:       #111627;   /* wordmark, primary text, dark surfaces */
  --domo-navy-soft:  #1A2238;
  --domo-deep-teal:  #19535A;   /* mark gradient endpoint, primary accent */

  /* gradient used on the mark itself (and hero panels) */
  --domo-gradient: linear-gradient(135deg, #111627 0%, #15323F 45%, #19535A 100%);
  --domo-gradient-soft: linear-gradient(135deg, #1A2238 0%, #1B3F4A 60%, #2B7F84 100%);

  /* secondary "lime" gradient — taken from the icon@3x background. Used very sparingly,
     e.g. for the iOS app-icon tile or social posts. NOT a UI accent. */
  --domo-lime-gradient: linear-gradient(135deg, #BCD476 0%, #93CC95 55%, #73C3AF 100%);
  --domo-lime: #BCD476;
  --domo-mint: #73C3AF;

  /* ============ Teal scale (extended from #19535A) ============ */
  --domo-teal-50:  #E8F4F4;     /* mint wash */
  --domo-teal-100: #CDE7E8;
  --domo-teal-200: #9CCFD1;
  --domo-teal-300: #5EAEB1;
  --domo-teal-400: #2B7F84;     /* hover / lifted teal */
  --domo-teal-500: #19535A;     /* primary action */
  --domo-teal-600: #134349;
  --domo-teal-700: #0E3338;
  --domo-teal-800: #082226;

  /* ============ Neutrals (ink scale rooted in the navy) ============ */
  --domo-ink-900: #0A0F1C;
  --domo-ink-800: #111627;      /* same as --domo-navy — primary text */
  --domo-ink-700: #1F2A3D;
  --domo-ink-600: #3A465B;
  --domo-ink-500: #5C677B;      /* muted text */
  --domo-ink-400: #8A93A4;
  --domo-ink-300: #BAC1CC;
  --domo-ink-200: #DBDEE5;
  --domo-ink-100: #EEF0F4;
  --domo-ink-50:  #F6F7F9;

  --domo-sand-50:  #FCFAF4;
  --domo-sand-100: #F8F4E9;     /* "soft beige" — section backgrounds */
  --domo-sand-200: #F0E9D4;
  --domo-sand-300: #E4D9B8;
  --domo-sand-400: #D6C594;

  --domo-white:    #FFFFFF;

  /* ============ Semantic ============ */
  --domo-success:  #1F8E6A;
  --domo-warning:  #E59B2A;
  --domo-danger:   #D7463A;
  --domo-info:     var(--domo-deep-teal);
  --domo-star:     #F2C744;     /* 5-star yellow in testimonials */

  /* ============ Foreground / Background aliases ============ */
  --fg-1: var(--domo-navy);     /* primary text */
  --fg-2: var(--domo-ink-600);  /* secondary text */
  --fg-3: var(--domo-ink-500);  /* tertiary / captions */
  --fg-on-accent: var(--domo-white);
  --fg-on-dark: var(--domo-white);
  --fg-inverse: var(--domo-white);

  --bg-1: var(--domo-white);    /* default page background */
  --bg-2: var(--domo-sand-100); /* alternate section background */
  --bg-3: var(--domo-ink-50);   /* neutral panel */
  --bg-dark: var(--domo-navy);
  --bg-darker: var(--domo-ink-900);

  --accent: var(--domo-deep-teal);
  --accent-hover: var(--domo-teal-400);
  --accent-pressed: var(--domo-teal-600);
  --accent-soft: var(--domo-teal-50);

  /* ============ Borders & dividers ============ */
  --border-1: rgba(17, 22, 39, 0.08);
  --border-2: rgba(17, 22, 39, 0.14);
  --border-3: rgba(17, 22, 39, 0.24);
  --border-on-dark: rgba(255, 255, 255, 0.16);

  /* ============ Radii ============ */
  --r-xs: 6px;
  --r-sm: 10px;
  --r-md: 14px;                 /* default card */
  --r-lg: 20px;                 /* prominent card */
  --r-xl: 28px;
  --r-pill: 999px;

  /* ============ Spacing scale (8pt-ish) ============ */
  --s-1: 4px;
  --s-2: 8px;
  --s-3: 12px;
  --s-4: 16px;
  --s-5: 20px;
  --s-6: 24px;
  --s-7: 32px;
  --s-8: 40px;
  --s-9: 56px;
  --s-10: 72px;
  --s-11: 96px;
  --s-12: 128px;

  /* ============ Shadows ============ */
  --shadow-1: 0 1px 2px rgba(17, 22, 39, 0.05), 0 1px 1px rgba(17, 22, 39, 0.03);
  --shadow-2: 0 6px 16px -8px rgba(17, 22, 39, 0.18), 0 2px 4px rgba(17, 22, 39, 0.05);
  --shadow-3: 0 18px 40px -18px rgba(17, 22, 39, 0.22), 0 6px 14px -6px rgba(17, 22, 39, 0.08);
  --shadow-4: 0 30px 60px -24px rgba(17, 22, 39, 0.30), 0 12px 24px -10px rgba(17, 22, 39, 0.10);
  --shadow-accent: 0 14px 28px -10px rgba(25, 83, 90, 0.45);
  --shadow-inset: inset 0 1px 0 rgba(255, 255, 255, 0.6);

  --overlay-hero: linear-gradient(180deg, rgba(10, 15, 28, 0.20) 0%, rgba(10, 15, 28, 0.55) 55%, rgba(10, 15, 28, 0.82) 100%);

  /* ============ Type families ============ */
  --font-display: 'Outfit', 'Plus Jakarta Sans', system-ui, sans-serif;
  --font-sans: 'Plus Jakarta Sans', system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace;

  /* ============ Type scale ============ */
  --t-display-1: 64px;
  --t-display-2: 52px;
  --t-h1: 40px;
  --t-h2: 32px;
  --t-h3: 24px;
  --t-h4: 20px;
  --t-body-lg: 18px;
  --t-body: 16px;
  --t-body-sm: 14px;
  --t-caption: 12px;
  --t-overline: 11px;

  --lh-tight: 1.05;
  --lh-snug: 1.18;
  --lh-base: 1.5;
  --lh-loose: 1.65;

  --tracking-tight: -0.02em;
  --tracking-snug: -0.01em;
  --tracking-wide: 0.04em;
  --tracking-wider: 0.12em;

  /* ============ Motion ============ */
  --ease-standard: cubic-bezier(0.2, 0.7, 0.2, 1);
  --ease-out-soft: cubic-bezier(0.16, 1, 0.3, 1);
  --dur-fast: 120ms;
  --dur-base: 220ms;
  --dur-slow: 360ms;
}

/* =========================================================================
   Semantic element styles
   ========================================================================= */

.domo-display-1, h1.domo-display {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: var(--t-display-1);
  line-height: var(--lh-tight);
  letter-spacing: var(--tracking-tight);
  color: var(--fg-1);
}

.domo-h1, h1 {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: var(--t-h1);
  line-height: var(--lh-snug);
  letter-spacing: var(--tracking-tight);
  color: var(--fg-1);
}

.domo-h2, h2 {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: var(--t-h2);
  line-height: var(--lh-snug);
  letter-spacing: var(--tracking-snug);
  color: var(--fg-1);
}

.domo-h3, h3 {
  font-family: var(--font-display);
  font-weight: 600;
  font-size: var(--t-h3);
  line-height: var(--lh-snug);
  color: var(--fg-1);
}

.domo-h4, h4 {
  font-family: var(--font-display);
  font-weight: 600;
  font-size: var(--t-h4);
  line-height: var(--lh-snug);
  color: var(--fg-1);
}

.domo-lead, .lead {
  font-family: var(--font-sans);
  font-weight: 400;
  font-size: var(--t-body-lg);
  line-height: var(--lh-loose);
  color: var(--fg-2);
}

.domo-body, p {
  font-family: var(--font-sans);
  font-weight: 400;
  font-size: var(--t-body);
  line-height: var(--lh-base);
  color: var(--fg-1);
}

.domo-small, small {
  font-family: var(--font-sans);
  font-size: var(--t-body-sm);
  line-height: var(--lh-base);
  color: var(--fg-2);
}

.domo-caption {
  font-family: var(--font-sans);
  font-size: var(--t-caption);
  line-height: 1.4;
  color: var(--fg-3);
}

.domo-overline {
  font-family: var(--font-sans);
  font-weight: 700;
  font-size: var(--t-overline);
  letter-spacing: var(--tracking-wider);
  text-transform: uppercase;
  color: var(--accent);
}

.domo-code, code, kbd {
  font-family: var(--font-mono);
  font-size: 0.92em;
  background: var(--bg-3);
  padding: 2px 6px;
  border-radius: var(--r-xs);
  color: var(--fg-1);
}

::selection {
  background: var(--domo-teal-100);
  color: var(--domo-navy);
}

/* =========================================================================
   Logo helpers — use the official PNG, no SVG approximation.
   Apply .on-dark to flip to white silhouette for use on dark backgrounds.
   ========================================================================= */
.domo-logo-img,
.domo-mark-img,
.domo-wordmark-img {
  display: inline-block;
  height: auto;
  user-select: none;
}
.domo-logo-img.on-dark,
.domo-mark-img.on-dark,
.domo-wordmark-img.on-dark {
  filter: brightness(0) invert(1);
}
.domo-logo-img.on-sand,
.domo-mark-img.on-sand,
.domo-wordmark-img.on-sand {
  /* keep original — navy reads beautifully on sand */
}
