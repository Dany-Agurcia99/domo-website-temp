// Pre-Reg Info v2 — 4 ultra-rounded cards with big numerals.

const BENEFITS = [
{
  icon: "rocket",
  title: "Acceso anticipado",
  blurb: "Usás DOMO antes que el público general. Mientras los demás esperan, vos ya estás dentro."
},
{
  icon: "gift",
  title: "Es gratis",
  blurb: "Sin tarjeta y sin letra chiquita. Solo tu correo y tu número para apartar el lugar."
},
{
  icon: "heart-handshake",
  title: "Sin compromiso",
  blurb: "Te avisamos cuando esté listo. Si no te convence, te bajás cuando quieras."
},
{
  icon: "ticket-percent",
  title: "Tarifa fundador",
  blurb: "Los primeros 5,000 inscritos guardan un descuento exclusivo mientras DOMO exista."
}];


function PreRegInfoV2() {
  return (
    <section data-screen-label="Pre Reg Benefits" style={{ padding: "60px 0 96px" }}>
      <div className="container">
        <div className="section-head section-head--center" style={{ textAlign: "center" }}>
          <span className="eyebrow" style={{ justifyContent: "center" }}>Qué incluye</span>
          <h2 className="tally-display tally-display--xl" style={{ marginTop: 18 }}>
            Gratis hoy,<br />
            <span className="accent">y sin compromiso.</span>
          </h2>
          <p style={{ margin: "24px auto 0", maxWidth: 600, fontSize: 19, color: "var(--fg-2)", fontWeight: 500 }}>
            Cuatro beneficios que solo reciben los Miembros Fundadores.
            Después del lanzamiento, dejan de estar disponibles.
          </p>
        </div>

        <div style={{ display: "grid",
            gridTemplateColumns: "repeat(4, 1fr)",
            gap: 20,
            marginTop: 72
          }}>
          {BENEFITS.map((b, i) =>
          <BenefitCard key={b.title} {...b} idx={i + 1} />
          )}
        </div>
      </div>
    </section>);

}

function BenefitCard({ icon, title, blurb, idx }) {
  return (
    <article className="r-card" style={{
      borderRadius: 32, padding: "32px 28px 28px",
      minHeight: 320,
      display: "flex", flexDirection: "column", gap: 16,
      position: "relative", overflow: "hidden",
      background: "#fff",
      border: "1px solid var(--border-1)"
    }}>
      {/* Huge faded numeral in background */}
      <span aria-hidden style={{
        position: "absolute", top: -22, right: -8,
        fontFamily: "var(--font-display)", fontWeight: 800,
        fontSize: 140, lineHeight: 1, letterSpacing: "-0.05em",
        color: "rgba(115,195,175,0.18)",
        fontVariantNumeric: "tabular-nums",
        pointerEvents: "none"
      }}>0{idx}</span>

      <div style={{
        width: 56, height: 56, borderRadius: 18,
        background: "var(--lime-grad)",
        display: "flex", alignItems: "center", justifyContent: "center",
        position: "relative", zIndex: 1
      }}>
        <Icon name={icon} size={28} stroke="var(--domo-navy)" strokeWidth={2} />
      </div>

      <h3 style={{
        margin: "8px 0 0",
        fontFamily: "var(--font-display)", fontWeight: 800,
        fontSize: 24, letterSpacing: "-0.02em",
        color: "var(--domo-navy)", lineHeight: 1.1,
        position: "relative", zIndex: 1
      }}>{title}</h3>

      <p style={{
        margin: 0,
        fontSize: 15, lineHeight: 1.55, color: "var(--fg-2)",
        position: "relative", zIndex: 1
      }}>{blurb}</p>
    </article>);

}

window.PreRegInfoV2 = PreRegInfoV2;