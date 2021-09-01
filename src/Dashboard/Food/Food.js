import React, { useState } from "react";
import FoodList from './FoodList'
import FoodNav from './FoodNav'
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles({
  root: {
    height: "90vh",
    width: "100vw",
    overflowY: "scroll",
    overflowX: "hidden",
    backgroundColor: "rgb(250,250,250)",
  },
});

export default function Food() {
  const classes = useStyles();

  const [offset, setOffset] = useState(0);
  
  return (
    <div className={classes.root}>
      <FoodList offset={offset}/>
      <FoodNav offset={offset} setOffset={setOffset}/>
    </div>
  )
}
