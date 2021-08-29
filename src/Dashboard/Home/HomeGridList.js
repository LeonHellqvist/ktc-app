import React, { useEffect, useState } from "react";
import HomeGridGroup from "./HomeGridGroup";
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  root: {
    width: '100%',
    overflowY: "scroll",
    overflowX: "hidden",
    height: "83vh"
  },
}));

export default function HomeGridList({ todaySchedule }) {
  const classes = useStyles();

  const [scheduleGroups, setScheduleGroups] = useState();

  useEffect(() => {
    if (!todaySchedule) return;
    var groups = [];
    // Kollar ifall flera lektioner börjar och slutar samtidigt och grupperar dem.
    for (let x = 0; x < todaySchedule.length; x++) {
      if (groups.length !== 0) {
        for (let y = 0; y < groups.length; y++) {
          var found = false;
          if (
            groups[y][0][0].timeStart === todaySchedule[x].timeStart &&
            groups[y][0][0].timeEnd === todaySchedule[x].timeEnd
          ) {
            found = true;
            groups[y][0].push(todaySchedule[x]);
          }
        }
        if (!found) {
          groups.push([[todaySchedule[x]]]);
        }
      } else {
        groups.push([[todaySchedule[0]]]);
      }
    }
    // Kollar ifall olika lektioner som inte startar samtidigt kolliderar
    // Och lägger till dem i den lektion som de koliderar med
    for (let a = 1; a < groups.length; a++) {
      if (
        (groups[a][0][0].timeStartI < groups[a - 1][0][0].timeEndI &&
          groups[a][0][0].timeStartI > groups[a - 1][0][0].timeStartI) ||
        (groups[a][0][0].timeEndI < groups[a - 1][0][0].timeEndI &&
          groups[a][0][0].timeEndI > groups[a - 1][0][0].timeStartI)
      ) {
        groups[a - 1].push(groups[a][0])
        groups.splice(a, 1)
        a--;
      }
    }
    // Kollar ifall det finns en lucka där man kan ha lunch
    if (groups[0][0][0].timeStartI >= 112500) {
      console.log("Starts after lunch")
    } else {
      for (let a = 1; a < groups.length; a++) {
        if (groups[a][0][0].timeStartI - groups[a - 1][0][0].timeEndI >= 8000) {
          groups.splice(a - 1, 0, [[{food: true, guidId: "bruh"}]])
          a++;
        }
      }
    }
    setScheduleGroups(groups)
    console.log(groups);
  }, [todaySchedule]);

  return (
    <div className={classes.root}>
      {scheduleGroups ? scheduleGroups.map((group) => {
        return <HomeGridGroup group={group} key={group[0][0].guidId}/>
      }) : ""}
    </div>
  );
}
