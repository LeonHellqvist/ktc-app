import React from "react";
import { Parallax, ParallaxLayer, IParallax } from "@react-spring/parallax";
import { config } from "@react-spring/web";
import Schedule from "./content/schedule/Schedule";
import Food from "./content/food/Food";
import Absent from "./content/absent/Absent";

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
        <Schedule />
      </ParallaxLayer>

      <ParallaxLayer
        offset={1}
        speed={1}
        style={{
          overflow: "scroll",
        }}
      >
        <Food />
      </ParallaxLayer>

      <ParallaxLayer
        offset={2}
        speed={1}
        style={{
          overflow: "scroll",
        }}
      >
        <Absent />
      </ParallaxLayer>
    </Parallax>
  );
}

export default Content;
