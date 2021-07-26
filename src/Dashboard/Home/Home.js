import React from 'react'
import NewsNextLesson from './NewsNextLesson'
import NewsTodayFood from './NewsTodayFood'
import { makeStyles } from "@material-ui/core/styles";
import Grid from '@material-ui/core/Grid';

const useStyles = makeStyles((theme) => ({
  root: {
    position: 'relative',
    display: 'flex',
    justifyContent: 'center',
    flexDirection: 'column',
    width: '100%',
    height: '100%'
  },
  grid: {
    padding: 10,
  },
}));

export default function Home() {
  const classes = useStyles();
  return (
    <Grid
      container
      direction="column"
      justifyContent="center"
      alignItems="center"
    >
      <Grid item xs={12} className={classes.grid}>
        <NewsNextLesson />
      </Grid>
      <Grid item xs={12} className={classes.grid}>
        <NewsTodayFood />
      </Grid>
    </Grid>
  )
}
