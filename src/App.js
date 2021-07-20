import React, { useState, useEffect } from "react";
import "./App.css";
import Login from "./Login/Login";

const LOCAL_STORAGE_USER_INFO = "ktc-app.userInfo";

function App() {
  //State för användarens Klass och Namn
  const [userInfo, setUserInfo] = useState();

  //Kollar om det finns userInfo lagrat lokalt och sätter då userInfo state
  useEffect(() => {
    const storedUserInfo = JSON.parse(
      localStorage.getItem(LOCAL_STORAGE_USER_INFO)
    );
    if (storedUserInfo) setUserInfo(storedUserInfo);
  }, []);

  //Sätter userInfo innehållet lokalt när det updateras till exempel första gången man loggar in
  useEffect(() => {
    if (!userInfo) return;
    console.log(userInfo);
    localStorage.setItem(LOCAL_STORAGE_USER_INFO, JSON.stringify(userInfo));
  }, [userInfo]);

  return (
    <div className="App">
      <Login setUserInfo={setUserInfo} />
    </div>
  );
}

export default App;
