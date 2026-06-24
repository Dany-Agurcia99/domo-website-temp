"use server";

import { createHmac } from "node:crypto";

import { headers } from "next/headers";

import { siteText } from "@/constants/site-text";
import { createSupabaseServerClient } from "@/lib/supabase/server";
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

const preregistrationTable =
  process.env.SUPABASE_PREREGISTRATION_TABLE ?? "preregistrations";

type RateLimitResponse = {
  allowed: boolean;
  reason?: "short_window" | "daily";
};

async function createClientIpHash(): Promise<string | null> {
  const secret = process.env.PREREGISTRATION_RATE_LIMIT_SECRET;
  if (!secret || secret.length < 32) return null;

  const requestHeaders = await headers();
  const forwardedFor =
    requestHeaders.get("x-vercel-forwarded-for") ??
    requestHeaders.get("x-forwarded-for");
  const clientIp =
    forwardedFor?.split(",")[0]?.trim() ??
    (process.env.NODE_ENV === "development" ? "127.0.0.1" : null);

  if (!clientIp) return null;

  return createHmac("sha256", secret).update(clientIp).digest("hex");
}

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

  const ipHash = await createClientIpHash();

  if (!ipHash) {
    console.error("[preregistration] rate limit configuration unavailable");
    return {
      status: "error",
      message: siteText.form.serverErrorMessage,
      values,
      fieldErrors: {},
    };
  }

  const { data: rateLimitData, error: rateLimitError } = await supabase.rpc(
    "consume_preregistration_rate_limit",
    { p_ip_hash: ipHash },
  );

  if (rateLimitError) {
    console.error("[preregistration] rate limit check failed", rateLimitError);
    return {
      status: "error",
      message: siteText.form.serverErrorMessage,
      values,
      fieldErrors: {},
    };
  }

  const rateLimit = rateLimitData as RateLimitResponse | null;

  if (!rateLimit?.allowed) {
    return {
      status: "error",
      message: siteText.form.rateLimitMessage,
      values,
      fieldErrors: {},
    };
  }

  const { error } = await supabase.from(preregistrationTable).insert({
    full_name: validated.data.fullName,
    email: validated.data.email,
    phone: validated.data.phone || null,
    department: validated.data.department,
    platform: validated.data.platform,
    interest_role: validated.data.interest,
  });

  if (error) {
    if (error.code === "23505") {
      return {
        status: "success",
        message: siteText.form.successMessage,
        values: emptyPreregistrationFormValues,
        fieldErrors: {},
      };
    }

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
