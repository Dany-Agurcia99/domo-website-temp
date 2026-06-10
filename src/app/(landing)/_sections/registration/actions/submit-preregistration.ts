"use server";

import { siteText } from "@/constants/site-text";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import {
  normalizeEmail,
  normalizePhone,
  normalizeString,
  toTitleCase,
} from "@/utils/formatters";

import { preregistrationSchema } from "../schema";
import {
  emptyPreregistrationFormValues,
  type PreregistrationFormState,
  type PreregistrationFormValues,
} from "../types";

const preregistrationTable =
  process.env.SUPABASE_PREREGISTRATION_TABLE ?? "preregistrations";

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
      city: errors.city?.[0],
      serviceType: errors.serviceType?.[0],
      leadSource: errors.leadSource?.[0],
      details: errors.details?.[0],
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
    phone: normalizePhone(normalizeString(formData.get("phone"))),
    city: toTitleCase(normalizeString(formData.get("city"))),
    serviceType: normalizeString(formData.get("serviceType")),
    leadSource: normalizeString(formData.get("leadSource")),
    details: normalizeString(formData.get("details")),
  };

  const validated = preregistrationSchema.safeParse(values);

  if (!validated.success) {
    return mapValidationErrors(values, validated.error.flatten().fieldErrors);
  }

  let supabase;
  try {
    supabase = createSupabaseServerClient();
  } catch {
    return {
      status: "error",
      message: siteText.form.missingConfigMessage,
      values,
      fieldErrors: {},
    };
  }

  const { error } = await supabase.from(preregistrationTable).insert({
    full_name: validated.data.fullName,
    email: validated.data.email,
    phone: validated.data.phone,
    city: validated.data.city,
    service_type: validated.data.serviceType,
    lead_source: validated.data.leadSource,
    details: validated.data.details || null,
  });

  if (error) {
    console.error("[preregistration] supabase insert failed", error);
    return {
      status: "error",
      message: siteText.form.serverErrorMessage,
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
