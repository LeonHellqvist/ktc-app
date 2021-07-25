import React, { useState, useEffect } from "react";
import "./App.css";
import Login from "./Login/Login";
import Dashboard from "./Dashboard/Dashboard";

const LOCAL_STORAGE_USER_INFO = "ktc-app.userInfo";

function App() {
  //State för användarens Klass och Namn
  const [userInfo, setUserInfo] = useState();

  //Kollar om det finns userInfo lagrat lokalt och sätter då userInfo state
  useEffect(() => {
    const storedUserInfo = JSON.parse(
      localStorage.getItem(LOCAL_STORAGE_USER_INFO)
    );
    if (storedUserInfo) {
      setUserInfo(storedUserInfo);
    }
    else {
      setUserInfo(null)
    }
  }, []);

  //Sätter userInfo innehållet lokalt när det updateras till exempel första gången man loggar in
  useEffect(() => {
    if ((userInfo !== null) && (userInfo !== undefined)) {
      localStorage.setItem(
        LOCAL_STORAGE_USER_INFO,
        JSON.stringify(userInfo)
      );
    }
  }, [userInfo]);

  if (userInfo === null) {
    return (
      <div className="App">
        <Login setUserInfo={setUserInfo} />
      </div>
    );
  } else {
    return (
      <div className="App">
        <Dashboard userInfo={userInfo} />
      </div>
    )
  }
}

export default App;
