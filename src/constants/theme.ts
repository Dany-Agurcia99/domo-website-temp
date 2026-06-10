const domoLight = {
  base: "#F5F5F5",
  baseOpp: "#232323",
  primary: "#153843",
  secondary: "#B8D378",
  gradientEnd: "#121728",
  accent: "#ebebeb",
  outline: "#CCC5C5",
  white: "#FFFFFF",
  gray: "#8D8D8D",
  green: "#49A646",
  active: "#1F9D7A",
  inactive: "#6B7280",
  yellow: "#E89E00",
  orange: "#FF6F00",
  red: "#c24141",
  purple: "#915BBC",
} as const;

const domoDark = {
  base: "#232323",
  baseOpp: "#F5F5F5",
  primary: "#B8D378",
  secondary: "#74C2AE",
  gradientEnd: "#74C2AE",
  accent: "#2b2b2b",
  outline: "#494949",
  white: "#dbded9",
  gray: "#8D8D8D",
  green: "#3e903c",
  active: "#66D1AE",
  inactive: "#9CA3AF",
  yellow: "#ca8900",
  orange: "#FF6F00",
  red: "#891c1c",
  purple: "#C084FC",
} as const;

export const theme = {
  colors: {
    domo: {
      light: domoLight,
      dark: domoDark,
    },
  },
} as const;

export const defaultThemeMode = "light";

const activeTheme = theme.colors.domo[defaultThemeMode];

function toCssVariables(
  prefix: `--${string}`,
  values: Readonly<Record<string, string>>,
): Record<`--${string}`, string> {
  return Object.fromEntries(
    Object.entries(values).map(([key, value]) => [`${prefix}-${key}`, value]),
  ) as Record<`--${string}`, string>;
}

export const themeCssVariables: Record<`--${string}`, string> = {
  ...toCssVariables("--color-domo", activeTheme),
  ...toCssVariables("--color-domo-light", theme.colors.domo.light),
  ...toCssVariables("--color-domo-dark", theme.colors.domo.dark),

  "--gradient-domo-hero": `linear-gradient(120deg, ${activeTheme.primary} 0%, ${activeTheme.gradientEnd} 100%)`,
  "--gradient-domo-accent": `linear-gradient(135deg, ${activeTheme.secondary} 0%, ${activeTheme.active} 55%, ${activeTheme.primary} 100%)`,
  "--gradient-domo-soft": `linear-gradient(135deg, ${activeTheme.white} 0%, ${activeTheme.accent} 100%)`,

  "--color-bg-canvas": activeTheme.base,
  "--color-bg-surface": activeTheme.white,
  "--color-bg-elevated": activeTheme.accent,
  "--color-bg-accent": activeTheme.secondary,
  "--color-text-primary": activeTheme.baseOpp,
  "--color-text-secondary": activeTheme.primary,
  "--color-text-muted": activeTheme.gray,
  "--color-text-inverse": activeTheme.white,
  "--color-outline-subtle": activeTheme.outline,
  "--color-outline-strong": activeTheme.primary,
  "--color-outline-focus": activeTheme.active,
  "--color-primary-base": activeTheme.primary,
  "--color-primary-hover": activeTheme.gradientEnd,
  "--color-primary-active": activeTheme.active,
  "--color-primary-contrast": activeTheme.white,
  "--color-support-success": activeTheme.green,
  "--color-support-error": activeTheme.red,
  "--color-support-warning": activeTheme.yellow,
};
