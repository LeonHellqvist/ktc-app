import React, { useState } from "react";
import Drawer from './Drawer';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import SwipeableDrawer from '@material-ui/core/SwipeableDrawer';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import image from '../Shared/Images/logo192.png'

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
  },
  menuButton: {
    marginRight: theme.spacing(2),
  },
  title: {
    flexGrow: 1,
  },
  header: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  h1: {
    fontSize: '30px'
  },
  image: {
    maxWidth: "85vw",
    height: '35px',
    width: '35px',
    borderRadius: "10px",
    marginLeft: 15,
  },
}));

export default function Bar() {
  const classes = useStyles();

  const [open, setOpen] = useState(false);

  return (
    <div className={classes.root}>
      <AppBar position="static">
        <Toolbar>
          <IconButton onClick={() => setOpen(true)} edge="start" className={classes.menuButton} color="inherit" aria-label="menu">
            <MenuIcon />
          </IconButton>
          <div className={classes.header}>
            <Typography variant="h1" className={classes.h1}>KTC Appen</Typography><img src={image} alt="" className={classes.image}/>
          </div>
        </Toolbar>
        <SwipeableDrawer
          anchor="top"
          open={open}
          onClose={() => setOpen(false)}
          onOpen={() => setOpen(true)}
        >
          <Drawer className={classes.drawer}/>
        </SwipeableDrawer>
      </AppBar>
    </div>
  );
}