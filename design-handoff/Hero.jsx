// Shared atomic components. Made global via window assignment at bottom.

const { useState, useEffect, useRef } = React;

function Icon({ name, size = 20, stroke = "currentColor", strokeWidth = 1.75, ...rest }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!ref.current) return;
    ref.current.innerHTML = renderLucide(name, { size, stroke, strokeWidth });
  }, [name, size, stroke, strokeWidth]);
  return <span ref={ref} style={{display: "inline-flex", lineHeight: 0}} {...rest} />;
}
function toPascal(s) {
  return s.replace(/(^|-)([a-z])/g, (_, __, c) => c.toUpperCase());
}
// Lucide UMD exposes each icon as an array of [tagName, attrs, children?] tuples.
// Convert that into inline SVG markup.
function renderLucide(name, { size, stroke, strokeWidth }) {
  const lucide = window.lucide;
  const pascal = toPascal(name);
  let node = null;
  if (lucide) {
    node = (lucide.icons && (lucide.icons[pascal] || lucide.icons[name])) || lucide[pascal] || lucide[name] || null;
  }
  if (!Array.isArray(node)) {
    return `<svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="${stroke}"><circle cx="12" cy="12" r="3"/></svg>`;
  }
  const renderNode = ([tag, attrs, children]) => {
    const a = Object.entries(attrs || {}).map(([k, v]) => `${k}="${String(v).replace(/"/g, '&quot;')}"`).join(" ");
    const inner = Array.isArray(children) ? children.map(renderNode).join("") : "";
    return inner ? `<${tag} ${a}>${inner}</${tag}>` : `<${tag} ${a}/>`;
  };
  const body = node.map(renderNode).join("");
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="${stroke}" stroke-width="${strokeWidth}" stroke-linecap="round" stroke-linejoin="round">${body}</svg>`;
}

function Button({ children, variant = "primary", size, full, icon, iconRight, onClick, type = "button", ...rest }) {
  const cls = ["btn", variant, size, full ? "full" : ""].filter(Boolean).join(" ");
  return (
    <button type={type} className={cls} onClick={onClick} {...rest}>
      {icon && <Icon name={icon} size={size === "lg" ? 20 : 16} />}
      {children}
      {iconRight && <Icon name={iconRight} size={size === "lg" ? 20 : 16} />}
    </button>
  );
}

function Field({ label, hint, type = "text", ...rest }) {
  return (
    <div className="field">
      {label && <label>{label}</label>}
      <input type={type} {...rest}/>
      {hint && <span className="hint">{hint}</span>}
    </div>
  );
}

function Select({ label, hint, options = [], ...rest }) {
  return (
    <div className="field">
      {label && <label>{label}</label>}
      <select {...rest}>
        {options.map(o => <option key={o.value || o} value={o.value || o}>{o.label || o}</option>)}
      </select>
      {hint && <span className="hint">{hint}</span>}
    </div>
  );
}

function Stars({ value = 5, size = 14 }) {
  return (
    <span className="stars" aria-label={`${value} de 5 estrellas`}>
      {Array.from({length: 5}).map((_, i) => (
        <svg key={i} width={size} height={size} viewBox="0 0 24 24"
             fill={i < value ? "#F2C744" : "rgba(17,22,39,0.15)"}>
          <path d="M12 2l3 6.9 7.5.7-5.7 5 1.7 7.4L12 18l-6.5 4 1.7-7.4L1.5 9.6 9 8.9z"/>
        </svg>
      ))}
    </span>
  );
}

function Badge({ children, tone = "teal", icon }) {
  const styles = {
    teal:    { background: "var(--domo-teal-50)",            color: "var(--accent)" },
    success: { background: "rgba(31,142,106,0.10)",          color: "var(--domo-success)" },
    warning: { background: "rgba(229,155,42,0.15)",          color: "#8c5b13" },
    danger:  { background: "rgba(215,70,58,0.10)",           color: "var(--domo-danger)" },
    dark:    { background: "var(--domo-navy)",               color: "#fff" },
    sand:    { background: "var(--domo-sand-200)",           color: "var(--domo-navy)" },
    onDark:  { background: "rgba(255,255,255,0.12)",         color: "#fff" },
  };
  return (
    <span style={{
      ...styles[tone],
      fontFamily: "var(--font-sans)", fontWeight: 600, fontSize: 12,
      padding: "5px 12px", borderRadius: 999,
      display: "inline-flex", alignItems: "center", gap: 6, lineHeight: 1.2,
    }}>
      {icon && <span style={{width: 6, height: 6, borderRadius: 999, background: "currentColor"}}/>}
      {children}
    </span>
  );
}

function PhotoPlaceholder({ tag = "Foto · placeholder", aspect, style, children }) {
  return (
    <div className="photo" style={{ aspectRatio: aspect, ...style }}>
      {children}
      <span className="tag">{tag}</span>
    </div>
  );
}

Object.assign(window, { Icon, Button, Field, Select, Stars, Badge, PhotoPlaceholder });
