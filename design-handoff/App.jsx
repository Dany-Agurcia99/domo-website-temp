// Compose the DOMO Landing v2 — Tally Latam aesthetic.

function AppV2() {
  React.useEffect(() => {
    if (window.lucide && typeof window.lucide.createIcons === "function") {
      window.lucide.createIcons();
    }
  }, []);
  return (
    <>
      <div className="v-line" aria-hidden/>
      <div className="page-shell">
        <NavV2/>
        <HeroV2/>
        <ServicesV2/>
        <HowItWorksV2/>
        <TrustV2/>
        <MainCTAV2/>
      </div>
      <FooterV2/>
    </>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<AppV2/>);
