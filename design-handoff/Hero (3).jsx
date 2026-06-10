// Services v2 — tall navy cards. Default shows the 3D icon; on hover a category
// demo video plays full-bleed. Drop video files at assets/categories/videos/<file>.mp4.

const SERVICES_V2 = [
{ id: "plomeria", title: "Plomería", img: "assets/categories/plumbing.png", video: "assets/categories/videos/plumbing.mp4" },
{ id: "limpieza", title: "Limpieza", img: "assets/categories/cleaning.png", video: "assets/categories/videos/cleaning.mp4" },
{ id: "cerrajeria", title: "Cerrajería", img: "assets/categories/locks.png", video: "assets/categories/videos/locks.mp4" },
{ id: "electro", title: "Electrodomésticos", img: "assets/categories/appliances.png", video: "assets/categories/videos/appliances.mp4" },
{ id: "electricidad", title: "Electricidad", img: "assets/categories/electrical.png", video: "assets/categories/videos/electricity.mp4" }];


function ServicesV2() {
  return (
    <section id="servicios" data-screen-label="Services" style={{ padding: "80px 0 100px" }}>
      <div className="container">
        <div className="section-head section-head--center" style={{ textAlign: "center" }}>
          <h2 className="tally-display tally-display--xl">
            Todo para tu hogar,<br />
            <span className="accent">en una sola app.</span>
          </h2>
        </div>

        <div className="cat-grid" style={{ height: "600px" }}>
          {SERVICES_V2.map((svc) => <ServiceTile key={svc.id} {...svc} />)}
        </div>
      </div>
    </section>);

}

function ServiceTile({ title, img, icon, video }) {
  const [hover, setHover] = React.useState(false);
  const vidRef = React.useRef(null);

  function onEnter() {
    setHover(true);
    const v = vidRef.current;
    if (v) {try {v.currentTime = 0;const p = v.play();if (p) p.catch(() => {});} catch (e) {}}
  }
  function onLeave() {
    setHover(false);
    const v = vidRef.current;
    if (v) {try {v.pause();v.currentTime = 0;} catch (e) {}}
  }

  return (
    <article
      onMouseEnter={onEnter}
      onMouseLeave={onLeave}
      style={{
        position: "relative",
        minHeight: 420,
        borderRadius: 24,
        background: "var(--domo-navy)",
        border: "1px solid rgba(255,255,255,0.08)",
        boxShadow: hover ? "0 30px 60px -26px rgba(17,22,39,0.5)" : "0 2px 6px rgba(17,22,39,0.10)",
        transform: hover ? "translateY(-6px)" : "translateY(0)",
        transition: "all var(--dur-base) var(--ease-standard)",
        display: "flex", flexDirection: "column",
        overflow: "hidden", cursor: "pointer"
      }}>

      {/* Hover video (full-bleed) */}
      <video
        ref={vidRef}
        src={video}
        muted
        loop
        playsInline
        preload="none"
        style={{
          position: "absolute", inset: 0, width: "100%", height: "100%",
          objectFit: "cover", zIndex: 1,
          opacity: hover ? 1 : 0,
          transition: "opacity var(--dur-slow) var(--ease-standard)"
        }} />
      

      {/* Brand glow (default state) */}
      <div aria-hidden style={{
        position: "absolute", inset: 0, pointerEvents: "none", zIndex: 1,
        background: "radial-gradient(circle at 60% 55%, rgba(115,195,175,0.30) 0%, rgba(188,212,118,0.10) 35%, transparent 65%)",
        opacity: hover ? 0 : 0.75,
        transition: "opacity var(--dur-base) var(--ease-standard)"
      }} />

      {/* Bottom scrim for text legibility (mostly for the video state) */}
      <div aria-hidden style={{
        position: "absolute", left: 0, right: 0, bottom: 0, height: "55%", zIndex: 2,
        background: "linear-gradient(180deg, transparent 0%, rgba(17,22,39,0.70) 100%)",
        pointerEvents: "none"
      }} />

      {/* Center focal icon (fades out on hover) */}
      <div style={{
        position: "absolute", inset: 0, zIndex: 2,
        display: "flex", alignItems: "center", justifyContent: "center",
        opacity: hover ? 0 : 1,
        transform: hover ? "scale(0.92)" : "scale(1)",
        transition: "opacity var(--dur-base) var(--ease-standard), transform var(--dur-base) var(--ease-standard)",
        pointerEvents: "none"
      }}>
        {img ?
        <img src={img} alt={title} draggable="false"
        style={{
          width: 132, height: 132, objectFit: "contain", display: "block",
          filter: "drop-shadow(0 18px 26px rgba(0,0,0,0.45))"
        }} /> :

        <div style={{
          width: 104, height: 104, borderRadius: 28,
          background: "linear-gradient(135deg, #BCD476, #73C3AF)",
          display: "flex", alignItems: "center", justifyContent: "center",
          boxShadow: "0 18px 30px -10px rgba(115,195,175,0.55)"
        }}>
            <Icon name={icon} size={52} stroke="#fff" strokeWidth={2.4} />
          </div>
        }
      </div>

      {/* Bottom-right: name */}
      <div style={{
        position: "relative", zIndex: 3,
        marginTop: "auto", padding: "26px 24px",
        textAlign: "right",
        fontFamily: "var(--font-display)", fontWeight: 700,
        fontSize: 19, letterSpacing: "-0.01em",
        color: "#fff"
      }}>{title}</div>
    </article>);

}

window.ServicesV2 = ServicesV2;