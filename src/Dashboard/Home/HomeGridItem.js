import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import Card from "@material-ui/core/Card";
import CardActionArea from "@material-ui/core/CardActionArea";
import CardContent from "@material-ui/core/CardContent";
import Typography from "@material-ui/core/Typography";

const useStyles = makeStyles({
  root: {
    margin: "10px",
    height: "135px",
  },
  h6: {
    fontSize: "18px",
  },
  actionArea: {
    height: "100%",
  },
});

export default function HomeGridItem({ item }) {
  const classes = useStyles();

  function getDescription() {
    if (item.lenght === 1) {
      let result;
      for (let i = 0; i < item[0].texts; i++) {
        result += item[0].texts[i];
        result += <br />
      }
      console.log(result);
      return result;
    }
  }

  if (item[0].food === true) {
    return <div>food</div>;
  }

  return (
    <Card className={classes.root} variant={"outlined"}>
      <CardActionArea className={classes.actionArea}>
        <CardContent>
          <Typography className={classes.h6} gutterBottom variant="h6" component="h2">
            {item.length === 1 ? item[0].texts[0] : "Lektionsblock"}
          </Typography>
          
            {item[0].texts.map((text, index) => {
              return <Typography variant="body2" color="textSecondary" component="p" key={index}>{text}</Typography>
            })}
          
        </CardContent>
      </CardActionArea>
    </Card>
  );
}
