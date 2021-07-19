import React, { useState, useEffect } from "react";
import './App.css';
import Login from'./Login/Login';

function App() {

  const [userClass, setUserClass] = useState("")

  useEffect(() => {
    console.log(userClass)
  }, [userClass])

  return (
    <div className="App">
      <Login setUserClass={setUserClass}/>
    </div>
  );
}

export default App;
