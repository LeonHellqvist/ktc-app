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
  const parallaxRef = React.useRef<IParallax>(null!);

  return (
    <div className="App">
      <ResponsiveAppBar />
      <Content parallaxRef={parallaxRef} />
      <Navigation parallaxRef={parallaxRef} />
    </div>
  );
}

export default App;
