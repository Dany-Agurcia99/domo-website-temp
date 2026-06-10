// Main CTA v2 — giant rounded LIME-GRADIENT block (DOMO brand color),
// navy text for contrast.

function MainCTAV2() {
  return (
    <section data-screen-label="Main CTA" style={{ padding: "60px 0 0" }}>
      <div className="block" style={{
        padding: "120px 0",
        borderRadius: 0,
        textAlign: "center",
        position: "relative", overflow: "hidden",
        backgroundImage: "url('assets/cta-bg.png')",
        backgroundSize: "cover",
        backgroundPosition: "center"
      }}>
        <div className="container" style={{ position: "relative", zIndex: 1 }}>
            <div style={{
              display: "inline-flex", alignItems: "center", gap: 10,
              padding: "10px 18px", borderRadius: 999,
              background: "var(--domo-navy)",
              color: "#fff",
              fontSize: 12, fontWeight: 800, letterSpacing: "0.14em",
              textTransform: "uppercase",
              marginBottom: 32
            }}>
              <span style={{
                width: 8, height: 8, borderRadius: 999, background: "var(--lime)",
                boxShadow: "0 0 0 4px rgba(188,212,118,0.45)"
              }} />
              2,852 lugares restantes
            </div>

            <h2 className="tally-display tally-display--xxl" style={{
              color: "var(--domo-navy)",
              maxWidth: 1040, margin: "0 auto"
            }}>
              Únete al piloto.<br />
              <span style={{
                background: "var(--domo-navy)",
                color: "var(--lime)",
                borderRadius: 12, padding: "0 0.22em"
              }}>Ayudanos</span>{" "}a construirlo.
            </h2>

            <p style={{
              margin: "32px auto 0", maxWidth: 560,
              color: "rgba(17,22,39,0.78)",
              fontSize: 20, lineHeight: 1.55, fontWeight: 500
            }}>
              Los primeros 5,000 Miembros Fundadores reciben acceso anticipado y tarifa fundador para siempre.
            </p>

            <div style={{
              marginTop: 44, display: "inline-flex", flexWrap: "wrap", gap: 14,
              justifyContent: "center"
            }}>
              <a href="#registro" style={{ textDecoration: "none" }}>
                <Button variant="primary" size="xl" iconRight="arrow-right">
                  Asegurar mi lugar
                </Button>
              </a>
            </div>
          </div>
        </div>
    </section>);

}

window.MainCTAV2 = MainCTAV2;