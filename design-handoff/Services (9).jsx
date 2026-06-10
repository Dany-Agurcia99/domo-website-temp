// Hero — banner inicial. Headline + supporting text + CTA + app mockup.
// Two-column premium startup look (Airbnb / Linear / Stripe inspired).

function Hero() {
  return (
    <section id="top" data-screen-label="Hero" style={{
      padding: "40px 0 96px",
      position: "relative", overflow: "hidden",
    }}>
      {/* Soft ambient color in the background */}
      <div aria-hidden style={{
        position: "absolute", inset: 0, pointerEvents: "none", zIndex: 0,
        background:
          "radial-gradient(circle at 12% 0%, rgba(94,174,177,0.10), transparent 45%)," +
          "radial-gradient(circle at 95% 35%, rgba(248,244,233,0.65), transparent 50%)",
      }}/>
      <div className="container" style={{position: "relative", zIndex: 1}}>
        <div style={{
          display: "grid",
          gridTemplateColumns: "minmax(0, 1.05fr) minmax(0, 1fr)",
          gap: 56, alignItems: "center",
          paddingTop: 24,
        }}>
          {/* Left: copy */}
          <div>
            <div className="fade-up" style={{
              display: "inline-flex", alignItems: "center", gap: 10,
              padding: "8px 14px", borderRadius: 999,
              background: "var(--domo-teal-50)",
              border: "1px solid rgba(25,83,90,0.12)",
              color: "var(--accent)",
              fontSize: 13, fontWeight: 600,
            }}>
              <span style={{
                width: 6, height: 6, borderRadius: 999, background: "var(--accent)",
                boxShadow: "0 0 0 4px rgba(25,83,90,0.18)",
              }}/>
              Pre-lanzamiento · Honduras 2026
            </div>

            <h1 className="fade-up d1" style={{
              fontFamily: "var(--font-display)",
              fontWeight: 700,
              fontSize: 68,
              lineHeight: 1.02,
              letterSpacing: "-0.025em",
              color: "var(--domo-navy)",
              margin: "22px 0 22px",
            }}>
              Servicios para tu hogar,<br/>
              <em style={{fontStyle: "normal", color: "var(--accent)"}}>en pocos toques.</em>
            </h1>

            <p className="fade-up d2" style={{
              margin: 0, maxWidth: 520,
              color: "var(--fg-2)", fontSize: 19, lineHeight: 1.55,
            }}>
              DOMO conecta tu hogar con técnicos verificados — plomería, limpieza, electricidad, mascotas y más.
              Sé de los primeros en probarlo en Honduras.
            </p>

            <div className="fade-up d3" style={{
              marginTop: 36, display: "flex", flexWrap: "wrap", gap: 14, alignItems: "center",
            }}>
              <a href="#registro" style={{textDecoration: "none"}}>
                <Button variant="primary" size="xl" iconRight="arrow-right">
                  Únete al piloto — Gratis
                </Button>
              </a>
              <a href="#como-funciona" style={{
                textDecoration: "none", color: "var(--domo-navy)",
                fontWeight: 600, fontSize: 15,
                display: "inline-flex", alignItems: "center", gap: 8,
                padding: "10px 4px",
              }}>
                <Icon name="play" size={16} stroke="var(--accent)"/>
                Ver cómo funciona
              </a>
            </div>

            {/* Mini trust row */}
            <div className="fade-up d4" style={{
              marginTop: 40,
              display: "flex", flexWrap: "wrap", gap: 22,
              color: "var(--fg-3)", fontSize: 13,
            }}>
              {[
                { icon: "shield-check", label: "Técnicos verificados" },
                { icon: "wallet",       label: "Pre-registro gratis" },
                { icon: "zap",          label: "Sin compromiso" },
              ].map(item => (
                <div key={item.label} style={{display: "inline-flex", alignItems: "center", gap: 8}}>
                  <Icon name={item.icon} size={16} stroke="var(--accent)"/>
                  <span style={{color: "var(--fg-2)", fontWeight: 500}}>{item.label}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Right: phone mockup */}
          <div style={{
            position: "relative",
            display: "flex", justifyContent: "center", alignItems: "center",
            minHeight: 720,
          }}>
            <HeroMockup/>
          </div>
        </div>
      </div>
    </section>
  );
}

function HeroMockup() {
  return (
    <div style={{position: "relative", width: 320, height: 660}}>
      {/* Backdrop gradient circle */}
      <div aria-hidden style={{
        position: "absolute",
        inset: "-60px -120px",
        background: "radial-gradient(ellipse at center, rgba(25,83,90,0.10) 0%, transparent 60%)",
        zIndex: 0,
      }}/>

      <div className="phone" style={{position: "relative", zIndex: 2}}>
        <div className="phone__notch"/>
        <div className="phone__screen">
          <AppHomePreview/>
        </div>
      </div>

      {/* Floating card: notification */}
      <div className="float-card float-anim-a" style={{
        top: 96, left: -84, width: 240, zIndex: 3,
      }}>
        <div style={{
          width: 38, height: 38, borderRadius: 12,
          background: "var(--domo-teal-50)",
          display: "flex", alignItems: "center", justifyContent: "center",
        }}>
          <Icon name="check" size={20} stroke="var(--accent)" strokeWidth={2.4}/>
        </div>
        <div style={{lineHeight: 1.3, minWidth: 0}}>
          <div style={{fontWeight: 600, fontSize: 13, color: "var(--domo-navy)"}}>
            Técnico en camino
          </div>
          <div style={{fontSize: 11, color: "var(--fg-3)", marginTop: 2}}>
            Carlos llega en 12 min
          </div>
        </div>
      </div>

      {/* Floating card: rating */}
      <div className="float-card float-anim-b" style={{
        top: 312, right: -100, width: 220, zIndex: 3,
      }}>
        <div style={{
          width: 38, height: 38, borderRadius: 999,
          background: "linear-gradient(135deg, #19535A, #2B7F84)",
          color: "#fff",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontFamily: "var(--font-display)", fontWeight: 700, fontSize: 13,
        }}>MC</div>
        <div style={{lineHeight: 1.3, minWidth: 0}}>
          <Stars value={5} size={11}/>
          <div style={{fontSize: 11, color: "var(--fg-3)", marginTop: 4}}>
            "Llegó puntual, todo impecable."
          </div>
        </div>
      </div>

      {/* Floating card: price */}
      <div className="float-card float-anim-c" style={{
        bottom: 60, left: -68, width: 196, zIndex: 3,
        flexDirection: "column", alignItems: "flex-start", gap: 6,
        padding: "14px 16px",
      }}>
        <div style={{
          fontSize: 11, fontWeight: 700, letterSpacing: "0.10em",
          textTransform: "uppercase", color: "var(--accent)",
        }}>Precio acordado</div>
        <div style={{
          fontFamily: "var(--font-display)", fontWeight: 700, fontSize: 24,
          color: "var(--domo-navy)", lineHeight: 1,
        }}>L. 450 <span style={{
          fontSize: 13, color: "var(--fg-3)", fontWeight: 500, marginLeft: 4,
        }}>fijo</span></div>
        <div style={{fontSize: 11, color: "var(--fg-3)"}}>Sin sorpresas al final.</div>
      </div>
    </div>
  );
}

/* ---------- The DOMO app "home" mockup shown on the phone screen ---------- */
function AppHomePreview() {
  const services = [
    { name: "Limpieza",   icon: "sparkles",  bg: "#F8F4E9" },
    { name: "Plomería",   icon: "wrench",    bg: "#EAF2F2" },
    { name: "Mascotas",   icon: "paw-print", bg: "#F4ECDC" },
    { name: "Técnico",    icon: "cpu",       bg: "#EAF2F2" },
    { name: "Jardín",     icon: "flower-2",  bg: "#F4ECDC" },
    { name: "Mudanza",    icon: "truck",     bg: "#F8F4E9" },
  ];
  return (
    <div style={{
      width: "100%", height: "100%",
      background: "var(--domo-sand-50)",
      display: "flex", flexDirection: "column",
      paddingTop: 52, /* below notch */
    }}>
      {/* Status bar dummy */}
      <div style={{
        display: "flex", justifyContent: "space-between",
        padding: "0 22px 8px", fontSize: 11, fontWeight: 700,
        color: "var(--domo-navy)",
      }}>
        <span>9:41</span>
        <span style={{display: "inline-flex", gap: 4, alignItems: "center"}}>
          <Icon name="signal" size={11} stroke="var(--domo-navy)" strokeWidth={2.2}/>
          <Icon name="wifi" size={11} stroke="var(--domo-navy)" strokeWidth={2.2}/>
          <Icon name="battery-full" size={13} stroke="var(--domo-navy)" strokeWidth={2.2}/>
        </span>
      </div>

      {/* Greeting */}
      <div style={{padding: "12px 20px 6px"}}>
        <div style={{fontSize: 11, color: "var(--fg-3)", fontWeight: 600}}>Hola, María</div>
        <div style={{
          fontFamily: "var(--font-display)", fontWeight: 700, fontSize: 20,
          color: "var(--domo-navy)", letterSpacing: "-0.01em", marginTop: 2,
        }}>¿Qué necesitas hoy?</div>
      </div>

      {/* Search */}
      <div style={{padding: "10px 20px 4px"}}>
        <div style={{
          background: "#fff",
          border: "1px solid var(--border-1)",
          borderRadius: 12, padding: "10px 14px",
          display: "flex", alignItems: "center", gap: 10,
          fontSize: 12, color: "var(--fg-3)",
          boxShadow: "var(--shadow-1)",
        }}>
          <Icon name="search" size={14} stroke="var(--fg-3)"/>
          Buscar un servicio…
        </div>
      </div>

      {/* Service grid */}
      <div style={{
        padding: "16px 20px 10px",
        display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 10,
      }}>
        {services.map(s => (
          <div key={s.name} style={{
            background: "#fff",
            border: "1px solid var(--border-1)",
            borderRadius: 14, padding: "12px 8px",
            display: "flex", flexDirection: "column", alignItems: "center", gap: 6,
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: 10,
              background: s.bg,
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>
              <Icon name={s.icon} size={18} stroke="var(--accent)"/>
            </div>
            <div style={{fontSize: 10.5, fontWeight: 600, color: "var(--domo-navy)"}}>
              {s.name}
            </div>
          </div>
        ))}
      </div>

      {/* Pro card highlight */}
      <div style={{padding: "12px 20px 0"}}>
        <div style={{
          fontSize: 11, fontWeight: 700, letterSpacing: "0.10em",
          textTransform: "uppercase", color: "var(--fg-3)", marginBottom: 8,
        }}>Recomendados</div>
        <div style={{
          background: "#fff",
          border: "1px solid var(--border-1)",
          borderRadius: 14, padding: 12,
          display: "flex", alignItems: "center", gap: 12,
          boxShadow: "var(--shadow-1)",
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 999,
            background: "linear-gradient(135deg, #19535A, #5EAEB1)",
            color: "#fff", display: "flex", alignItems: "center", justifyContent: "center",
            fontFamily: "var(--font-display)", fontWeight: 700, fontSize: 14,
          }}>CR</div>
          <div style={{flex: 1, minWidth: 0}}>
            <div style={{fontSize: 13, fontWeight: 600, color: "var(--domo-navy)"}}>
              Carlos Reyes
            </div>
            <div style={{fontSize: 10.5, color: "var(--fg-3)", marginTop: 2}}>
              Plomería · Tegucigalpa
            </div>
            <div style={{marginTop: 4, display: "inline-flex", alignItems: "center", gap: 4}}>
              <Stars value={5} size={10}/>
              <span style={{fontSize: 10, color: "var(--fg-3)"}}>· 142</span>
            </div>
          </div>
          <div style={{
            background: "var(--accent)", color: "#fff",
            padding: "6px 10px", borderRadius: 8,
            fontSize: 10.5, fontWeight: 600,
          }}>
            Agendar
          </div>
        </div>
      </div>

      {/* Bottom tab bar */}
      <div style={{
        marginTop: "auto",
        padding: "10px 16px 18px",
        display: "flex", justifyContent: "space-around",
        borderTop: "1px solid var(--border-1)",
        background: "rgba(255,255,255,0.92)",
        backdropFilter: "blur(8px)",
      }}>
        {[
          { name: "home",      active: true },
          { name: "calendar",  active: false },
          { name: "message-circle", active: false },
          { name: "user",      active: false },
        ].map(t => (
          <div key={t.name} style={{
            display: "flex", flexDirection: "column", alignItems: "center", gap: 3,
            color: t.active ? "var(--accent)" : "var(--fg-3)",
          }}>
            <Icon name={t.name} size={18} stroke="currentColor" strokeWidth={t.active ? 2.2 : 1.7}/>
            {t.active && <span style={{
              width: 4, height: 4, borderRadius: 999, background: "var(--accent)",
            }}/>}
          </div>
        ))}
      </div>
    </div>
  );
}

window.Hero = Hero;
