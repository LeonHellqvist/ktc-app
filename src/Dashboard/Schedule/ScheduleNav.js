import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    width: '100%',
    backgroundColor: theme.palette.background.paper,
  },
}));

export default function ScheduleNav( {setWeek, cwn} ) {
  const classes = useStyles();
  const [value, setValue] = React.useState(2);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <div className={classes.root}>
      <AppBar position="static" color="default">
        <Tabs
          value={value}
          onChange={handleChange}
          indicatorColor="primary"
          textColor="primary"
          variant="scrollable"
          scrollButtons="auto"
          aria-label="scrollable auto tabs example"
        >
          <Tab label={`${cwn - 2}`} onClick={() => setWeek(cwn - 2)} />
          <Tab label={`${cwn - 1}`} onClick={() => setWeek(cwn - 1)} />
          <Tab label={`${cwn}`} onClick={() => setWeek(cwn)} />
          <Tab label={`${cwn + 1}`} onClick={() => setWeek(cwn + 1)} />
          <Tab label={`${cwn + 2}`} onClick={() => setWeek(cwn + 2)} />
          <Tab label={`${cwn + 3}`} onClick={() => setWeek(cwn + 3)} />
          <Tab label={`${cwn + 4}`} onClick={() => setWeek(cwn + 4)} />
          <Tab label={`${cwn + 5}`} onClick={() => setWeek(cwn + 5)} />
          <Tab label={`${cwn + 6}`} onClick={() => setWeek(cwn + 6)} />
          <Tab label={`${cwn + 7}`} onClick={() => setWeek(cwn + 7)} />
        </Tabs>
      </AppBar>
    </div>
  );
}