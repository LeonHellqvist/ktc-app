import React, { useEffect, useState } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Card from "@material-ui/core/Card";
import CardActionArea from "@material-ui/core/CardActionArea";
import CardContent from "@material-ui/core/CardContent";
import Typography from "@material-ui/core/Typography";
import Paper from '@material-ui/core/Paper';
const axios = require('axios');

export default function HomeGridItem({ item }) {

  const [foodToday, setFoodToday] = useState()

  useEffect(() =>{
    if ((item[0].food !== true) && (!item[0].texts[0].startsWith("Lunch"))) return
    var data = JSON.stringify({
      s: "days",
      o: "offset=0",
    });
  
    var config = {
      method: "post",
      url: "https://leonhellqvist.com/api/ktc-app/foodApi",
      headers: {
        "Content-Type": "application/json",
      },
      data: data,
    };
  
    axios(config)
      .then(function (response) {
        console.log(response)
        console.log(response.data.rss.channel[0].item[0])
        setFoodToday(response.data.rss.channel[0].item[0])
      })
      .catch(function (error) {
        console.log(error);
      });
  }, [item])
  // Att fixa!!!! Ibland blir det undefined och lektionerna får ingen offset

  const useStyles = makeStyles({
    root: {
      margin: "10px",
      height: "150px",
      marginTop: 10 + 20 * item.down,
      marginBottom: 10 + 20 * item.up,
    },
    h6: {
      fontSize: "18px",
    },
    actionArea: {
      height: "100%",
    },
    timeUpper: {
      left: 2,
      top: 2,
    },
    timeLower: {
      right: 2,
      bottom: 2,
    },
    time: {
      backgroundColor: "rgb(235,235,235)",
      position: "absolute",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      height: "20px",
      width: "40px",
    },
  });

  const classes = useStyles();

  if ((item[0].food === true) || (item[0].texts[0].startsWith("Lunch"))) {
    return (
      <Card className={classes.root} variant="outlined">
        <CardActionArea className={classes.actionArea}>
          <CardContent>
            <Typography className={classes.h6} gutterBottom variant="h6" component="h2">
              Lunch
            </Typography>
              {foodToday ? foodToday.description[0].split("<br/>").map((text, index) => {
                return <Typography variant="body2" color="textSecondary" component="span" key={index}>{text} <br /></Typography>
              }): ""}
            
          </CardContent>
        </CardActionArea>
      </Card>
    );
  }

  return (
    <Card className={classes.root} variant="outlined">
      <CardActionArea className={classes.actionArea}>
        <Paper className={classes.time} style={{top: 2, left: 2}} elevation={0}><Typography variant="body2" color="textSecondary" component="span"><b>{item[0].timeStart.slice(0, -3)}</b></Typography></Paper>
        <CardContent>
          <Typography className={classes.h6} gutterBottom variant="h6" component="h2">
            {item.length === 1 ? item[0].texts[0].substr(0,item[0].texts[0].indexOf(' ')) : "Lektionsblock"}
          </Typography>
            {item.map((text) => {
              return text.texts.map((text, index) => {
                if (index === 2) {
                  return <Typography variant="body2" color="textSecondary" component="span" key={index}>{text}<br /></Typography>
                }
                return <Typography variant="body2" color="textSecondary" component="span" key={index}>{text} </Typography>
              })
            })}
          
        </CardContent>
        <Paper className={classes.time} style={{bottom: 2, right: 2}} elevation={0}><Typography variant="body2" color="textSecondary" component="span"><b>{item[0].timeEnd.slice(0, -3)}</b></Typography></Paper>
      </CardActionArea>
    </Card>
  );
}
