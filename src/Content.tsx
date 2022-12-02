import React from "react";
import { Parallax, ParallaxLayer, IParallax } from "@react-spring/parallax";
import { config } from "@react-spring/web";
import Schedule from "./content/schedule/Schedule";
import Food from "./content/food/Food";
import Absent from "./content/absent/Absent";

interface props {
  page: number;
}

function Content({ page }: props) {
  const parallaxRef = React.useRef<IParallax>(null!);

  React.useEffect(() => {
    if (parallaxRef.current) {
      parallaxRef.current.scrollTo(page);
    }
  }, [page]);

  return (
    <Parallax
      ref={parallaxRef}
      pages={3}
      style={{
        top: "0",
        left: "0",
        height: "calc(100vh - 200px)",
        position: "relative",
      }}
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
