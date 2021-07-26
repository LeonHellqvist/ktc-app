import React from 'react'
import Bar from './Bar'
import Nav from './Nav'
import Home from './Home/Home'
import Food from './Food/Food'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import { makeStyles } from "@material-ui/core/styles";

const useStyles = makeStyles((theme) => ({
  root: {
    overflow: 'hidden',
  }
}));

export default function Dashboard( {userInfo} ) {
  const classes = useStyles();
  if (userInfo === undefined) {
    return (<div></div>);
  }
  return (
    <Router className={classes.root}>
      <Bar />
      <Switch>
        <Route path="/ktc" exact component={Home}/>
        <Route path="/ktc/food" component={Food}/>
      </Switch>
      <Nav />
    </Router>
  )
}
