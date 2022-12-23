import React from "react";
import PullToRefresh from "react-simple-pull-to-refresh";
import BasicTabs from "../../components/BasicTabs";

function Food() {
  const [bruh, setBruh] = React.useState("hej");

  const handleRefresh = (): Promise<void> => {
    return new Promise((res) => {
      setTimeout(() => {
        res(setBruh("hejsan"));
      }, 1500);
    });
  };

  return (
    <PullToRefresh pullingContent={<></>} onRefresh={handleRefresh}>
      <>
        <BasicTabs>hej</BasicTabs>
        <div style={{ height: "200vh" }}>food</div>
      </>
    </PullToRefresh>
  );
}

export default Food;
