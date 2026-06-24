export function normalizeString(value: FormDataEntryValue | null): string {
  if (typeof value !== "string") {
    return "";
  }

  return value.trim();
}

export function normalizeEmail(value: string): string {
  return value.trim().toLowerCase();
}

export function normalizeHondurasPhone(value: string): string {
  const digitsOnly = value.replace(/\D/g, "");

  if (!digitsOnly) {
    return "";
  }

  if (digitsOnly.length === 8) {
    return `+504${digitsOnly}`;
  }

  if (digitsOnly.length === 11 && digitsOnly.startsWith("504")) {
    return `+${digitsOnly}`;
  }

  return digitsOnly;
}

export function toTitleCase(value: string): string {
  return value
    .toLowerCase()
    .split(/\s+/)
    .filter(Boolean)
    .map((word) => `${word.charAt(0).toUpperCase()}${word.slice(1)}`)
    .join(" ");
}
