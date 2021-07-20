import React from "react";
import LoginForm from "./LoginForm";
import { makeStyles } from "@material-ui/core/styles";

const useStyles = makeStyles({
  backgroundDiv: {
    background: "linear-gradient(25deg, #FE6B8B 30%, #FF8E53 90%)",
    padding: 0,
    overflow: "hidden",
    position: "fixed",
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
  },
});

export default function Login({ setUserInfo }) {
  const classes = useStyles();
  return (
    <div className={classes.backgroundDiv}>
      <LoginForm setUserInfo={setUserInfo} />
    </div>
  );
}
