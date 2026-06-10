// Footer v2 — Busy Bee Honey style: top nav row, giant DOMO wordmark full-bleed,
// bottom legal + copyright row. DOMO navy + lime palette.

function FooterV2() {
  const footerRef = React.useRef(null);
  const [h, setH] = React.useState(0);

  React.useEffect(() => {
    const el = footerRef.current;
    if (!el) return;
    const measure = () => setH(el.offsetHeight);
    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(el);
    window.addEventListener("resize", measure);
    return () => { ro.disconnect(); window.removeEventListener("resize", measure); };
  }, []);

  const topLinks = [
    { label: "Cómo funciona", href: "#como-funciona" },
    { label: "Servicios",     href: "#servicios" },
    { label: "Confianza",     href: "#confianza" },
    { label: "Únete al piloto", href: "#registro" },
    { label: "Contacto",      href: "mailto:hola@domo.hn" },
  ];

  return (
    <>
      {/* Spacer reserves scroll room so the fixed footer reveals from underneath */}
      <div aria-hidden style={{ height: h }} />

      <footer id="soporte" data-screen-label="Footer" ref={footerRef} className="footer-fixed" style={{ padding: 0 }}>
      <div style={{
        background: "var(--domo-navy)",
        padding: "40px 0 32px",
        position: "relative", overflow: "hidden",
      }}>
        <div className="footer-wide">
          {/* Top nav row */}
          <div style={{
            display: "flex", flexWrap: "wrap", gap: 18,
            justifyContent: "space-between", alignItems: "center",
            paddingBottom: 4,
          }}>
            {topLinks.map((l) => (
              <a key={l.href} href={l.href} style={{
                textDecoration: "none",
                color: "rgba(255,255,255,0.72)",
                fontSize: 12, fontWeight: 700, letterSpacing: "0.16em",
                textTransform: "uppercase",
                transition: "color var(--dur-base) var(--ease-standard)",
              }}
                onMouseEnter={(e) => e.currentTarget.style.color = "#BCD476"}
                onMouseLeave={(e) => e.currentTarget.style.color = "rgba(255,255,255,0.72)"}>
                {l.label}
              </a>
            ))}
          </div>

          {/* Giant wordmark */}
          <div className="footer-wordmark" aria-label="DOMO">domo</div>

          {/* Bottom row */}
          <div style={{
            display: "flex", flexWrap: "wrap", gap: 20,
            justifyContent: "space-between", alignItems: "center",
            color: "rgba(255,255,255,0.5)", fontSize: 12,
            fontWeight: 600, letterSpacing: "0.06em", textTransform: "uppercase",
          }}>
            {/* Left: legal */}
            <div style={{ display: "flex", flexWrap: "wrap", gap: 22 }}>
              {["Aviso de Privacidad", "Términos & Condiciones", "Cookies"].map((l) => (
                <a key={l} href="#" style={{
                  color: "rgba(255,255,255,0.5)", textDecoration: "none",
                  transition: "color var(--dur-base) var(--ease-standard)",
                }}
                  onMouseEnter={(e) => e.currentTarget.style.color = "#BCD476"}
                  onMouseLeave={(e) => e.currentTarget.style.color = "rgba(255,255,255,0.5)"}>
                  {l}
                </a>
              ))}
            </div>

            {/* Center: Grupo NOMA */}
            <div style={{ display: "inline-flex", alignItems: "center", gap: 8 }}>
              <span>Una empresa de</span>
              <span style={{
                fontFamily: "var(--font-display)", fontWeight: 800,
                fontSize: 13, letterSpacing: "0.06em", color: "#fff",
              }}>GRUPO NOMA</span>
            </div>

            {/* Right: social (white) above copyright */}
            <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 12 }}>
              <div style={{ display: "inline-flex", gap: 14 }}>
                {["instagram", "facebook", "linkedin"].map((n) => (
                  <a key={n} href="#" aria-label={n} style={{
                    color: "#fff", display: "inline-flex",
                    transition: "color var(--dur-base) var(--ease-standard)",
                  }}
                    onMouseEnter={(e) => e.currentTarget.style.color = "#BCD476"}
                    onMouseLeave={(e) => e.currentTarget.style.color = "#fff"}>
                    <Icon name={n} size={20} stroke="currentColor" />
                  </a>
                ))}
              </div>
              <span>© 2026 DOMO Honduras, S.A. de C.V.</span>
            </div>
          </div>
        </div>
      </div>
      </footer>
    </>);

}

window.FooterV2 = FooterV2;
