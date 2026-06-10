// Survey v2 — multi-step form, ultra rounded, playful copy.

const { useState: useStateSv } = React;

const ROLES = [
{ id: "hogar", icon: "home", title: "Soy Hogar", blurb: "Necesito contratar servicios para mi casa." },
{ id: "pro", icon: "hammer", title: "Soy Profesional", blurb: "Quiero ofrecer mis servicios en DOMO." },
{ id: "ambos", icon: "users", title: "Ambos", blurb: "Contrato y también ofrezco mis servicios." }];


const SERVICES_LIST = [
{ id: "limpieza", label: "Limpieza", icon: "sparkles" },
{ id: "plomeria", label: "Plomería", icon: "wrench" },
{ id: "electric", label: "Electricidad", icon: "zap" },
{ id: "mascotas", label: "Mascotas", icon: "paw-print" },
{ id: "jardin", label: "Jardinería", icon: "flower-2" },
{ id: "tech", label: "Tecnología", icon: "cpu" },
{ id: "mudanzas", label: "Mudanzas", icon: "truck" },
{ id: "ninera", label: "Cuidado niños", icon: "baby" }];


const CITIES = ["Tegucigalpa", "San Pedro Sula", "La Ceiba", "Choloma", "Otra ciudad"];

function SurveyV2() {
  const [step, setStep] = useStateSv(0);
  const [data, setData] = useStateSv({
    role: "", services: [], city: "", zone: "",
    name: "", email: "", phone: ""
  });
  const TOTAL = 4;

  function update(patch) {setData((d) => ({ ...d, ...patch }));}
  function next() {setStep((s) => Math.min(s + 1, TOTAL));}
  function prev() {setStep((s) => Math.max(s - 1, 0));}

  function canAdvance() {
    if (step === 0) return !!data.role;
    if (step === 1) return data.services.length > 0;
    if (step === 2) return data.city && data.zone.trim().length > 0;
    if (step === 3) return data.name.trim() && /.+@.+\..+/.test(data.email) && data.phone.trim().length >= 7;
    return true;
  }
  function onSubmit(e) {e.preventDefault();if (canAdvance()) next();}

  const showStepper = step < TOTAL;

  return (
    <section id="registro" data-screen-label="Survey" style={{ padding: "60px 0 100px" }}>
      <div className="container">
        <div className="block white" style={{ padding: "96px 64px" }}>
          <div className="section-head section-head--center" style={{ textAlign: "center", marginBottom: 56 }}>
            <span className="eyebrow" style={{ justifyContent: "center" }}>Registro</span>
            <h2 className="tally-display tally-display--xl" style={{ marginTop: 18 }}>
              Contanos<br />
              <span className="accent">quién sos.</span>
            </h2>
            <p style={{ margin: "20px auto 0", maxWidth: 540, fontSize: 18, color: "var(--fg-2)", fontWeight: 500 }}>
              Cuatro pasos cortos, menos de un minuto. Te avisamos en cuanto DOMO llegue a tu ciudad.
            </p>
          </div>

          <div style={{ background: "#fff",
              borderRadius: 40,
              border: "1px solid var(--border-1)",
              padding: "40px 48px 44px",
              maxWidth: 720, margin: "0 auto",
              boxShadow: "0 30px 60px -28px rgba(17,22,39,0.20)"
            }}>
            {showStepper && <Stepper step={step} total={TOTAL} />}

            <form onSubmit={onSubmit} style={{ marginTop: 32 }}>
              <div key={step} className="fade-up">
                {step === 0 && <StepRole data={data} update={update} />}
                {step === 1 && <StepServices data={data} update={update} />}
                {step === 2 && <StepLocation data={data} update={update} />}
                {step === 3 && <StepContact data={data} update={update} />}
                {step === 4 && <StepSuccess data={data} />}
              </div>

              {showStepper &&
              <div style={{
                marginTop: 40,
                display: "flex", justifyContent: "space-between", alignItems: "center", gap: 12
              }}>
                  {step > 0 ?
                <Button variant="ghost" onClick={prev} icon="arrow-left" type="button">
                      Atrás
                    </Button> :
                <span />}
                  <Button
                  variant="primary" size="lg" type="submit"
                  iconRight={step === TOTAL - 1 ? "check" : "arrow-right"}
                  disabled={!canAdvance()}
                  style={{
                    opacity: canAdvance() ? 1 : 0.4,
                    cursor: canAdvance() ? "pointer" : "not-allowed"
                  }}>
                    {step === TOTAL - 1 ? "Confirmar mi lugar" : "Continuar"}
                  </Button>
                </div>
              }
            </form>
          </div>
        </div>
      </div>
    </section>);

}

function Stepper({ step, total }) {
  const labels = ["Perfil", "Servicios", "Ubicación", "Contacto"];
  return (
    <div>
      <div style={{
        display: "flex", justifyContent: "space-between", alignItems: "center",
        fontSize: 13, fontWeight: 700, color: "var(--fg-3)", marginBottom: 14
      }}>
        <span style={{ color: "var(--domo-navy)" }}>Paso {step + 1} de {total}</span>
        <span style={{ color: "var(--accent)" }}>{labels[step]}</span>
      </div>
      <div style={{ display: "flex", gap: 6 }}>
        {Array.from({ length: total }).map((_, i) =>
        <div key={i} style={{
          flex: 1, height: 6, borderRadius: 999,
          background: i <= step ? "var(--accent)" : "var(--domo-sand-200)",
          transition: "background var(--dur-base) var(--ease-standard)"
        }} />
        )}
      </div>
    </div>);

}

function StepRole({ data, update }) {
  return (
    <div>
      <StepHeader title="¿Cómo te unís a DOMO?"
      blurb="Elegí el perfil con el que comenzás. Después podés cambiarlo." />
      <div style={{
        display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 14, marginTop: 24
      }}>
        {ROLES.map((r) => {
          const selected = data.role === r.id;
          return (
            <button key={r.id} type="button" onClick={() => update({ role: r.id })}
            style={{
              background: selected ? "var(--mint-soft)" : "#fff",
              border: `2px solid ${selected ? "var(--accent)" : "var(--border-2)"}`,
              borderRadius: 22, padding: "22px 18px",
              display: "flex", flexDirection: "column", gap: 12,
              cursor: "pointer", textAlign: "left",
              transition: "all var(--dur-base) var(--ease-standard)"
            }}>
              <div style={{
                width: 48, height: 48, borderRadius: 14,
                background: selected ? "var(--accent)" : "var(--mint-soft)",
                display: "flex", alignItems: "center", justifyContent: "center",
                transition: "background var(--dur-base) var(--ease-standard)"
              }}>
                <Icon name={r.icon} size={24} stroke={selected ? "#fff" : "var(--accent)"} strokeWidth={1.8} />
              </div>
              <div>
                <div style={{
                  fontFamily: "var(--font-display)", fontWeight: 800,
                  fontSize: 17, color: "var(--domo-navy)", letterSpacing: "-0.01em"
                }}>{r.title}</div>
                <div style={{ fontSize: 13, color: "var(--fg-2)", marginTop: 4, lineHeight: 1.45 }}>
                  {r.blurb}
                </div>
              </div>
            </button>);

        })}
      </div>
    </div>);

}

function StepServices({ data, update }) {
  const isPro = data.role === "pro";
  const title = isPro ? "¿Cuál es tu especialidad?" : "¿Qué servicios usarías primero?";
  const blurb = isPro ?
  "Marcá todos los oficios en los que trabajás." :
  "Marcá los que más te interesan — esto nos ayuda a priorizar.";

  function toggle(id) {
    update({
      services: data.services.includes(id) ?
      data.services.filter((s) => s !== id) :
      [...data.services, id]
    });
  }
  return (
    <div>
      <StepHeader title={title} blurb={blurb} />
      <div style={{
        display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 10, marginTop: 24
      }}>
        {SERVICES_LIST.map((s) => {
          const selected = data.services.includes(s.id);
          return (
            <button key={s.id} type="button" onClick={() => toggle(s.id)}
            style={{
              background: selected ? "var(--mint-soft)" : "#fff",
              border: `2px solid ${selected ? "var(--accent)" : "var(--border-2)"}`,
              borderRadius: 18, padding: "16px 10px",
              display: "flex", flexDirection: "column", alignItems: "center", gap: 8,
              cursor: "pointer", position: "relative",
              transition: "all var(--dur-base) var(--ease-standard)"
            }}>
              {selected &&
              <span style={{
                position: "absolute", top: 8, right: 8,
                width: 20, height: 20, borderRadius: 999,
                background: "var(--accent)", color: "#fff",
                display: "flex", alignItems: "center", justifyContent: "center"
              }}>
                  <Icon name="check" size={12} stroke="#fff" strokeWidth={3.5} />
                </span>
              }
              <div style={{
                width: 40, height: 40, borderRadius: 12,
                background: selected ? "var(--accent)" : "var(--domo-sand-100)",
                display: "flex", alignItems: "center", justifyContent: "center"
              }}>
                <Icon name={s.icon} size={18} stroke={selected ? "#fff" : "var(--accent)"} />
              </div>
              <div style={{
                fontSize: 12, fontWeight: 700,
                color: selected ? "var(--accent)" : "var(--fg-1)"
              }}>{s.label}</div>
            </button>);

        })}
      </div>
      <div style={{ fontSize: 13, color: "var(--fg-3)", marginTop: 16, fontWeight: 500 }}>
        {data.services.length === 0 ?
        "Tocá uno o más para continuar." :
        `${data.services.length} seleccionado${data.services.length === 1 ? "" : "s"}.`}
      </div>
    </div>);

}

function StepLocation({ data, update }) {
  return (
    <div>
      <StepHeader title="¿Dónde está tu hogar?"
      blurb="Lanzamos zona por zona. Esto nos ayuda a priorizar tu colonia." />
      <div style={{ display: "flex", flexDirection: "column", gap: 18, marginTop: 24 }}>
        <div className="field">
          <label>Ciudad</label>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(5, 1fr)", gap: 8 }}>
            {CITIES.map((c) => {
              const selected = data.city === c;
              return (
                <button key={c} type="button" onClick={() => update({ city: c })}
                style={{
                  padding: "12px 8px", borderRadius: 999,
                  border: `2px solid ${selected ? "var(--accent)" : "var(--border-2)"}`,
                  background: selected ? "var(--accent)" : "#fff",
                  color: selected ? "#fff" : "var(--fg-1)",
                  fontSize: 13, fontWeight: 700, cursor: "pointer",
                  transition: "all var(--dur-base) var(--ease-standard)"
                }}>{c}</button>);

            })}
          </div>
        </div>
        <div className="field">
          <label>Colonia / Zona</label>
          <input
            type="text"
            placeholder="Ej. Lomas del Mayab, Col. Palmira"
            value={data.zone}
            onChange={(e) => update({ zone: e.target.value })} />
          
          <span className="hint">Solo lo usamos para avisarte cuando lleguemos a tu colonia.</span>
        </div>
      </div>
    </div>);

}

function StepContact({ data, update }) {
  return (
    <div>
      <StepHeader title="¿A dónde te avisamos?"
      blurb="Te escribimos por correo y WhatsApp cuando DOMO esté listo." />
      <div style={{ display: "flex", flexDirection: "column", gap: 16, marginTop: 24 }}>
        <div className="field">
          <label>Nombre completo</label>
          <input type="text" placeholder="María Castro"
          value={data.name} onChange={(e) => update({ name: e.target.value })} />
        </div>
        <div className="field">
          <label>Correo electrónico</label>
          <input type="email" placeholder="maria@correo.com"
          value={data.email} onChange={(e) => update({ email: e.target.value })} />
        </div>
        <div className="field">
          <label>WhatsApp</label>
          <input type="tel" placeholder="+504 9876-5432"
          value={data.phone} onChange={(e) => update({ phone: e.target.value })} />
          <span className="hint">Solo te escribimos cuando haya novedades importantes.</span>
        </div>

        <div style={{
          display: "flex", alignItems: "flex-start", gap: 12,
          padding: "16px 18px",
          background: "var(--mint-soft)",
          borderRadius: 18, marginTop: 6
        }}>
          <Icon name="lock" size={16} stroke="var(--mint)" strokeWidth={2} />
          <span style={{ fontSize: 13, color: "var(--fg-2)", lineHeight: 1.5, fontWeight: 500 }}>
            Tus datos quedan protegidos. No los compartimos con nadie — promesa de Fundador 🤝.
          </span>
        </div>
      </div>
    </div>);

}

function StepSuccess({ data }) {
  const firstName = data.name.split(" ")[0] || "amig@";
  return (
    <div style={{ textAlign: "center", padding: "16px 0 8px" }}>
      <div style={{
        width: 88, height: 88, borderRadius: 999,
        background: "var(--accent)",
        display: "inline-flex", alignItems: "center", justifyContent: "center",
        margin: "0 auto 28px",
        position: "relative"
      }}>
        <div style={{
          position: "absolute", inset: -10, borderRadius: 999,
          border: "2px solid var(--accent)", opacity: 0.20
        }} />
        <Icon name="check" size={44} stroke="#fff" strokeWidth={3} />
      </div>
      <h3 className="tally-display tally-display--md" style={{ margin: 0 }}>
        ¡Estás dentro, <span className="accent">{firstName}!</span>
      </h3>
      <p style={{
        margin: "16px auto 28px", maxWidth: 460,
        fontSize: 16, lineHeight: 1.55, color: "var(--fg-2)", fontWeight: 500
      }}>
        Reservamos tu lugar como <strong style={{ color: "var(--domo-navy)" }}>Miembro Fundador</strong>.
        Te escribimos a <strong style={{ color: "var(--domo-navy)" }}>{data.email || "tu correo"}</strong> cuando
        DOMO esté listo en {data.city || "tu ciudad"}.
      </p>
      <div style={{
        display: "inline-flex", flexDirection: "column", gap: 12,
        background: "var(--domo-sand-100)",
        borderRadius: 22, padding: "20px 26px",
        textAlign: "left"
      }}>
        {[
        "Vas a recibir un correo de bienvenida en menos de 10 min.",
        "Te incluimos en el canal de WhatsApp de Fundadores.",
        "Mantenés tu tarifa fundador para siempre."].
        map((line) =>
        <div key={line} style={{
          display: "flex", alignItems: "center", gap: 12,
          fontSize: 14, color: "var(--fg-1)", fontWeight: 500
        }}>
            <Icon name="check-circle-2" size={20} stroke="var(--mint)" />
            {line}
          </div>
        )}
      </div>
    </div>);

}

function StepHeader({ title, blurb }) {
  return (
    <div>
      <h3 className="tally-display tally-display--md" style={{ margin: 0 }}>{title}</h3>
      <p style={{ margin: "12px 0 0", fontSize: 16, color: "var(--fg-2)", lineHeight: 1.55, fontWeight: 500 }}>
        {blurb}
      </p>
    </div>);

}

window.SurveyV2 = SurveyV2;