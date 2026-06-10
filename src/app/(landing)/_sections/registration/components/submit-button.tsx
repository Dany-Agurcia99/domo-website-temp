"use client";

import { useFormStatus } from "react-dom";

import { siteText } from "@/constants/site-text";

import styles from "./preregistration-form.module.css";

export function SubmitButton() {
  const { pending } = useFormStatus();

  return (
    <button type="submit" className={styles.submitButton} disabled={pending}>
      {pending ? siteText.form.pendingCta : siteText.form.cta}
    </button>
  );
}
