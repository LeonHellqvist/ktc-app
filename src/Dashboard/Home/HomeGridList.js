import React, { useEffect, useState } from "react";
import HomeGridItem from "./HomeGridItem";

export default function HomeGridList({ todaySchedule }) {
  const [scheduleGroups, setScheduleGroups] = useState();

  useEffect(() => {
    if (!todaySchedule) return;
    var groups = [];
    for (var x = 0; x < todaySchedule.length; x++) {
      if (groups.length !== 0) {
        for (var y = 0; y < groups.length; y++) {
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
    for (var a = 1; a < groups.length; a++) {
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
    console.log(groups);
  }, [todaySchedule]);

  return <div></div>;
}
