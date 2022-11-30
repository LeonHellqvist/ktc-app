import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Card from '@material-ui/core/Card';
import CardActionArea from '@material-ui/core/CardActionArea';
import CardContent from '@material-ui/core/CardContent';
import Typography from '@material-ui/core/Typography';

const useStyles = makeStyles({
  root: {
    width: "95vw",
    marginBottom: 10,
  },
});

export default function FoodListItem( {item} ) {
  const classes = useStyles();

  return (
    <Card className={classes.root} variant="outlined">
      <CardActionArea>
        <CardContent>
          <Typography gutterBottom variant="h5" component="h2">
            {item.title[0].split(' -')[0]}
          </Typography>
          <Typography variant="body2" color="textSecondary" component="p">
            {item.description[0].replaceAll("<br/>", " ✪ ")}
          </Typography>
        </CardContent>
      </CardActionArea>
    </Card>
  );
}