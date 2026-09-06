import { siteText } from "@/constants/site-text";
import { createPreregistration, DomoApiError } from "@/lib/domo-api";
import {
  normalizeEmail,
  normalizeHondurasPhone,
  normalizeString,
  toTitleCase,
} from "@/utils/formatters";

import { preregistrationSchema } from "../schema";
import {
  emptyPreregistrationFormValues,
  type PreregistrationFormState,
  type PreregistrationFormValues,
} from "../types";

function mapValidationErrors(
  values: PreregistrationFormValues,
  errors: Partial<Record<keyof PreregistrationFormValues, string[] | undefined>>,
): PreregistrationFormState {
  return {
    status: "error",
    message: siteText.form.invalidMessage,
    values,
    fieldErrors: {
      fullName: errors.fullName?.[0],
      email: errors.email?.[0],
      phone: errors.phone?.[0],
      department: errors.department?.[0],
      platform: errors.platform?.[0],
      interest: errors.interest?.[0],
    },
  };
}

export async function submitPreregistration(
  _prevState: PreregistrationFormState,
  formData: FormData,
): Promise<PreregistrationFormState> {
  const honeypot = normalizeString(formData.get("website"));

  if (honeypot) {
    return {
      status: "success",
      message: siteText.form.successMessage,
      values: emptyPreregistrationFormValues,
      fieldErrors: {},
    };
  }

  const values: PreregistrationFormValues = {
    fullName: toTitleCase(normalizeString(formData.get("fullName"))),
    email: normalizeEmail(normalizeString(formData.get("email"))),
    phone: normalizeHondurasPhone(normalizeString(formData.get("phone"))),
    department: normalizeString(formData.get("department")),
    platform: normalizeString(formData.get("platform")),
    interest: normalizeString(formData.get("interest")),
  };

  const validated = preregistrationSchema.safeParse(values);

  if (!validated.success) {
    return mapValidationErrors(values, validated.error.flatten().fieldErrors);
  }

  try {
    await createPreregistration({
      fullName: validated.data.fullName,
      email: validated.data.email,
      phone: validated.data.phone,
      interestRole: validated.data.interest,
    });
  } catch (error) {
    if (error instanceof DomoApiError && error.status === 429) {
      return {
        status: "error",
        message: siteText.form.rateLimitMessage,
        values,
        fieldErrors: {},
      };
    }

    console.error("[preregistration] Domo API request failed", error);
    return {
      status: "error",
      message:
        error instanceof Error && error.message.startsWith("Missing API configuration")
          ? siteText.form.missingConfigMessage
          : siteText.form.serverErrorMessage,
      values,
      fieldErrors: {},
    };
  }

  return {
    status: "success",
    message: siteText.form.successMessage,
    values: emptyPreregistrationFormValues,
    fieldErrors: {},
  };
}
