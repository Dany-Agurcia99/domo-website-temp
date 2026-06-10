// FAQ v2 — accordion with ultra-rounded items.

const FAQS = [
{
  q: "¿El pre-registro tiene costo?",
  a: "No. Es 100% gratis y no requiere tarjeta de crédito. Solo te pedimos tu nombre, correo y teléfono para reservarte un lugar entre los Miembros Fundadores."
},
{
  q: "¿Cuándo se lanza la app?",
  a: "Lanzamos el piloto en el cuarto trimestre de 2026, empezando por Tegucigalpa. Los Fundadores reciben acceso una semana antes que el público general."
},
{
  q: "¿Puedo unirme como Hogar y Profesional a la vez?",
  a: "Sí. Algunos Fundadores son ambos — contratan un plomero el martes y limpian casas el sábado. Te registrás una sola vez y podés activar tu rol de Doméstico cuando lleguemos a tu zona."
},
{
  q: "¿Qué pasa después de registrarme?",
  a: "Recibís un correo de bienvenida en menos de 10 minutos. Te incluimos en el grupo de WhatsApp de Fundadores y te enviamos una encuesta corta para saber qué servicios usarías primero."
},
{
  q: "¿Cómo verifican a los Profesionales?",
  a: "Cada Doméstico pasa por entrevista en persona, verificación de identidad y referencias de trabajos anteriores. Los primeros 200 Pros de cada ciudad reciben capacitación gratuita en servicio al cliente."
},
{
  q: "¿Cuándo van a llegar a mi ciudad?",
  a: "Empezamos por Tegucigalpa en Q4 2026, seguidos de San Pedro Sula, La Ceiba y Choloma a inicios de 2027. Si vivís en otra ciudad, registrate igual — priorizamos zonas con más Fundadores inscritos."
}];


function FAQV2() {
  const [open, setOpen] = React.useState(0);

  return (
    <section id="faq" data-screen-label="FAQ" style={{
      padding: "100px 0",
      background: "#fff"
    }}>
      <div className="container">
        <div style={{
          display: "grid", gridTemplateColumns: "1.15fr 1.3fr", gap: 56,
          alignItems: "flex-start"
        }}>
          {/* Left: title block */}
          <div style={{ position: "sticky", top: 100 }}>
            <h2 className="tally-display tally-display--xl" style={{ color: "var(--domo-navy)" }}>
              Lo que la gente pregunta<br />
              <span className="accent">antes de unirse.</span>
            </h2>
          </div>

          {/* Right: accordion */}
          <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
            {FAQS.map((f, i) =>
            <FAQItem key={i} {...f} isOpen={open === i}
            onToggle={() => setOpen(open === i ? -1 : i)} />
            )}
          </div>
        </div>
      </div>
    </section>);

}

function FAQItem({ q, a, isOpen, onToggle }) {
  return (
    <div style={{
      background: isOpen ? "var(--lime-grad)" : "#fff",
      border: `2px solid ${isOpen ? "transparent" : "var(--border-1)"}`,
      borderRadius: 24,
      transition: "all var(--dur-base) var(--ease-standard)",
      overflow: "hidden"
    }}>
      <button
        onClick={onToggle}
        aria-expanded={isOpen}
        style={{
          width: "100%", background: "transparent", border: 0, cursor: "pointer",
          padding: "22px 26px",
          display: "flex", alignItems: "center", gap: 16, textAlign: "left",
          fontFamily: "var(--font-sans)"
        }}>
        <span style={{
          flex: 1, fontFamily: "var(--font-display)", fontWeight: 700,
          fontSize: 18, color: "var(--domo-navy)", letterSpacing: "-0.01em"
        }}>{q}</span>
        <span style={{
          flexShrink: 0, width: 36, height: 36, borderRadius: 999,
          background: isOpen ? "var(--domo-navy)" : "var(--domo-sand-100)",
          color: isOpen ? "var(--lime)" : "var(--accent)",
          display: "inline-flex", alignItems: "center", justifyContent: "center",
          transition: "all var(--dur-base) var(--ease-standard)",
          transform: isOpen ? "rotate(45deg)" : "rotate(0)"
        }}>
          <Icon name="plus" size={20} stroke="currentColor" strokeWidth={2.4} />
        </span>
      </button>
      <div style={{
        maxHeight: isOpen ? 400 : 0,
        overflow: "hidden",
        transition: "max-height var(--dur-slow) var(--ease-standard)"
      }}>
        <p style={{
          margin: 0, padding: "0 26px 26px",
          fontSize: 15, lineHeight: 1.65,
          color: isOpen ? "rgba(17,22,39,0.82)" : "var(--fg-2)",
          maxWidth: 620
        }}>{a}</p>
      </div>
    </div>);

}

window.FAQV2 = FAQV2;