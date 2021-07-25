import React from 'react'
import NewsNextLesson from './NewsNextLesson'
import NewsTodayFood from './NewsTodayFood'
import { makeStyles } from "@material-ui/core/styles";
import image from '../../Shared/Images/logo192.png'
import Typography from '@material-ui/core/Typography';
import Divider from '@material-ui/core/Divider';
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
  header: {
    display: 'flex',
    alignItems: 'center',
  },
  h1: {
    paddingTop: 13,
    fontSize: '50px'
  },
  h2: {
    fontSize: '35px',
    padding: 10,
  },
  divider: {
    width: '85vw',
  },
  image: {
    marginTop: 14,
    maxWidth: "85vw",
    height: '65px',
    width: '65px',
    borderRadius: "20px",
    marginRight: 15,
  },
  paper: {
    padding: theme.spacing(2),
    width: "80vw",
    height: "10vh",
    textAlign: 'center',
    color: theme.palette.text.secondary,
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
        <div className={classes.header}>
          <img src={image} alt="" className={classes.image}/><Typography variant="h1" className={classes.h1}>KTC Appen</Typography>
        </div>
      </Grid>
      <Grid item xs={12} className={classes.grid}>
        <Divider className={classes.divider}/>
      </Grid>
      <Grid item xs={12} className={classes.grid}>
        <NewsNextLesson />
      </Grid>
      <Grid item xs={12} className={classes.grid}>
        <NewsTodayFood />
      </Grid>
    </Grid>
  )
}
