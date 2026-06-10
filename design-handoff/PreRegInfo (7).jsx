// FAQ — accordion list of common pre-registration questions.

const FAQS = [
  {
    q: "¿El pre-registro tiene costo?",
    a: "No. Inscribirte es completamente gratuito y no requiere tarjeta de crédito. Solo te pediremos tu nombre, correo y teléfono para reservarte un lugar entre los Miembros Fundadores.",
  },
  {
    q: "¿Cuándo se lanza la app?",
    a: "Estamos planeando lanzar el piloto durante el cuarto trimestre de 2026, empezando por Tegucigalpa. Los Fundadores reciben acceso una semana antes que el público general.",
  },
  {
    q: "¿Puedo unirme como Hogar y Profesional a la vez?",
    a: "Sí. Algunos de nuestros Fundadores son ambos — contratan un plomero el martes y limpian casas el sábado. Solo necesitás registrarte una vez; podrás activar tu rol de Doméstico desde tu perfil cuando lleguemos a tu zona.",
  },
  {
    q: "¿Qué pasa después de registrarme?",
    a: "Recibirás un correo de bienvenida en menos de 10 minutos con la confirmación de tu lugar como Fundador. Te incluiremos en nuestro grupo de WhatsApp donde compartimos avances cada mes y te enviaremos una encuesta breve para conocer qué servicios usarías primero.",
  },
  {
    q: "¿Cómo verifican a los Profesionales?",
    a: "Cada Doméstico pasa por entrevista en persona, verificación de identidad y referencias de trabajos anteriores. Los primeros 200 Pros de cada ciudad reciben además capacitación gratuita en servicio al cliente.",
  },
  {
    q: "¿Cuándo van a llegar a mi ciudad?",
    a: "Empezamos por Tegucigalpa en el Q4 de 2026, seguidos de San Pedro Sula, La Ceiba y Choloma a inicios de 2027. Si vives en otra ciudad, podés registrarte igual — priorizamos las zonas con más Fundadores inscritos.",
  },
];

function FAQ() {
  const [open, setOpen] = React.useState(0);

  return (
    <section id="faq" data-screen-label="FAQ" style={{background: "var(--domo-white)"}}>
      <div className="container">
        <div className="section-head">
          <span className="eyebrow">Preguntas frecuentes</span>
          <h2>Lo que la gente nos pregunta<br/>antes de unirse.</h2>
        </div>

        <div style={{maxWidth: 820, margin: "0 auto", display: "flex", flexDirection: "column", gap: 12}}>
          {FAQS.map((f, i) => (
            <FAQItem key={i} {...f} isOpen={open === i} onToggle={() => setOpen(open === i ? -1 : i)}/>
          ))}
        </div>

        {/* Soft "still have questions" closer */}
        <div style={{
          maxWidth: 820, margin: "32px auto 0",
          display: "flex", alignItems: "center", gap: 14,
          padding: "18px 22px",
          background: "var(--domo-sand-50)",
          border: "1px solid var(--border-1)",
          borderRadius: 16,
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 12,
            background: "var(--domo-white)",
            border: "1px solid var(--border-1)",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>
            <Icon name="message-circle" size={22} stroke="var(--accent)"/>
          </div>
          <div style={{flex: 1, minWidth: 0}}>
            <div style={{fontWeight: 600, color: "var(--domo-navy)", fontSize: 15}}>¿Otra duda?</div>
            <div style={{color: "var(--fg-2)", fontSize: 13, marginTop: 2}}>
              Escríbenos por WhatsApp al <strong>+504 9876-5432</strong> — respondemos en menos de 10 minutos.
            </div>
          </div>
          <Button variant="outline" size="sm" iconRight="arrow-right">Escribir</Button>
        </div>
      </div>
    </section>
  );
}

function FAQItem({ q, a, isOpen, onToggle }) {
  return (
    <div style={{
      background: "var(--domo-white)",
      border: `1px solid ${isOpen ? "rgba(25,83,90,0.30)" : "var(--border-1)"}`,
      borderRadius: 14,
      boxShadow: isOpen ? "var(--shadow-2)" : "none",
      transition: "all var(--dur-base) var(--ease-standard)",
      overflow: "hidden",
    }}>
      <button
        onClick={onToggle}
        aria-expanded={isOpen}
        style={{
          width: "100%", background: "transparent", border: 0, cursor: "pointer",
          padding: "20px 22px",
          display: "flex", alignItems: "center", gap: 16, textAlign: "left",
          fontFamily: "var(--font-sans)",
        }}>
        <span style={{
          flex: 1, fontFamily: "var(--font-display)", fontWeight: 600,
          fontSize: 17, color: "var(--domo-navy)", letterSpacing: "-0.01em",
        }}>{q}</span>
        <span style={{
          flexShrink: 0, width: 32, height: 32, borderRadius: 999,
          background: isOpen ? "var(--accent)" : "var(--domo-teal-50)",
          color: isOpen ? "#fff" : "var(--accent)",
          display: "inline-flex", alignItems: "center", justifyContent: "center",
          transition: "all var(--dur-base) var(--ease-standard)",
          transform: isOpen ? "rotate(45deg)" : "rotate(0)",
        }}>
          <Icon name="plus" size={18} stroke="currentColor" strokeWidth={2.2}/>
        </span>
      </button>
      <div style={{
        maxHeight: isOpen ? 400 : 0,
        overflow: "hidden",
        transition: "max-height var(--dur-slow) var(--ease-standard)",
      }}>
        <p style={{
          margin: 0, padding: "0 22px 22px",
          fontSize: 15, lineHeight: 1.65, color: "var(--fg-2)",
          maxWidth: 680,
        }}>{a}</p>
      </div>
    </div>
  );
}

window.FAQ = FAQ;
