import React, { useState } from "react";
import ScheduleNav from './ScheduleNav'
import ScheduleWeek from './ScheduleWeek/ScheduleWeek'
import SchedulePopup from "./SchedulePopup";

var currentWeekNumber = require('current-week-number');
var cwn = currentWeekNumber();

export default function Schedule() {

  const [week, setWeek] = useState(cwn);
  const [popupData, setPopupData] = useState(undefined);

  return (
    <div>
      <ScheduleNav setWeek={setWeek} cwn={cwn} />
      <ScheduleWeek week={week} setPopupData={setPopupData} />
      <SchedulePopup popupData={popupData} setPopupData={setPopupData} />
    </div>
  )
}
