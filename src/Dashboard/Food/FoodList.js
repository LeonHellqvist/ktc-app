import React from 'react'
import FoodListItem from './FoodListItem'
const axios = require('axios');

export default function FoodList( {offset} ) {
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
    })
    .catch(function (error) {
      console.log(error);
    });

  return (
    <div>
      <FoodListItem />
    </div>
  )
}
