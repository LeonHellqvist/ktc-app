import React, { useEffect, useState } from "react";
import HomeGridItem from "./HomeGridItem"
import { makeStyles } from '@material-ui/core/styles';
import Grid from '@material-ui/core/Grid';

const useStyles = makeStyles((theme) => ({
  root: {
    width: '100vw',
  },
}));

export default function HomeGridGroup( {group} ) {

  const classes = useStyles();

  const [groupOffset, setGroupOffset] = useState() 

  useEffect(() => {
    if (group.length !== 2) {
      group[0].down = 0; group[0].up = 0;
    } else {
      group[0].up = 0
      group[0].down = 0
      group[1].up = 0
      group[1].down = 0

      if (group[1][0].timeStartI !== group[0][0].timeStartI) {
        group[1].down = 1;
      }

      if (group[0][0].timeEndI > group[1][0].timeEndI) {
        group[1].up = 1;
      }

      if (group[0][0].timeEndI < group[1][0].timeEndI) {
        group[0].up = 1;
      }
    }
    
    setGroupOffset(group);
  }, [group]);

  return (
    <Grid
      className={classes.root}
      container
      direction="row"
      justifyContent="center"
      alignItems="center"
    >
      {groupOffset ? groupOffset.map((item, index) => {
        return (
          <Grid item xs={12 / groupOffset.length} key={index}>
            <HomeGridItem item={item}/>
          </Grid>
        )
      }): ""}
    </Grid>
  )
}
