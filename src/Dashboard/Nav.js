import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import BottomNavigation from '@material-ui/core/BottomNavigation';
import BottomNavigationAction from '@material-ui/core/BottomNavigationAction';
import ScheduleIcon from '@material-ui/icons/Schedule';
import HomeIcon from '@material-ui/icons/Home';
import FastfoodIcon from '@material-ui/icons/Fastfood';
import Paper from '@material-ui/core/Paper';

const useStyles = makeStyles({
  root: {
    position: 'fixed',
    bottom: 0,
    width: "100%",
  },
});

export default function LabelBottomNavigation() {
  const classes = useStyles();
  const [value, setValue] = React.useState('home');

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <Paper elevation={3} className={classes.root}>
      <BottomNavigation value={value} onChange={handleChange}>
        <BottomNavigationAction label="Schema" value="schedule" icon={<ScheduleIcon />} />
        <BottomNavigationAction label="Hem" value="home" icon={<HomeIcon />} />
        <BottomNavigationAction label="Matsedel" value="food" icon={<FastfoodIcon />} />
      </BottomNavigation>
    </Paper>
  );
}