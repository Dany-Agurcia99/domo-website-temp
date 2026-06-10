// Hero v2 — Tally Latam style: HUGE bold headline, mixed colors,
// playful voice, phone mockup on the right, vertical accent line motif.

function HeroV2() {
  return (
    <section id="top" data-screen-label="Hero" style={{
      padding: "104px 0 96px",
      marginTop: -68,
      position: "relative", overflow: "hidden",
      background: "linear-gradient(120deg, #153843 0%, #121728 100%)"
    }}>
      <div className="container">
        <div style={{
          display: "flex", flexDirection: "column", alignItems: "center",
          textAlign: "center", paddingTop: 24, maxWidth: 1080, margin: "0 auto"
        }}>
          {/* Static DOMO icon — top, no bubble, no animation */}
          <div className="fade-up" style={{
            display: "flex", justifyContent: "center", alignItems: "center",
            marginBottom: 24
          }}>
            <img
              src="assets/domo-isotipo-white.png"
              alt="DOMO"
              draggable="false"
              style={{
                display: "block",
                filter: "drop-shadow(0 24px 40px rgba(0,0,0,0.4))",
                userSelect: "none", width: "400px", height: "400px"
              }} />
            
          </div>

          {/* Headline */}
          <h1 className="tally-display tally-display--xxl fade-up d1" style={{
            maxWidth: 1060, color: "#fff"
          }}>
            <span style={{ color: "#fff" }}>La app que arregla tu hogar</span>{" "}
            <span style={{ color: "#BCD476" }}>en un solo toque.</span>
          </h1>

          {/* Subtext */}
          <p className="fade-up d2" style={{
            margin: "28px 0 0", maxWidth: 580,
            color: "rgba(255,255,255,0.82)", fontSize: 20, lineHeight: 1.55, fontWeight: 500
          }}>
            Plomería, limpieza, electricidad, mascotas y más. Técnicos verificados y precio
            acordado, sin grupos de WhatsApp ni sorpresas al final.
          </p>

          {/* CTA */}
          <div className="fade-up d3" style={{ marginTop: 36 }}>
            <a href="#registro" style={{ textDecoration: "none" }}>
              <Button variant="primary" size="xl" iconRight="arrow-right"
                style={{ background: "#BCD476", color: "#0F1626" }}>
                Únete al piloto
              </Button>
            </a>
          </div>
        </div>
      </div>
    </section>);

}

function HeroIcon() {
  const [tilt, setTilt] = React.useState({ rx: 0, ry: 0 });

  function onMove(e) {
    const r = e.currentTarget.getBoundingClientRect();
    const px = (e.clientX - r.left) / r.width - 0.5; // -0.5 .. 0.5
    const py = (e.clientY - r.top) / r.height - 0.5;
    setTilt({ rx: -py * 16, ry: px * 20 }); // degrees
  }
  function onLeave() {setTilt({ rx: 0, ry: 0 });}

  return (
    <div
      onMouseMove={onMove}
      onMouseLeave={onLeave}
      style={{
        position: "relative",
        width: 300, height: 300,
        display: "flex", justifyContent: "center", alignItems: "center",
        perspective: 1200
      }}>
      {/* Tilt layer (mouse parallax) */}
      <div style={{
        position: "relative", zIndex: 2,
        transform: `rotateX(${tilt.rx}deg) rotateY(${tilt.ry}deg)`,
        transformStyle: "preserve-3d",
        transition: "transform 0.25s var(--ease-out-soft)",
        willChange: "transform"
      }}>
        {/* Float layer (continuous bob) */}
        <div className="hero-icon-float" style={{ transformStyle: "preserve-3d" }}>
          <img
            src="assets/domo-isotipo-hero.png"
            alt="DOMO"
            draggable="false"
            style={{
              width: 240, height: 240, display: "block",
              transform: "translateZ(60px)",
              filter: "drop-shadow(0 30px 40px rgba(17,22,39,0.22))",
              userSelect: "none"
            }} />
          
        </div>
      </div>
    </div>);

}

/* ---------- The phone home preview (reused from v1 idea) ---------- */
function AppHomePreview() {
  const services = [
  { name: "Limpieza", icon: "sparkles" },
  { name: "Plomería", icon: "wrench" },
  { name: "Mascotas", icon: "paw-print" },
  { name: "Técnico", icon: "cpu" },
  { name: "Jardín", icon: "flower-2" },
  { name: "Mudanza", icon: "truck" }];

  return (
    <div style={{
      width: "100%", height: "100%",
      background: "var(--mint-soft)",
      display: "flex", flexDirection: "column",
      paddingTop: 52
    }}>
      <div style={{
        display: "flex", justifyContent: "space-between",
        padding: "0 24px 8px", fontSize: 11, fontWeight: 700,
        color: "var(--domo-navy)"
      }}>
        <span>9:41</span>
        <span style={{ display: "inline-flex", gap: 4, alignItems: "center" }}>
          <Icon name="wifi" size={12} stroke="var(--domo-navy)" strokeWidth={2.2} />
          <Icon name="battery-full" size={14} stroke="var(--domo-navy)" strokeWidth={2.2} />
        </span>
      </div>

      <div style={{ padding: "10px 20px 6px" }}>
        <div style={{ fontSize: 11, color: "var(--fg-3)", fontWeight: 600 }}>Hola, María 👋</div>
        <div style={{
          fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 22,
          color: "var(--domo-navy)", letterSpacing: "-0.02em", marginTop: 2,
          lineHeight: 1.1
        }}>¿Qué necesitas hoy?</div>
      </div>

      <div style={{ padding: "10px 20px 4px" }}>
        <div style={{
          background: "#fff",
          borderRadius: 16, padding: "12px 14px",
          display: "flex", alignItems: "center", gap: 10,
          fontSize: 12, color: "var(--fg-3)",
          boxShadow: "var(--shadow-1)",
          border: "1px solid var(--border-1)"
        }}>
          <Icon name="search" size={14} stroke="var(--fg-3)" />
          Buscar un servicio…
        </div>
      </div>

      <div style={{
        padding: "16px 20px 10px",
        display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 10
      }}>
        {services.map((s) =>
        <div key={s.name} style={{
          background: "#fff",
          border: "1px solid var(--border-1)",
          borderRadius: 18, padding: "14px 8px",
          display: "flex", flexDirection: "column", alignItems: "center", gap: 6
        }}>
            <div style={{
            width: 36, height: 36, borderRadius: 12,
            background: "var(--mint-soft)",
            display: "flex", alignItems: "center", justifyContent: "center"
          }}>
              <Icon name={s.icon} size={18} stroke="var(--mint)" />
            </div>
            <div style={{ fontSize: 10.5, fontWeight: 700, color: "var(--domo-navy)" }}>
              {s.name}
            </div>
          </div>
        )}
      </div>

      <div style={{ padding: "12px 20px 0" }}>
        <div style={{
          background: "var(--accent)", color: "#fff",
          borderRadius: 20, padding: 14,
          display: "flex", alignItems: "center", gap: 12
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 999,
            background: "rgba(255,255,255,0.18)",
            color: "#fff", display: "flex", alignItems: "center", justifyContent: "center",
            fontFamily: "var(--font-display)", fontWeight: 800, fontSize: 14
          }}>CR</div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: "#fff" }}>
              Carlos Reyes
            </div>
            <div style={{ fontSize: 10.5, color: "rgba(255,255,255,0.78)", marginTop: 2 }}>
              Plomería · ⭐ 5.0 · 142
            </div>
          </div>
          <div style={{
            background: "#fff", color: "var(--accent)",
            padding: "8px 12px", borderRadius: 999,
            fontSize: 11, fontWeight: 800
          }}>
            Agendar
          </div>
        </div>
      </div>

      <div style={{
        marginTop: "auto",
        padding: "12px 16px 22px",
        display: "flex", justifyContent: "space-around",
        background: "rgba(255,255,255,0.92)",
        borderTop: "1px solid var(--border-1)"
      }}>
        {[
        { name: "home", active: true },
        { name: "calendar", active: false },
        { name: "message-circle", active: false },
        { name: "user", active: false }].
        map((t) =>
        <div key={t.name} style={{
          display: "flex", flexDirection: "column", alignItems: "center", gap: 4,
          color: t.active ? "var(--accent)" : "var(--fg-3)"
        }}>
            <Icon name={t.name} size={18} stroke="currentColor" strokeWidth={t.active ? 2.4 : 1.8} />
            {t.active && <span style={{
            width: 4, height: 4, borderRadius: 999, background: "var(--accent)"
          }} />}
          </div>
        )}
      </div>
    </div>);

}

window.HeroV2 = HeroV2;