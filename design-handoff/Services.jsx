// How It Works v2 — full-bleed, scroll-driven. A large phone pins in view and
// crossfades through the REAL app screens (categories → fecha/hora → taskers)
// while a vertical progress rail tracks the active step. Copy sits on the left.

const HIW_LIME = "#B5DB6A";        // in-app lime accent (matches screenshots)
const HIW_BG   = "#0E0F12";        // app screen background
const HIW_TILE = "#1A1C20";        // app card/tile
const HIW_TILE2= "#232529";        // app card hover/secondary

const STEPS = [
  {
    n: "01",
    title: "Elegí un servicio",
    desc: "Más de cinco categorías verificadas. Tocá la que necesitás y empezá en segundos — sin grupos de WhatsApp ni mil mensajes.",
    screen: "categories",
  },
  {
    n: "02",
    title: "Agendá día y hora",
    desc: "Elegí la fecha y el horario que mejor te quede. Reservás directo en la app, sin llamadas ni esperas eternas.",
    screen: "schedule",
  },
  {
    n: "03",
    title: "Recibí especialistas",
    desc: "Te mostramos taskers verificados cerca de vos — con reseñas reales, nivel de experiencia y precio claro desde el inicio.",
    screen: "taskers",
  },
];

function HowItWorksV2() {
  const sectionRef = React.useRef(null);
  const [progress, setProgress] = React.useState(0);
  const [active, setActive] = React.useState(0);

  React.useEffect(() => {
    let raf = 0;
    const onScroll = () => {
      if (raf) return;
      raf = requestAnimationFrame(() => {
        raf = 0;
        const el = sectionRef.current;
        if (!el) return;
        const rect = el.getBoundingClientRect();
        const total = el.offsetHeight - window.innerHeight;
        const scrolled = Math.min(Math.max(-rect.top, 0), Math.max(total, 1));
        const p = total > 0 ? scrolled / total : 0;
        setProgress(p);
        const idx = Math.min(STEPS.length - 1, Math.floor(p * STEPS.length * 0.999));
        setActive(idx < 0 ? 0 : idx);
      });
    };
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    return () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
      if (raf) cancelAnimationFrame(raf);
    };
  }, []);

  return (
    <section
      id="como-funciona"
      data-screen-label="How It Works"
      ref={sectionRef}
      style={{ position: "relative", height: `${STEPS.length * 100}vh` }}>

      {/* Pinned full-viewport stage */}
      <div style={{
        position: "sticky", top: 0, height: "100vh",
        display: "flex", flexDirection: "column",
        overflow: "hidden",
        background: "var(--domo-navy)",
      }}>
        {/* ambient brand glow */}
        <div aria-hidden style={{
          position: "absolute", inset: 0, pointerEvents: "none",
          background:
            "radial-gradient(circle at 20% 30%, rgba(115,195,175,0.16) 0%, transparent 45%)," +
            "radial-gradient(circle at 80% 75%, rgba(181,219,106,0.10) 0%, transparent 50%)",
        }} />

        {/* Heading */}
        <div className="hiw-head">
          <h2 className="tally-display tally-display--lg" style={{ color: "#fff", marginTop: 12 }}>
            Tu hogar resuelto en{" "}
            <span style={{ color: HIW_LIME }}>tres pasos.</span>
          </h2>
        </div>

        {/* Full-bleed stage */}
        <div className="hiw-stage">
          {/* Left: rail + copy */}
          <div className="hiw-copy">
            <ProgressRail active={active} progress={progress} />
            <div style={{ position: "relative", flex: 1, minHeight: 260 }}>
              {STEPS.map((s, i) => (
                <div key={s.n} style={{
                  position: "absolute", inset: 0,
                  display: "flex", flexDirection: "column", justifyContent: "center",
                  opacity: i === active ? 1 : 0,
                  transform: i === active ? "translateY(0)" : "translateY(20px)",
                  transition: "opacity 0.5s var(--ease-out-soft), transform 0.5s var(--ease-out-soft)",
                  pointerEvents: i === active ? "auto" : "none",
                }}>
                  <div style={{
                    fontFamily: "var(--font-display)", fontWeight: 800,
                    fontSize: 16, letterSpacing: "0.16em", color: HIW_LIME, marginBottom: 14,
                  }}>PASO {s.n}</div>
                  <h3 className="tally-display" style={{
                    margin: 0, color: "#fff", fontSize: 52, lineHeight: 1.02, letterSpacing: "-0.03em",
                  }}>{s.title}</h3>
                  <p style={{
                    margin: "22px 0 0", maxWidth: 460,
                    color: "rgba(255,255,255,0.66)", fontSize: 19, lineHeight: 1.6, fontWeight: 500,
                  }}>{s.desc}</p>
                </div>
              ))}
            </div>
          </div>

          {/* Right: big phone crossfading screens */}
          <div className="hiw-phone-wrap">
            <PhoneFrame>
              {STEPS.map((s, i) => (
                <div key={s.n} style={{
                  position: "absolute", inset: 0,
                  opacity: i === active ? 1 : 0,
                  transform: i === active ? "scale(1)" : "scale(0.98)",
                  transition: "opacity 0.55s var(--ease-out-soft), transform 0.55s var(--ease-out-soft)",
                  pointerEvents: i === active ? "auto" : "none",
                }}>
                  <AppScreen screen={s.screen} />
                </div>
              ))}
            </PhoneFrame>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ---------------- Progress rail (vertical) ---------------- */
function ProgressRail({ active, progress }) {
  return (
    <div className="hiw-rail">
      <div style={{
        position: "relative", width: 5, borderRadius: 999,
        background: "rgba(255,255,255,0.14)", flexShrink: 0, alignSelf: "stretch",
      }}>
        <div style={{
          position: "absolute", top: 0, left: 0, width: "100%",
          height: `${progress * 100}%`,
          background: `linear-gradient(180deg, ${HIW_LIME}, var(--mint))`, borderRadius: 999,
          transition: "height 0.1s linear",
        }} />
        {STEPS.map((s, i) => {
          const frac = STEPS.length === 1 ? 0 : i / (STEPS.length - 1);
          const done = i <= active;
          return (
            <div key={s.n} style={{
              position: "absolute", top: `${frac * 100}%`, left: "50%",
              transform: "translate(-50%, -50%)",
              width: i === active ? 22 : 16, height: i === active ? 22 : 16, borderRadius: 999,
              background: done ? HIW_LIME : "var(--domo-navy)",
              border: `2px solid ${done ? HIW_LIME : "rgba(255,255,255,0.3)"}`,
              display: "flex", alignItems: "center", justifyContent: "center",
              boxShadow: i === active ? `0 0 0 7px rgba(181,219,106,0.18)` : "none",
              transition: "all var(--dur-base) var(--ease-standard)",
            }}>
              {done && i !== active && (
                <Icon name="check" size={9} stroke="var(--domo-navy)" strokeWidth={3.5} />
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

/* ---------------- Phone frame ---------------- */
function PhoneFrame({ children }) {
  return (
    <div className="hiw-phone">
      <div className="hiw-phone__notch" />
      <div className="hiw-phone__screen" style={{ background: HIW_BG }}>
        {/* status bar */}
        <div style={{
          display: "flex", justifyContent: "space-between", alignItems: "center",
          padding: "14px 24px 6px", color: "#fff", position: "relative", zIndex: 5,
        }}>
          <span style={{ fontSize: 13, fontWeight: 700 }}>8:42</span>
          <span style={{ display: "inline-flex", gap: 5, alignItems: "center", opacity: 0.9 }}>
            <Icon name="signal" size={13} stroke="#fff" strokeWidth={2.4} />
            <Icon name="wifi" size={13} stroke="#fff" strokeWidth={2.4} />
            <Icon name="battery-full" size={15} stroke="#fff" strokeWidth={2.4} />
          </span>
        </div>
        <div style={{ position: "relative", flex: 1, overflow: "hidden" }}>
          {children}
        </div>
      </div>
    </div>
  );
}

/* ---------------- App screens ---------------- */
function AppScreen({ screen }) {
  if (screen === "categories") return <ScreenCategories />;
  if (screen === "schedule") return <ScreenSchedule />;
  return <ScreenTaskers />;
}

const CATS = [
  { title: "Cerrajería",       img: "assets/categories/locks.png" },
  { title: "Electrodomésticos", img: "assets/categories/appliances.png" },
  { title: "Limpieza",         img: "assets/categories/cleaning.png" },
  { title: "Plomería",         img: "assets/categories/plumbing.png" },
  { title: "Electricidad",     img: "assets/categories/electrical.png" },
];

function ScreenCategories() {
  return (
    <div style={{ padding: "20px 22px", height: "100%", overflow: "hidden" }}>
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 20 }}>
        <div style={{ fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 26, color: "#fff", letterSpacing: "-0.02em" }}>
          Categorías
        </div>
        <div style={{ fontSize: 14, fontWeight: 700, color: HIW_LIME }}>Ver más</div>
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 14 }}>
        {CATS.map((c, i) => (
          <div key={c.title} style={{
            background: HIW_TILE, borderRadius: 22,
            padding: "18px 12px 14px",
            display: "flex", flexDirection: "column", alignItems: "center", gap: 10,
            border: i === 0 ? `1.5px solid ${HIW_LIME}` : "1.5px solid transparent",
          }}>
            <div style={{
              width: 72, height: 72, borderRadius: 18,
              background: "rgba(255,255,255,0.04)",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>
              <img src={c.img} alt={c.title} draggable="false"
                   style={{ width: 52, height: 52, objectFit: "contain",
                            filter: "drop-shadow(0 6px 8px rgba(0,0,0,0.4))" }} />
            </div>
            <div style={{ fontSize: 12.5, fontWeight: 700, color: "#fff", textAlign: "center", lineHeight: 1.15 }}>
              {c.title}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function ScreenSchedule() {
  const days = [
    { d: "Lun", n: 1 }, { d: "Mar", n: 2 }, { d: "Mié", n: 3 }, { d: "Jue", n: 4 }, { d: "Vie", n: 5 },
  ];
  const times = ["9:00 a.m", "9:30 a.m", "10:00 a.m", "10:30 a.m", "11:00 a.m", "11:30 a.m"];
  return (
    <div style={{ padding: "20px 22px", height: "100%", overflow: "hidden" }}>
      <div style={{ fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 21, color: "#fff", marginBottom: 14, letterSpacing: "-0.01em" }}>
        Selecciona una fecha
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(5, 1fr)", gap: 8, marginBottom: 26 }}>
        {days.map((day) => {
          const active = day.n === 3;
          return (
            <div key={day.n} style={{
              background: active ? HIW_LIME : HIW_TILE,
              borderRadius: 16, padding: "12px 0",
              display: "flex", flexDirection: "column", alignItems: "center", gap: 4,
            }}>
              <span style={{ fontSize: 11, fontWeight: 600, color: active ? "rgba(14,15,18,0.7)" : "rgba(255,255,255,0.6)" }}>{day.d}</span>
              <span style={{ fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 18, color: active ? "#0E0F12" : "#fff" }}>{day.n}</span>
            </div>
          );
        })}
      </div>

      <div style={{ fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 21, color: "#fff", marginBottom: 14, letterSpacing: "-0.01em" }}>
        Selecciona una hora
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 10 }}>
        {times.map((t, i) => (
          <div key={t} style={{
            background: i === 3 ? HIW_LIME : HIW_TILE,
            color: i === 3 ? "#0E0F12" : "#fff",
            borderRadius: 999, padding: "13px 0", textAlign: "center",
            fontSize: 13.5, fontWeight: 700,
          }}>{t}</div>
        ))}
      </div>
      <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 8, marginTop: 20 }}>
        <div style={{ display: "flex", gap: 6 }}>
          {[0,1,2,3,4].map((d) => (
            <span key={d} style={{
              width: d === 0 ? 18 : 6, height: 6, borderRadius: 999,
              background: d === 0 ? HIW_LIME : "rgba(255,255,255,0.22)",
            }} />
          ))}
        </div>
        <span style={{ fontSize: 11.5, color: "rgba(255,255,255,0.4)" }}>Desliza para ver más horarios</span>
      </div>
    </div>
  );
}

const TASKERS = [
  {
    name: "Carlos Reyes", initials: "CR",
    grad: "linear-gradient(135deg, #19535A, #5EAEB1)",
    rating: "4.9", reviews: 87, tier: "Diamante", tierColor: "#9B7BE8", tierBg: "rgba(120,86,209,0.22)",
    jobs: "120 trabajos en Plomería",
    spec: "Especialista en fugas y calentadores",
    quote: "Resolvió mi fuga en 30 minutos. Puntual y muy limpio.",
  },
  {
    name: "María Banegas", initials: "MB",
    grad: "linear-gradient(135deg, #BCD476, #73C3AF)",
    rating: "5.0", reviews: 142, tier: "Oro", tierColor: "#E7C45A", tierBg: "rgba(231,196,90,0.18)",
    jobs: "200 trabajos en Limpieza",
    spec: "Limpieza profunda y post-mudanza",
    quote: "Dejó mi casa impecable. La vuelvo a contratar sin dudar.",
  },
];

function ScreenTaskers() {
  return (
    <div style={{ padding: "16px 20px", height: "100%", overflow: "hidden" }}>
      <Icon name="chevron-left" size={22} stroke={HIW_LIME} strokeWidth={2.6} />
      <div style={{ fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 24, color: "#fff", margin: "8px 0 14px", letterSpacing: "-0.02em" }}>
        Taskers disponibles
      </div>
      <div style={{ display: "flex", gap: 8, marginBottom: 18 }}>
        {["Precio", "Fecha", "Hora"].map((f) => (
          <div key={f} style={{
            flex: 1, border: "1px solid rgba(255,255,255,0.16)", borderRadius: 12,
            padding: "9px 10px", display: "flex", alignItems: "center", justifyContent: "space-between",
            color: "rgba(255,255,255,0.85)", fontSize: 12, fontWeight: 600,
          }}>
            {f}
            <Icon name="chevron-down" size={13} stroke="rgba(255,255,255,0.6)" strokeWidth={2.4} />
          </div>
        ))}
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 14 }}>
        <div style={{ flex: 1, height: 1, background: `linear-gradient(90deg, transparent, ${HIW_LIME})` }} />
        <span style={{ fontSize: 13, fontWeight: 800, color: HIW_LIME, letterSpacing: "0.02em" }}>Especialistas</span>
        <div style={{ flex: 1, height: 1, background: `linear-gradient(90deg, ${HIW_LIME}, transparent)` }} />
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
        {TASKERS.map((t) => (
          <div key={t.name} style={{ background: HIW_TILE, borderRadius: 18, padding: 14 }}>
            <div style={{ display: "flex", gap: 12 }}>
              <div style={{ position: "relative", flexShrink: 0 }}>
                <div style={{
                  width: 52, height: 52, borderRadius: 999, background: t.grad,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 16, color: "#fff",
                }}>{t.initials}</div>
                <div style={{
                  position: "absolute", bottom: -2, right: -2,
                  width: 20, height: 20, borderRadius: 999, background: "#2F9E5B",
                  border: "2px solid " + HIW_TILE,
                  display: "flex", alignItems: "center", justifyContent: "center",
                }}>
                  <Icon name="check" size={11} stroke="#fff" strokeWidth={3.5} />
                </div>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 16, color: "#fff" }}>{t.name}</div>
                <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 3 }}>
                  <Icon name="star" size={13} stroke="none" fill={HIW_LIME} />
                  <span style={{ fontSize: 12.5, color: "rgba(255,255,255,0.8)", fontWeight: 600 }}>{t.rating} · {t.reviews} reseñas</span>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 7 }}>
                  <span style={{
                    fontSize: 11, fontWeight: 800, color: t.tierColor, background: t.tierBg,
                    padding: "3px 9px", borderRadius: 999,
                  }}>◆ {t.tier}</span>
                  <span style={{ fontSize: 11, color: "rgba(255,255,255,0.45)" }}>{t.jobs}</span>
                </div>
              </div>
            </div>
            <div style={{ fontSize: 13, fontWeight: 700, color: HIW_LIME, marginTop: 12 }}>{t.spec}</div>
            <div style={{ fontSize: 12.5, color: "rgba(255,255,255,0.6)", marginTop: 5, fontStyle: "italic", lineHeight: 1.4 }}>
              “{t.quote}”
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

window.HowItWorksV2 = HowItWorksV2;
