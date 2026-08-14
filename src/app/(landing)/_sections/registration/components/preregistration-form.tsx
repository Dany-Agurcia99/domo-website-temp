"use client";

import { useActionState, type FormEvent } from "react";
import Link from "next/link";

import {
  interestOptions,
  siteText,
} from "@/constants/site-text";
import { formatHondurasPhoneInput } from "@/utils/formatters";

import { submitPreregistration } from "../actions/submit-preregistration";
import { initialPreregistrationFormState } from "../types";
import { SubmitButton } from "./submit-button";
import styles from "./preregistration-form.module.css";

function withErrorClass(baseClass: string, hasError: boolean) {
  return hasError ? `${baseClass} ${styles.inputError}` : baseClass;
}

function handlePhoneInput(event: FormEvent<HTMLInputElement>) {
  event.currentTarget.value = formatHondurasPhoneInput(event.currentTarget.value);
}

export function PreregistrationForm() {
  const [state, formAction] = useActionState(
    submitPreregistration,
    initialPreregistrationFormState,
  );

  const formMessageClass =
    state.status === "success"
      ? `${styles.formMessage} ${styles.formMessageSuccess}`
      : state.status === "error"
        ? `${styles.formMessage} ${styles.formMessageError}`
        : styles.formMessage;

  return (
    <section className={styles.formShell}>
      <form action={formAction} className={styles.form} noValidate>
        <input
          className={styles.honeypot}
          type="text"
          name="website"
          tabIndex={-1}
          autoComplete="off"
        />
        <input
          type="hidden"
          name="department"
          value={state.values.department || "Francisco Morazán"}
          readOnly
        />
        <input
          type="hidden"
          name="platform"
          value={state.values.platform || "iOS"}
          readOnly
        />

        <div className={styles.fieldGrid}>
          <div className={styles.field}>
            <label className={styles.label} htmlFor="fullName">
              {siteText.form.labels.fullName}
            </label>
            <input
              id="fullName"
              name="fullName"
              type="text"
              required
              defaultValue={state.values.fullName}
              placeholder={siteText.form.placeholders.fullName}
              className={withErrorClass(styles.input, Boolean(state.fieldErrors.fullName))}
            />
            {state.fieldErrors.fullName ? (
              <span className={styles.errorText}>{state.fieldErrors.fullName}</span>
            ) : null}
          </div>

          <div className={styles.field}>
            <label className={styles.label} htmlFor="email">
              {siteText.form.labels.email}
            </label>
            <input
              id="email"
              name="email"
              type="email"
              required
              defaultValue={state.values.email}
              placeholder={siteText.form.placeholders.email}
              className={withErrorClass(styles.input, Boolean(state.fieldErrors.email))}
            />
            {state.fieldErrors.email ? (
              <span className={styles.errorText}>{state.fieldErrors.email}</span>
            ) : null}
          </div>

          <div className={styles.field}>
            <label className={styles.label} htmlFor="phone">
              {siteText.form.labels.phone}
            </label>
            <input
              id="phone"
              name="phone"
              type="tel"
              inputMode="tel"
              autoComplete="tel"
              maxLength={14}
              aria-describedby="phone-help"
              defaultValue={state.values.phone}
              placeholder={siteText.form.placeholders.phone}
              className={withErrorClass(styles.input, Boolean(state.fieldErrors.phone))}
              onInput={handlePhoneInput}
            />
            {state.fieldErrors.phone ? (
              <span className={styles.errorText}>{state.fieldErrors.phone}</span>
            ) : null}
            <span id="phone-help" className={styles.helperText}>
              Solo te avisaremos cuando domo esté disponible. Nada de spam.
            </span>
          </div>

          <div className={styles.field}>
            <label className={styles.label} htmlFor="interest">
              {siteText.form.labels.interest}
            </label>
            <select
              id="interest"
              name="interest"
              required
              defaultValue={state.values.interest}
              className={withErrorClass(styles.select, Boolean(state.fieldErrors.interest))}
            >
              <option value="">Selecciona una opción</option>
              {interestOptions.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
            {state.fieldErrors.interest ? (
              <span className={styles.errorText}>{state.fieldErrors.interest}</span>
            ) : null}
          </div>
        </div>

        <p aria-live="polite" className={formMessageClass}>
          {state.message}
        </p>

        <SubmitButton />

        <p className={styles.legalNotice}>
          Al registrarte, confirmás que leíste nuestros{" "}
          <Link href="/terms">Términos y Condiciones</Link> y la{" "}
          <Link href="/privacy">Política de Privacidad</Link>, y autorizás a
          domo a contactarte cuando la app esté disponible.
        </p>
      </form>
    </section>
  );
}
