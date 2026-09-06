type ApiErrorBody = {
  code?: string;
  error?: string;
};

export class DomoApiError extends Error {
  constructor(
    message: string,
    readonly status: number,
    readonly code?: string,
  ) {
    super(message);
  }
}

function getApiConfig() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const publishableKey = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

  if (!supabaseUrl || !publishableKey) {
    throw new Error(
      "Missing API configuration. Configure NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY.",
    );
  }

  return {
    endpoint: `${supabaseUrl}/functions/v1/preregistration`,
    publishableKey,
  };
}

async function requestPreregistrationApi<T>(init?: RequestInit): Promise<T> {
  const { endpoint, publishableKey } = getApiConfig();
  const response = await fetch(endpoint, {
    ...init,
    cache: "no-store",
    headers: {
      apikey: publishableKey,
      "Content-Type": "application/json",
      ...init?.headers,
    },
  });

  const body = (await response.json().catch(() => ({}))) as T & ApiErrorBody;

  if (!response.ok) {
    throw new DomoApiError(
      body.error ?? "Domo API request failed",
      response.status,
      body.code,
    );
  }

  return body;
}

export async function getPreregistrationCount(): Promise<number> {
  const response = await requestPreregistrationApi<{ count: number }>();
  return response.count;
}

export async function createPreregistration(input: {
  fullName: string;
  email: string;
  phone: string;
  interestRole: string;
}): Promise<void> {
  await requestPreregistrationApi({
    method: "POST",
    body: JSON.stringify({
      full_name: input.fullName,
      email: input.email,
      phone: input.phone || null,
      interest_role: input.interestRole,
    }),
  });
}