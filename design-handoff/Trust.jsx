// Nav v2 — smoked/polarized glass bar: blurred tinted background, white logo + links.

function NavV2() {
  const [scrolled, setScrolled] = React.useState(false);
  React.useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 16);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const links = [
    { label: "Cómo funciona", href: "#como-funciona" },
    { label: "Servicios", href: "#servicios" },
    { label: "Confianza", href: "#confianza" },
    { label: "FAQ", href: "#faq" },
  ];

  return (
    <header data-screen-label="Nav" style={{
      position: "sticky", top: 0, zIndex: 50,
      background: scrolled ? "rgba(17,22,39,0.55)" : "rgba(17,22,39,0.32)",
      backdropFilter: "blur(20px) saturate(140%)",
      WebkitBackdropFilter: "blur(20px) saturate(140%)",
      borderBottom: "1px solid rgba(255,255,255,0.12)",
      transition: "background var(--dur-base) var(--ease-standard)",
    }}>
      <div className="container" style={{
        display: "flex", alignItems: "center", gap: 20,
        padding: "16px 32px",
      }}>
        <a href="#top" style={{ display: "inline-flex" }}>
          <img src="assets/domo-logo.png" alt="DOMO"
               style={{ display: "block", height: 28, width: "auto",
                        filter: "brightness(0) invert(1)" }} />
        </a>
        <div style={{ flex: 1 }} />
        <div className="nav-links" style={{ display: "flex", gap: 32 }}>
          {links.map((l) => (
            <a key={l.href} href={l.href}
               style={{
                 textDecoration: "none", color: "rgba(255,255,255,0.88)",
                 fontWeight: 600, fontSize: 14, padding: "6px 2px",
                 transition: "color var(--dur-base) var(--ease-standard)",
               }}
               onMouseEnter={(e) => e.currentTarget.style.color = "#fff"}
               onMouseLeave={(e) => e.currentTarget.style.color = "rgba(255,255,255,0.88)"}>
              {l.label}
            </a>
          ))}
        </div>
      </div>
    </header>
  );
}

window.NavV2 = NavV2;
