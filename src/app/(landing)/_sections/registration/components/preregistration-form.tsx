"use client";

import { useActionState } from "react";

import { leadSourceOptions, serviceOptions, siteText } from "@/constants/site-text";

import { submitPreregistration } from "../actions/submit-preregistration";
import { initialPreregistrationFormState } from "../types";
import { SubmitButton } from "./submit-button";
import styles from "./preregistration-form.module.css";

function withErrorClass(baseClass: string, hasError: boolean) {
  return hasError ? `${baseClass} ${styles.inputError}` : baseClass;
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
      <header className={styles.formHeader}>
        <h2 className={styles.formTitle}>{siteText.form.title}</h2>
        <p className={styles.formDescription}>{siteText.form.description}</p>
      </header>

      <form action={formAction} className={styles.form} noValidate>
        <input
          className={styles.honeypot}
          type="text"
          name="website"
          tabIndex={-1}
          autoComplete="off"
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
              required
              defaultValue={state.values.phone}
              placeholder={siteText.form.placeholders.phone}
              className={withErrorClass(styles.input, Boolean(state.fieldErrors.phone))}
            />
            {state.fieldErrors.phone ? (
              <span className={styles.errorText}>{state.fieldErrors.phone}</span>
            ) : null}
          </div>

          <div className={styles.field}>
            <label className={styles.label} htmlFor="city">
              {siteText.form.labels.city}
            </label>
            <input
              id="city"
              name="city"
              type="text"
              required
              defaultValue={state.values.city}
              placeholder={siteText.form.placeholders.city}
              className={withErrorClass(styles.input, Boolean(state.fieldErrors.city))}
            />
            {state.fieldErrors.city ? (
              <span className={styles.errorText}>{state.fieldErrors.city}</span>
            ) : null}
          </div>

          <div className={styles.field}>
            <label className={styles.label} htmlFor="serviceType">
              {siteText.form.labels.serviceType}
            </label>
            <select
              id="serviceType"
              name="serviceType"
              required
              defaultValue={state.values.serviceType}
              className={withErrorClass(styles.select, Boolean(state.fieldErrors.serviceType))}
            >
              <option value="">Selecciona una opcion</option>
              {serviceOptions.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
            {state.fieldErrors.serviceType ? (
              <span className={styles.errorText}>{state.fieldErrors.serviceType}</span>
            ) : null}
          </div>

          <div className={styles.field}>
            <label className={styles.label} htmlFor="leadSource">
              {siteText.form.labels.leadSource}
            </label>
            <select
              id="leadSource"
              name="leadSource"
              required
              defaultValue={state.values.leadSource}
              className={withErrorClass(styles.select, Boolean(state.fieldErrors.leadSource))}
            >
              <option value="">Selecciona una opcion</option>
              {leadSourceOptions.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
            {state.fieldErrors.leadSource ? (
              <span className={styles.errorText}>{state.fieldErrors.leadSource}</span>
            ) : null}
          </div>

          <div className={`${styles.field} ${styles.fieldWide}`}>
            <label className={styles.label} htmlFor="details">
              {siteText.form.labels.details}
            </label>
            <textarea
              id="details"
              name="details"
              defaultValue={state.values.details}
              placeholder={siteText.form.placeholders.details}
              className={withErrorClass(styles.textarea, Boolean(state.fieldErrors.details))}
            />
            {state.fieldErrors.details ? (
              <span className={styles.errorText}>{state.fieldErrors.details}</span>
            ) : null}
          </div>
        </div>

        <p aria-live="polite" className={formMessageClass}>
          {state.message}
        </p>

        <SubmitButton />
      </form>
    </section>
  );
}
