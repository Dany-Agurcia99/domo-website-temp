// Main CTA Section — large, centered, conversion-focused.
// Dark navy panel with the brand gradient glow to draw the eye.

function MainCTA() {
  return (
    <section data-screen-label="Main CTA" style={{
      padding: "72px 0",
      background: "var(--domo-white)",
    }}>
      <div className="container">
        <div style={{
          position: "relative",
          background: "var(--domo-navy)",
          borderRadius: 32,
          padding: "72px 48px 76px",
          overflow: "hidden",
          textAlign: "center",
          boxShadow: "0 40px 80px -28px rgba(17,22,39,0.45)",
        }}>
          {/* Gradient glow */}
          <div aria-hidden style={{
            position: "absolute", inset: 0, pointerEvents: "none",
            background:
              "radial-gradient(circle at 18% 20%, rgba(25, 83, 90, 0.6), transparent 45%)," +
              "radial-gradient(circle at 85% 75%, rgba(94, 174, 177, 0.30), transparent 50%)",
          }}/>
          {/* Faint dot grid */}
          <div aria-hidden style={{
            position: "absolute", inset: 0, pointerEvents: "none", opacity: 0.5,
            backgroundImage: "radial-gradient(circle, rgba(255,255,255,0.07) 1px, transparent 1px)",
            backgroundSize: "26px 26px",
            maskImage: "radial-gradient(ellipse at center, black 40%, transparent 85%)",
            WebkitMaskImage: "radial-gradient(ellipse at center, black 40%, transparent 85%)",
          }}/>

          <div style={{position: "relative", zIndex: 1}}>
            {/* Scarcity chip */}
            <div style={{
              display: "inline-flex", alignItems: "center", gap: 10,
              padding: "8px 16px", borderRadius: 999,
              background: "rgba(94,174,177,0.16)",
              border: "1px solid rgba(94,174,177,0.30)",
              color: "#9BD4D6",
              fontSize: 12, fontWeight: 700, letterSpacing: "0.10em",
              textTransform: "uppercase",
            }}>
              <span style={{
                width: 6, height: 6, borderRadius: 999, background: "#5EAEB1",
                boxShadow: "0 0 0 4px rgba(94,174,177,0.22)",
              }}/>
              Lugares limitados · 2,852 restantes
            </div>

            <h2 style={{
              margin: "22px auto 14px", maxWidth: 760,
              fontFamily: "var(--font-display)", fontWeight: 700,
              fontSize: 56, lineHeight: 1.05, letterSpacing: "-0.025em",
              color: "#fff",
            }}>
              Únete al piloto.<br/>
              <em style={{fontStyle: "normal", color: "#5EAEB1"}}>Ayúdanos a construirlo.</em>
            </h2>

            <p style={{
              margin: "0 auto 32px", maxWidth: 540,
              color: "rgba(255,255,255,0.78)",
              fontSize: 18, lineHeight: 1.55,
            }}>
              Los primeros 5,000 Miembros Fundadores reciben acceso anticipado y la tarifa fundador para siempre.
            </p>

            <a href="#registro" style={{textDecoration: "none"}}>
              <Button variant="primary" size="xl" iconRight="arrow-right"
                style={{
                  background: "#fff", color: "var(--domo-navy)",
                  boxShadow: "0 18px 40px -12px rgba(0,0,0,0.35)",
                }}>
                Asegurar mi lugar — Gratis
              </Button>
            </a>

            <div style={{
              marginTop: 22,
              color: "rgba(255,255,255,0.55)",
              fontSize: 13,
              display: "flex", alignItems: "center", gap: 14, flexWrap: "wrap", justifyContent: "center",
            }}>
              <span style={{display: "inline-flex", alignItems: "center", gap: 6}}>
                <Icon name="check" size={14} stroke="#5EAEB1" strokeWidth={2.4}/>
                Sin tarjeta
              </span>
              <span style={{opacity: 0.4}}>·</span>
              <span style={{display: "inline-flex", alignItems: "center", gap: 6}}>
                <Icon name="check" size={14} stroke="#5EAEB1" strokeWidth={2.4}/>
                60 segundos
              </span>
              <span style={{opacity: 0.4}}>·</span>
              <span style={{display: "inline-flex", alignItems: "center", gap: 6}}>
                <Icon name="check" size={14} stroke="#5EAEB1" strokeWidth={2.4}/>
                Sin compromiso
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

window.MainCTA = MainCTA;
