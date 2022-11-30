import React, { useEffect, useState } from "react";
import Skeleton from "@material-ui/lab/Skeleton";
import Paper from '@material-ui/core/Paper';


const axios = require("axios");

export default function ScheduleWeek({ week, setPopupData }) {
  const [scheduleData, setScheduleData] = useState();

  const textXOffset = 1;
  const textYOffset = 9.5;

  const screenWidth = window.innerWidth;
  const screenHeight = 550;

  console.log(scheduleData);

  function getPopupData(id) {
    console.log(scheduleData.lessonInfo)
    for (var x = 0; x < scheduleData.lessonInfo.length; x++) {
      if (scheduleData.lessonInfo[x].guidId === id[0]) {
        console.log(scheduleData.lessonInfo[x])
        return scheduleData.lessonInfo[x];
      }
    }
  }

  function styleSelect(item) {
    if ((item.type.startsWith("Clock")) || (item.type.startsWith("Footer"))) {
      return { fill: item.bColor, stroke: "#000", strokeWidth: 0 }
    }
    else {
      return { fill: item.bColor, stroke: "#000", strokeWidth: 1 }
    }
  }

  useEffect(() => {
    setScheduleData(undefined);
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
        console.log(response);
        setScheduleData(response.data.data);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, [week, screenWidth]);

  return (
    <div>
      <Paper elevation={3} style={{overflowY: "scroll", paddingBottom: "400px" }}>
        {scheduleData !== undefined ? (
          <svg
            width={screenWidth}
            height={screenHeight}
            viewBox={`0 0 ${screenWidth} ${screenHeight}`}
            shapeRendering="crispEdges"
            
          >
            {scheduleData.boxList.map((item) => {
              return (
                <rect
                  x={item.x}
                  y={item.y}
                  width={item.width}
                  height={item.height}
                  key={item.id}
                  style={styleSelect(item)}
                  onClick={() => item.type.startsWith("Lesson") ? setPopupData(getPopupData(item.lessonGuids)) : {}}
                ></rect>
              );
            })}

            {scheduleData.textList.map((item) => {
              return (
                <text
                  x={item.x + textXOffset}
                  y={item.y + textYOffset}
                  key={item.id}
                  style={{ fontSize: item.fontsize, fill: item.fColor }}
                >
                  {item.text}
                </text>
              );
            })}

            {scheduleData.lineList.map((item) => {
              return (
                <line
                  x1={item.p1x}
                  y1={item.p1y}
                  x2={item.p2x}
                  y2={item.p2y}
                  key={item.id}
                  style={{ stroke: item.color }}
                ></line>
              );
            })}
          </svg>
        ) : (
          <Skeleton
            variant="rect"
            width={screenWidth}
            height={"100vh"}
            animation="wave"
          />
        )}
      </Paper>
    </div>
  );
}
