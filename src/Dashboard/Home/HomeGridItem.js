import React, { useEffect } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Card from "@material-ui/core/Card";
import CardActionArea from "@material-ui/core/CardActionArea";
import CardContent from "@material-ui/core/CardContent";
import Typography from "@material-ui/core/Typography";
import Paper from '@material-ui/core/Paper';

export default function HomeGridItem({ item }) {


  useEffect(() =>{
    console.log(item.down, item.up);
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
      position: "absolute",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      left: 2,
      top: 2,
      height: "20px",
      width: "40px",
    },
    timeLower: {
      position: "absolute",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      right: 2,
      bottom: 2,
      height: "20px",
      width: "40px",
    },
  });

  const classes = useStyles();

  if (item[0].food === true) {
    return <div>food</div>;
  }

  return (
    <Card className={classes.root} variant="outlined">
      <CardActionArea className={classes.actionArea}>
        <Paper className={classes.timeUpper} elevation={1}><Typography variant="body2" color="textSecondary" component="span"><b>{item[0].timeStart.slice(0, -3)}</b></Typography></Paper>
        <CardContent>
          <Typography className={classes.h6} gutterBottom variant="h6" component="h2">
            {item.length === 1 ? item[0].texts[0].substr(0,item[0].texts[0].indexOf(' ')) : "Lektionsblock"}
          </Typography>
            {item.map((text) => {
              return text.texts.map((text, index) => {
                if (index === 3) {
                  return <Typography variant="body2" color="textSecondary" component="span" key={index}>{text} <br /></Typography>
                }
                return <Typography variant="body2" color="textSecondary" component="span" key={index}>{text} </Typography>
              })
            })}
          
        </CardContent>
        <Paper className={classes.timeLower} elevation={1}><Typography variant="body2" color="textSecondary" component="span"><b>{item[0].timeEnd.slice(0, -3)}</b></Typography></Paper>
      </CardActionArea>
    </Card>
  );
}
