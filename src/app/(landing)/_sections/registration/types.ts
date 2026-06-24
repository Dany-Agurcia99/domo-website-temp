export type PreregistrationFormValues = {
  fullName: string;
  email: string;
  phone: string;
  department: string;
  platform: string;
  interest: string;
};

export type PreregistrationFieldErrorMap = Partial<
  Record<keyof PreregistrationFormValues, string>
>;

export type PreregistrationFormState = {
  status: "idle" | "success" | "error";
  message: string;
  values: PreregistrationFormValues;
  fieldErrors: PreregistrationFieldErrorMap;
};

export const emptyPreregistrationFormValues: PreregistrationFormValues = {
  fullName: "",
  email: "",
  phone: "",
  department: "",
  platform: "",
  interest: "",
};

export const initialPreregistrationFormState: PreregistrationFormState = {
  status: "idle",
  message: "",
  values: emptyPreregistrationFormValues,
  fieldErrors: {},
};
