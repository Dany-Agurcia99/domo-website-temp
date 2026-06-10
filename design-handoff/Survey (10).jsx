// How It Works — 3 steps showing the actual service flow.
// Each step has a visual snippet that hints at the in-app moment.

const STEPS = [
  {
    n: "01",
    title: "Elige un servicio",
    blurb: "Plomería, limpieza, electricidad o mascotas — escogés desde el catálogo en segundos.",
    visual: "service",
  },
  {
    n: "02",
    title: "Recibe técnicos recomendados",
    blurb: "DOMO te muestra profesionales verificados cerca de vos, con reseñas y precio acordado.",
    visual: "match",
  },
  {
    n: "03",
    title: "Agenda y resuelve rápido",
    blurb: "Confirmás el día y la hora. El técnico llega, hace el trabajo y pagás directo en la app.",
    visual: "schedule",
  },
];

function HowItWorks() {
  return (
    <section id="como-funciona" data-screen-label="How It Works" style={{background: "var(--domo-white)"}}>
      <div className="container">
        <div className="section-head">
          <span className="eyebrow">Cómo funciona</span>
          <h2>Tres pasos. Cero filas. Cero estrés.</h2>
          <p>Encontrar a la persona indicada para tu hogar no debería tardar más que pedir comida.</p>
        </div>

        <div style={{
          display: "grid",
          gridTemplateColumns: "repeat(3, 1fr)",
          gap: 28,
        }}>
          {STEPS.map((s, i) => (
            <Step key={s.n} {...s} isLast={i === STEPS.length - 1}/>
          ))}
        </div>
      </div>
    </section>
  );
}

function Step({ n, title, blurb, visual, isLast }) {
  return (
    <div style={{
      position: "relative",
      display: "flex", flexDirection: "column", gap: 18,
    }}>
      {/* Big faded numeral */}
      <span style={{
        fontFamily: "var(--font-display)", fontWeight: 800,
        fontSize: 80, lineHeight: 0.9, letterSpacing: "-0.04em",
        color: "var(--domo-sand-200)",
        fontVariantNumeric: "tabular-nums",
      }}>{n}</span>

      {/* Visual mini-card */}
      <StepVisual visual={visual}/>

      <div>
        <h3 style={{
          margin: 0,
          fontFamily: "var(--font-display)", fontWeight: 700,
          fontSize: 22, letterSpacing: "-0.01em",
          color: "var(--domo-navy)",
        }}>{title}</h3>
        <p style={{
          margin: "10px 0 0",
          fontSize: 15, lineHeight: 1.55,
          color: "var(--fg-2)",
          maxWidth: 340,
        }}>{blurb}</p>
      </div>
    </div>
  );
}

/* ---------- Per-step visual snippets ---------- */
function StepVisual({ visual }) {
  if (visual === "service") {
    return (
      <Card>
        <div style={{
          display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 10,
        }}>
          {[
            { name: "Limpieza", icon: "sparkles",  active: true },
            { name: "Plomería", icon: "wrench",    active: false },
            { name: "Mascotas", icon: "paw-print", active: false },
          ].map(s => (
            <div key={s.name} style={{
              border: `1.5px solid ${s.active ? "var(--accent)" : "var(--border-1)"}`,
              background: s.active ? "var(--domo-teal-50)" : "#fff",
              borderRadius: 12, padding: "12px 8px",
              display: "flex", flexDirection: "column", alignItems: "center", gap: 6,
              transition: "all var(--dur-base) var(--ease-standard)",
            }}>
              <Icon name={s.icon} size={20} stroke={s.active ? "var(--accent)" : "var(--fg-2)"}/>
              <div style={{fontSize: 11, fontWeight: 600, color: s.active ? "var(--accent)" : "var(--fg-2)"}}>
                {s.name}
              </div>
            </div>
          ))}
        </div>
      </Card>
    );
  }

  if (visual === "match") {
    return (
      <Card>
        <div style={{display: "flex", flexDirection: "column", gap: 10}}>
          {[
            { name: "Carlos R.", note: "Plomería · 142 trabajos", stars: 5, grad: "linear-gradient(135deg, #19535A, #5EAEB1)", initials: "CR", active: true },
            { name: "Luis A.",   note: "Plomería · 88 trabajos",  stars: 5, grad: "linear-gradient(135deg, #111627, #19535A)", initials: "LA", active: false },
          ].map(p => (
            <div key={p.name} style={{
              display: "flex", alignItems: "center", gap: 10,
              padding: "10px 12px",
              background: p.active ? "var(--domo-teal-50)" : "#fff",
              border: `1.5px solid ${p.active ? "var(--accent)" : "var(--border-1)"}`,
              borderRadius: 12,
            }}>
              <div style={{
                width: 32, height: 32, borderRadius: 999,
                background: p.grad, color: "#fff",
                display: "flex", alignItems: "center", justifyContent: "center",
                fontFamily: "var(--font-display)", fontWeight: 700, fontSize: 11,
              }}>{p.initials}</div>
              <div style={{flex: 1, minWidth: 0}}>
                <div style={{fontSize: 12, fontWeight: 600, color: "var(--domo-navy)"}}>{p.name}</div>
                <div style={{fontSize: 10.5, color: "var(--fg-3)", marginTop: 1}}>{p.note}</div>
              </div>
              {p.active && (
                <Icon name="check-circle-2" size={18} stroke="var(--accent)"/>
              )}
            </div>
          ))}
        </div>
      </Card>
    );
  }

  // schedule
  return (
    <Card>
      <div>
        <div style={{
          fontSize: 11, fontWeight: 700, letterSpacing: "0.10em",
          textTransform: "uppercase", color: "var(--fg-3)", marginBottom: 8,
        }}>Mañana · Mar 12</div>
        <div style={{display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 6}}>
          {[
            { t: "9:00",  active: false },
            { t: "10:30", active: true },
            { t: "13:00", active: false },
            { t: "15:30", active: false },
          ].map(s => (
            <div key={s.t} style={{
              padding: "10px 0", textAlign: "center",
              border: `1.5px solid ${s.active ? "var(--accent)" : "var(--border-1)"}`,
              background: s.active ? "var(--accent)" : "#fff",
              color: s.active ? "#fff" : "var(--fg-1)",
              borderRadius: 10, fontSize: 12, fontWeight: 600,
            }}>{s.t}</div>
          ))}
        </div>
        <div style={{
          marginTop: 12,
          background: "var(--accent)", color: "#fff",
          padding: "10px 12px", borderRadius: 10,
          fontSize: 12, fontWeight: 600,
          display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
        }}>
          Confirmar reserva
          <Icon name="arrow-right" size={14} stroke="#fff" strokeWidth={2.4}/>
        </div>
      </div>
    </Card>
  );
}

function Card({ children }) {
  return (
    <div style={{
      background: "var(--domo-sand-50)",
      border: "1px solid var(--border-1)",
      borderRadius: 18,
      padding: 16,
      minHeight: 168,
    }}>{children}</div>
  );
}

window.HowItWorks = HowItWorks;
