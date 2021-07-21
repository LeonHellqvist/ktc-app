import React from 'react'
import { makeStyles } from "@material-ui/core/styles";
import Wave from 'react-wavify'

const useStyles = makeStyles(() => ({
  icon: {
    "@media (min-height: 600px)": {
      position: 'absolute',
      width: '100%',
      bottom: -80,
      left: 0,
    }
  },
  wrapper: {
    "@media (max-height: 599px)": {
      display: "none",
    }
  }
}));

export default function LoginBottomSVG() {
  const classes = useStyles();
  return (
    <div className={classes.wrapper}>
      <Wave fill='#FFFFFF'
          className={classes.icon}
          paused={false}
          options={{
            height: 10,
            amplitude: 30,
            speed: 0.15,
            points: 3
          }}
      />
    </div>
  )
}
