// Trust v2 — bold headline + full-bleed glass cards (no icons, no stats).

function TrustV2() {
  return (
    <section id="confianza" data-screen-label="Trust" style={{ padding: "60px 0 100px", position: "relative", overflow: "hidden" }}>
      <div className="container" style={{ position: "relative", zIndex: 1 }}>
        <div className="section-head section-head--center" style={{ textAlign: "center" }}>
          <h2 className="tally-display tally-display--xl">
            Una app que se toma<br />
            <span className="accent">en serio tu hogar.</span>
          </h2>
        </div>
      </div>

      <div className="trust-grid" style={{ position: "relative", zIndex: 1 }}>
        <TrustCard
          title="Técnicos verificados"
          blurb="Cada profesional pasa por entrevista en persona, verificación de identidad y referencias revisadas antes de aceptar trabajos." />

        <TrustCard
          title="Seguro y confiable"
          blurb="Pago protegido dentro de la app, precio acordado desde el inicio y la garantía DOMO respaldando cada servicio." />

        <TrustCard
          title="Próximamente en Tegucigalpa"
          blurb="Lanzamos primero en la capital y seguimos zona por zona — San Pedro Sula, La Ceiba y Choloma vienen en camino." />
      </div>
    </section>);

}

function TrustCard({ title, blurb }) {
  return (
    <article className="trust-card" style={{
      background: "linear-gradient(135deg, rgba(21,56,67,0.92) 0%, rgba(18,23,40,0.92) 100%)",
      WebkitBackdropFilter: "blur(22px) saturate(150%)",
      backdropFilter: "blur(22px) saturate(150%)",
      border: "1px solid rgba(255,255,255,0.12)",
      borderRadius: 32, padding: "28px 34px",
      display: "flex", flexDirection: "column", gap: 14,
      minHeight: 200, justifyContent: "center",
      boxShadow: "0 24px 50px -28px rgba(17,22,39,0.45)",
      transition: "all var(--dur-base) var(--ease-standard)"
    }}>
      <h3 style={{
        margin: 0,
        fontFamily: "var(--font-display)", fontWeight: 800,
        fontSize: 34, lineHeight: 1.05, letterSpacing: "-0.02em",
        color: "#fff"
      }}>{title}</h3>

      <p style={{
        margin: 0, fontSize: 18, lineHeight: 1.6,
        color: "rgba(255,255,255,0.72)"
      }}>{blurb}</p>
    </article>);

}

window.TrustV2 = TrustV2;