import React, { useState } from "react";
import ScheduleNav from './ScheduleNav'
import ScheduleList from './ScheduleList'

var currentWeekNumber = require('current-week-number');
var cwn = currentWeekNumber();

export default function Schedule() {

  const [week, setWeek] = useState(cwn);

  return (
    <div>
      <ScheduleNav setWeek={setWeek} cwn={cwn} />
      <ScheduleList week={week}/>
    </div>
  )
}
