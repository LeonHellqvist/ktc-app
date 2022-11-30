import React, { useEffect, useState } from "react";
import HomeGridList from "./HomeGridList"
import { makeStyles } from "@material-ui/core/styles";
import Grid from "@material-ui/core/Grid";

const axios = require("axios");
var currentWeekNumber = require('current-week-number');
var cwn = currentWeekNumber();

const useStyles = makeStyles((theme) => ({
  root: {
    backgroundColor: "rgb(250,250,250)",
  },
}));

export default function Home() {
  const classes = useStyles();

  const [storedUserInfo, setStoredUserInfo] = useState()
  const [todaySchedule, setTodaySchedule] = useState()

  function getLocalDay(date) {

    let day = date.getDay();
  
    if (day === 0) { // veckodag 0 (söndag) är 7 i Europa
      day = 7;
    }

    if (day > 5) {
      day = 1;
    }
  
    return day;
  }

  useEffect(() => {
    const LOCAL_STORAGE_USER_INFO = "ktc-app.userInfo";
    setStoredUserInfo(JSON.parse(
      localStorage.getItem(LOCAL_STORAGE_USER_INFO)
    ))
  }, [])

  useEffect(() => {
    if (!storedUserInfo) return
    var data = JSON.stringify({
      s: "ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj",
      c: storedUserInfo.userClass,
      y: new Date().getFullYear(),
      w: cwn,
      d: getLocalDay(new Date()),
      wi: 1000,
      he: 1000,
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
        let sortedResponse = response.data.data.lessonInfo;
        for (var x = 0; x < sortedResponse.length; x++) {
          sortedResponse[x].timeStartI = parseInt(sortedResponse[x].timeStart.replaceAll(":", ""))
          sortedResponse[x].timeEndI = parseInt(sortedResponse[x].timeEnd.replaceAll(":", ""))
        }
        sortedResponse.sort(function (a, b) {return a.timeStartI - b.timeStartI});
        setTodaySchedule(sortedResponse);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, [storedUserInfo]);

  return (
    <div className={classes.root}>
      <Grid
        container
        direction="column"
        justifyContent="center"
        alignItems="center"
      >
        <Grid item xs={12}>
          <HomeGridList todaySchedule={todaySchedule}/>
        </Grid>
      </Grid>
    </div>
  );
}
