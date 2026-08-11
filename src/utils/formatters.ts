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

export function formatHondurasPhoneInput(value: string): string {
  const digitsOnly = value.replace(/\D/g, "");

  if (!digitsOnly) {
    return "";
  }

  const localDigits = digitsOnly.startsWith("504")
    ? digitsOnly.slice(3, 11)
    : digitsOnly.slice(0, 8);

  if (!localDigits) {
    return "";
  }

  if (localDigits.length <= 4) {
    return `+504 ${localDigits}`;
  }

  return `+504 ${localDigits.slice(0, 4)}-${localDigits.slice(4)}`;
}

export function toTitleCase(value: string): string {
  return value
    .toLowerCase()
    .split(/\s+/)
    .filter(Boolean)
    .map((word) => `${word.charAt(0).toUpperCase()}${word.slice(1)}`)
    .join(" ");
}
