import React, { useEffect } from "react";

export default function ScheduleList( {week} ) {

  useEffect(() => {
    console.log(week)
  }, [week])

  return (
    <div>
      {week}
    </div>
  )
}
