import React, { useEffect, useState } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Card from "@material-ui/core/Card";
import CardActions from "@material-ui/core/CardActions";
import CardContent from "@material-ui/core/CardContent";
import Button from "@material-ui/core/Button";
import Typography from "@material-ui/core/Typography";
import Slide from "@material-ui/core/Slide";
import Grid from "@material-ui/core/Grid";
import Divider from '@material-ui/core/Divider';

const useStyles = makeStyles({
  root: {
    minWidth: 275,
    top: 180,
    position: "fixed",
  },
  right: {
    justifyContent: "flex-end",
  },
  title: {
    fontSize: 20,
  },
  pos: {
    marginBottom: 12,
  },
});

export default function SchedulePopup({ popupData, setPopupData }) {
  const classes = useStyles();

  function getTime() {
    if (!popupData) return;
    const days = ["Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag"];
    return `${days[popupData.dayOfWeekNumber - 1]} ${popupData.timeStart.slice(
      0,
      -3
    )} - ${popupData.timeEnd.slice(0, -3)}`;
  }

  return (
    <Grid
      container
      direction="column"
      justifyContent="center"
      alignItems="center"
    >
      <Slide direction="up" in={popupData ? true : false}>
        <Card className={classes.root} elevation={5}>
          <CardContent>
            <Typography
              className={classes.title}
              color="textSecondary"
              gutterBottom
            >
              {getTime()}
            </Typography>
            <Divider />
            {popupData ? (
              popupData.texts.map((text) => {
                return (
                  <Typography variant="body2" component="p" key={text}>
                    {text}
                  </Typography>
                );
              })
            ) : (
              <div>
                <Typography variant="body2" component="p" >
                  Loading...
                </Typography>
                <Typography variant="body2" component="p">
                  Loading...
                </Typography>
                <Typography variant="body2" component="p">
                  Loading...
                </Typography>
              </div>
            )}
            <Divider />
          </CardContent>
          <CardActions className={classes.right}>
            <Button
              variant="contained"
              color="primary"
              size="small"
              disableElevation
              onClick={() => {
                setPopupData(undefined);
              }}
            >
              Stäng
            </Button>
          </CardActions>
        </Card>
      </Slide>
    </Grid>
  );
}
