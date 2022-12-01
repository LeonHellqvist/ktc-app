import React from "react";
import { Parallax, ParallaxLayer, IParallax } from "@react-spring/parallax";
import { config } from "@react-spring/web";

interface props {
  parallaxRef: React.MutableRefObject<IParallax>;
}

function Content({ parallaxRef }: props) {
  return (
    <Parallax
      ref={parallaxRef}
      pages={3}
      style={{ top: "20", left: "0" }}
      horizontal
      enabled={false}
      config={config.stiff}
    >
      <ParallaxLayer
        offset={0}
        speed={1}
        style={{
          overflow: "scroll",
        }}
      >
        <p>SIda 1</p>
      </ParallaxLayer>

      <ParallaxLayer
        offset={1}
        speed={1}
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <p>Sida 2</p>
      </ParallaxLayer>

      <ParallaxLayer
        offset={2}
        speed={1}
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <p>Sida 3</p>
      </ParallaxLayer>
    </Parallax>
  );
}

export default Content;
