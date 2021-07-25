import React from 'react'
import { makeStyles } from "@material-ui/core/styles";

const useStyles = makeStyles((theme) => ({
  root: {
    position: 'relative',
    width: '100%',
    height: '100%'
  }
}));

export default function Home() {
  const classes = useStyles();
  return (
    <div className={classes.root}>
      Home
    </div>
  )
}
