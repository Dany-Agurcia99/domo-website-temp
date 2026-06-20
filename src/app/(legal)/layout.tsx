import { SiteNav } from "@/components/layout/site-nav";
import { siteNavItems } from "@/constants/site-text";

export default function LegalLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <>
      <SiteNav items={siteNavItems} />
      {children}
    </>
  );
}
