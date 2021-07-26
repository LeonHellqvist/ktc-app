import React, { useState, useEffect } from "react";
import FoodList from './FoodList'
import FoodNav from './FoodNav'

export default function Food() {

  const [offset, setOffset] = useState(0);
  
  return (
    <div>
      <FoodList offset={offset}/>
      <FoodNav setOffset={setOffset}/>
    </div>
  )
}
