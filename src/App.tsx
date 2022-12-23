import React from "react";
import { IParallax } from "@react-spring/parallax";
import { useState } from "react";
import reactLogo from "./assets/react.svg";
/* import "./App.css"; */
import Navigation from "./Navigation";
import ResponsiveAppBar from "./ResponsiveAppBar";
import Content from "./Content";
import "@fontsource/roboto/300.css";
import "@fontsource/roboto/400.css";
import "@fontsource/roboto/500.css";
import "@fontsource/roboto/700.css";

function App() {
  const [firstTime, setFirstTime] = React.useState(false);
  const [page, setPage] = React.useState(0);

  React.useEffect(() => {
    const firstTime = localStorage.getItem("firstTime");
    if (!firstTime) {
      setFirstTime(true);
      localStorage.setItem("firstTime", "true");
    } else {
      setFirstTime(false);
    }
  }, []);

  return (
    <div className="App">
      {!firstTime ? (
        <>
          <ResponsiveAppBar />
          <Content page={page} />
          <Navigation page={page} setPage={setPage} />
        </>
      ) : (
        <div>bruh</div>
      )}
    </div>
  );
}

export default App;
