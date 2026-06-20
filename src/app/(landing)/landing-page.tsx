import { SiteNav } from "@/components/layout/site-nav";
import { siteNavItems } from "@/constants/site-text";

import { HeroSection } from "./_sections/hero/hero-section";
import { HowItWorksSection } from "./_sections/how-it-works/how-it-works-section";
import { MainCtaSection } from "./_sections/main-cta/main-cta-section";
import { RegistrationSection } from "./_sections/registration/registration-section";
import { ServicesSection } from "./_sections/services/services-section";
import { TrustSection } from "./_sections/trust/trust-section";
import styles from "./landing-page.module.css";

export function LandingPage() {
  return (
    <>
      <SiteNav items={siteNavItems} />
      <main className={styles.page}>
        <HeroSection />
        <ServicesSection />
        <HowItWorksSection />
        <TrustSection />
        <MainCtaSection />
        <RegistrationSection />
      </main>
    </>
  );
}
