import React, { useState, useEffect } from "react";
import FoodListItem from './FoodListItem'
import { makeStyles } from '@material-ui/core/styles';
import Grid from '@material-ui/core/Grid';
import Skeleton from '@material-ui/lab/Skeleton';
const axios = require('axios');

const useStyles = makeStyles({
  root: {
    display: 'flex',
    flexWrap: "nowrap",
    marginTop: 10,
    marginBottom: 50,
  },
  item: {
    margin: 5,
  },
  skeleton: {
    width: "85vw",
    height: "20px",
  },
});

export default function FoodList( {offset} ) {
  const classes = useStyles();
  const [foodItems, setFoodItems] = useState([])
  //För placeholders när vi hämtar data från api
  const skeletonNumbers = [1,2,3,4,5];

  useEffect(() => {
    setFoodItems([])
    var data = JSON.stringify({
      s: "weeks",
      o: `offset=${offset}`,
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
        setFoodItems(response.data.rss.channel[0].item)
      })
      .catch(function (error) {
        console.log(error);
      });
  }, [offset])

  return (
    <Grid
      className={classes.root}
      container
      direction="column"
      justifyContent="flex-start"
      alignItems="center"
    >
      {foodItems.length > 0 ? 
        foodItems.map(item => {
          return (
            <Grid item key={item.title[0]} className={classes.item}>
              <FoodListItem item={item}/>
            </Grid>
          ) 
        }) :
        skeletonNumbers.map(item => {
          return (
            <Grid item key={item} className={classes.item}>
              <Skeleton className={classes.skeleton}/>
            </Grid>
          )
        })
      }
    </Grid>
      
  )
}
