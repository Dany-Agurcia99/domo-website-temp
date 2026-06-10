// Problem -> Solution v2 — minimalist: white bg, centered headline,
// clean two-column comparison divided by a thin line. No color block, no heavy cards.

const PROBLEMS = [
  "Mandás 8 mensajes en grupos de WhatsApp.",
  "Nadie llega a la hora que prometió.",
  "El precio del final no es el que te dijeron.",
  "Si algo sale mal, nadie responde.",
];

const SOLUTIONS = [
  "Técnicos verificados en menos de un minuto.",
  "Agendás vos. Te confirman en tiempo real.",
  "Precio acordado antes de empezar.",
  "Pago seguro y garantía DOMO en cada trabajo.",
];

function ProblemSolutionV2() {
  return (
    <section id="que-es" data-screen-label="Que es DOMO" style={{ padding: "100px 0" }}>
      <div className="container--narrow">
        {/* Headline (was the eyebrow's section) */}
        <div style={{ textAlign: "center", maxWidth: 720, margin: "0 auto" }}>
          <h2 className="tally-display tally-display--xl">
            Encontrar quién te ayude<br />
            <span className="accent">no debería ser un dolor de cabeza.</span>
          </h2>
          <p style={{
            marginTop: 24, fontSize: 19, lineHeight: 1.55,
            color: "var(--fg-2)", fontWeight: 500,
          }}>
            DOMO conecta tu hogar con técnicos verificados — de plomería a limpieza profunda.
            Una app, una conversación, cero caos.
          </p>
        </div>
      </div>
    </section>
  );
}

window.ProblemSolutionV2 = ProblemSolutionV2;
