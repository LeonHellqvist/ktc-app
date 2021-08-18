import React, { useEffect, useState } from "react";
const axios = require('axios');

export default function ScheduleWeek( {week} ) {

  const [scheduleData, setScheduleData] = useState()

  const screenWidth = window.innerWidth - 20;
  const screenHeight = 550;

  console.log(scheduleData);
  useEffect(() => {
    const LOCAL_STORAGE_USER_INFO = "ktc-app.userInfo";
    const storedUserInfo = JSON.parse(
      localStorage.getItem(LOCAL_STORAGE_USER_INFO)
    );
    console.log(storedUserInfo);
    var data = JSON.stringify({
      s: "ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj",
      c: storedUserInfo.userClass,
      y: new Date().getFullYear(),
      w: week,
      d: 0,
      wi: screenWidth,
      he: screenHeight,
    });
  
    var config = {
      method: "post",
      url: "https://leonhellqvist.com/api/ktc-app/schemaApi",
      headers: {
        "Content-Type": "application/json",
      },
      data: data,
    };
  
    axios(config)
      .then(function (response) {
        console.log(response)
        setScheduleData(response.data.data)
      })
      .catch(function (error) {
        console.log(error);
      });
  }, [week, screenWidth])

  return (
    <div style={{marginTop: "20px"}}>
      {scheduleData !== undefined ? 
        <svg width={screenWidth} height={screenHeight} viewBox={`0 0 ${screenWidth} ${screenHeight}`} shapeRendering="crispEdges" style={{borderStyle: "solid", borderWidth: 1}}>
          {scheduleData.boxList.map(item => {
            return <rect x={item.x} y={item.y} width={item.width} height={item.height} style={item.type.startsWith("Clock") ? {fill: item.bColor, stroke: "#000", strokeWidth: 0} : {fill: item.bColor, stroke: "#000", strokeWidth: 1}} ></rect>
          })}
          
          {scheduleData.textList.map(item => {
            return <text x={item.x + 1} y={item.y + 9.5} style={{fontSize: item.fontsize, fill: item.fColor}}>{item.text}</text>
          })}

          {scheduleData.lineList.map(item => {
            return <line x1={item.p1x} y1={item.p1y} x2={item.p2x} y2={item.p2y} style={{stroke: item.color}}></line>
          })}
        </svg> :
      <p>Btuh</p>
      }
      
      {week}
    </div>
  )
}
