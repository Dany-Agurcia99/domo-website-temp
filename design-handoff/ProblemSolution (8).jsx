// Footer — DOMO + Grupo NOMA branding.

function Footer() {
  const cols = [
    {
      title: "Producto",
      links: [
        { label: "Qué es DOMO",     href: "#que-es" },
        { label: "Cómo funciona",   href: "#como-funciona" },
        { label: "Servicios",       href: "#servicios" },
        { label: "Para Profesionales", href: "#registro" },
      ],
    },
    {
      title: "Empresa",
      links: [
        { label: "Sobre DOMO", href: "#" },
        { label: "Grupo NOMA", href: "#" },
        { label: "Carreras",   href: "#" },
        { label: "Prensa",     href: "#" },
      ],
    },
    {
      title: "Contacto",
      links: [
        { label: "hola@domo.hn",          href: "mailto:hola@domo.hn", icon: "mail" },
        { label: "+504 9876-5432",         href: "tel:+50498765432", icon: "phone" },
        { label: "Tegucigalpa, Honduras",  href: "#", icon: "map-pin" },
      ],
    },
    {
      title: "Legal",
      links: [
        { label: "Aviso de Privacidad", href: "#" },
        { label: "Términos de Servicio", href: "#" },
        { label: "Cookies",              href: "#" },
      ],
    },
  ];
  return (
    <footer id="soporte" data-screen-label="Footer" style={{
      background: "var(--domo-navy)", color: "#fff", padding: "80px 0 36px",
      position: "relative", overflow: "hidden",
    }}>
      {/* Decorative gradient */}
      <div aria-hidden style={{
        position: "absolute", inset: 0, pointerEvents: "none",
        background: "radial-gradient(circle at 90% 0%, rgba(25,83,90,0.5), transparent 50%)",
      }}/>

      <div className="container" style={{position: "relative", zIndex: 1}}>
        {/* Top: brand + final CTA */}
        <div style={{
          display: "grid",
          gridTemplateColumns: "1.4fr 1fr",
          gap: 48,
          paddingBottom: 56,
          borderBottom: "1px solid rgba(255,255,255,0.10)",
          alignItems: "flex-start",
        }}>
          <div>
            <img src="assets/domo-logo.png" alt="DOMO"
                 style={{height: 36, filter: "brightness(0) invert(1)", display: "block"}}/>
            <p style={{
              color: "rgba(255,255,255,0.72)", fontSize: 15, lineHeight: 1.6,
              marginTop: 18, maxWidth: 380,
            }}>
              La super-app de servicios para el hogar de Honduras. Construida en Tegucigalpa.
            </p>
            <div style={{display: "flex", gap: 10, marginTop: 22}}>
              {[
                { name: "instagram", label: "Instagram" },
                { name: "facebook",  label: "Facebook" },
                { name: "twitter",   label: "Twitter" },
                { name: "linkedin",  label: "LinkedIn" },
              ].map(n => (
                <a key={n.name} href="#" style={{
                  width: 38, height: 38, borderRadius: 10,
                  background: "rgba(255,255,255,0.06)",
                  border: "1px solid rgba(255,255,255,0.10)",
                  display: "flex", alignItems: "center", justifyContent: "center",
                  color: "#fff", textDecoration: "none",
                  transition: "all var(--dur-base) var(--ease-standard)",
                }} aria-label={n.label}
                   onMouseEnter={(e) => e.currentTarget.style.background = "rgba(25,83,90,0.4)"}
                   onMouseLeave={(e) => e.currentTarget.style.background = "rgba(255,255,255,0.06)"}>
                  <Icon name={n.name} size={16} stroke="#fff"/>
                </a>
              ))}
            </div>
          </div>

          {/* Mini CTA */}
          <div style={{
            background: "rgba(255,255,255,0.04)",
            border: "1px solid rgba(255,255,255,0.10)",
            borderRadius: 18,
            padding: "22px 24px",
          }}>
            <div style={{
              fontSize: 11, fontWeight: 700, letterSpacing: "0.12em",
              textTransform: "uppercase", color: "#5EAEB1",
            }}>Última llamada</div>
            <h4 style={{
              margin: "8px 0 12px",
              fontFamily: "var(--font-display)", fontWeight: 700,
              fontSize: 22, color: "#fff", letterSpacing: "-0.01em",
            }}>
              ¿Aún no estás dentro?
            </h4>
            <a href="#registro" style={{textDecoration: "none"}}>
              <Button variant="primary" size="lg" full iconRight="arrow-right"
                      style={{background: "#fff", color: "var(--domo-navy)"}}>
                Unirme al piloto
              </Button>
            </a>
          </div>
        </div>

        {/* Links grid */}
        <div style={{
          display: "grid",
          gridTemplateColumns: "repeat(4, 1fr)",
          gap: 32,
          padding: "48px 0 48px",
          borderBottom: "1px solid rgba(255,255,255,0.10)",
        }}>
          {cols.map(col => (
            <div key={col.title}>
              <div style={{
                fontSize: 12, fontWeight: 700, letterSpacing: "0.12em",
                textTransform: "uppercase", color: "#5EAEB1", marginBottom: 14,
              }}>
                {col.title}
              </div>
              <ul style={{listStyle: "none", padding: 0, margin: 0, display: "flex",
                          flexDirection: "column", gap: 10}}>
                {col.links.map(l => (
                  <li key={l.label}>
                    <a href={l.href} style={{
                      color: "rgba(255,255,255,0.78)", textDecoration: "none",
                      fontSize: 14,
                      display: "inline-flex", alignItems: "center", gap: 8,
                    }}>
                      {l.icon && <Icon name={l.icon} size={14} stroke="rgba(255,255,255,0.5)"/>}
                      {l.label}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        {/* Bottom row — Grupo NOMA branding */}
        <div style={{
          paddingTop: 28,
          display: "flex", flexWrap: "wrap",
          justifyContent: "space-between", alignItems: "center", gap: 18,
          color: "rgba(255,255,255,0.55)", fontSize: 13,
        }}>
          <span>© 2026 DOMO Honduras, S.A. de C.V. — Todos los derechos reservados.</span>

          <div style={{
            display: "inline-flex", alignItems: "center", gap: 10,
            padding: "8px 14px", borderRadius: 999,
            background: "rgba(255,255,255,0.05)",
            border: "1px solid rgba(255,255,255,0.10)",
          }}>
            <span style={{color: "rgba(255,255,255,0.55)", fontSize: 12}}>Una empresa de</span>
            <span style={{
              fontFamily: "var(--font-display)", fontWeight: 800,
              fontSize: 14, letterSpacing: "0.04em",
              color: "#fff",
            }}>GRUPO NOMA</span>
          </div>

          <span style={{display: "inline-flex", alignItems: "center", gap: 6}}>
            Hecho con cariño en Tegucigalpa <span style={{fontSize: 14}}>🇭🇳</span>
          </span>
        </div>
      </div>
    </footer>
  );
}

window.Footer = Footer;
