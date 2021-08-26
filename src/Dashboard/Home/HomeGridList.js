import React, { useEffect, useState } from "react";
import HomeGridItem from "./HomeGridItem";

export default function HomeGridList({ todaySchedule }) {
  const [scheduleGroups, setScheduleGroups] = useState();

  useEffect(() => {
    if (!todaySchedule) return;
    var groups = [];
    console.log(todaySchedule[0])
    for (var x = 0; x < todaySchedule.length; x++) {
      for (var y = 0; y < groups.length; x++) {
        if (
          groups[y][0].blockName === todaySchedule[x].blockName &&
          groups[y][0].timeStart === todaySchedule[x].timeStart &&
          groups[y][0].timeEnd === todaySchedule[x]
        ) {
          groups[y].push([todaySchedule]);
        } else {
          groups.push(todaySchedule);
        }
      }
    }
    console.log(groups)
  }, [todaySchedule]);

  return <div></div>;
}
