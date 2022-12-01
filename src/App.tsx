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
  React.useEffect(() => {
    const firstTime = localStorage.getItem("firstTime");
    if (firstTime) {
      setFirstTime(true);
    } else {
      setFirstTime(false);
    }
  }, []);

  const parallaxRef = React.useRef<IParallax>(null!);

  return (
    <div className="App">
      {!firstTime ? (
        <>
          <ResponsiveAppBar />
          <Content parallaxRef={parallaxRef} />
          <Navigation parallaxRef={parallaxRef} />
        </>
      ) : (
        <div>bruh</div>
      )}
    </div>
  );
}

export default App;
