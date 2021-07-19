import React, { useState, useEffect } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Paper from '@material-ui/core/Paper';
import InputLabel from '@material-ui/core/InputLabel';
import MenuItem from '@material-ui/core/MenuItem';
import FormHelperText from '@material-ui/core/FormHelperText';
import FormControl from '@material-ui/core/FormControl';
import Select from '@material-ui/core/Select';

const axios = require("axios");

const useStyles = makeStyles((theme) => ({
  paper: {
    position: "absolute",
    top: "5vh",
    left: "5vw",
    right: "5vw",
    bottom: "5vh",
  },
  formControl: {
    margin: theme.spacing(1),
    minWidth: 120,
  },
  selectEmpty: {
    marginTop: theme.spacing(2),
  },
}));

export default function LoginForm( {setUserClass} ) {
  const classes = useStyles();

  const [buttonValue, setButtonValue] = useState("");
  const [classAvalible, setClassAvalible] = useState([]);


  useEffect(() => {
    var data = JSON.stringify({
      s: "ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj",
    });

    var config = {
      method: "post",
      url: "http://leonhellqvist.com:8080/classApi",
      headers: {
        "Content-Type": "application/json",
      },
      data: data,
    };

    axios(config)
      .then(function (response) {
        setClassAvalible(response.data);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  const classHandleChange = (event) => {
    setButtonValue(event.target.value);
  };


  return (
    <Paper className={classes.paper}>

      <FormControl variant="outlined" className={classes.formControl}>
        <InputLabel id="demo-simple-select-outlined-label">Klass</InputLabel>
        <Select
          id="standard-select-class"
          variant="outlined"
          defaultValue=""
          value={buttonValue}
          onChange={classHandleChange}
          label="Välj klass"
        >
          {classAvalible.map((option) => (
            <MenuItem key={option.groupGuid} value={option.groupName}>
              {option.groupName}
            </MenuItem>
          ))}
        </Select>
        <FormHelperText>Vänligen välj din klass</FormHelperText>
      </FormControl>
    </Paper>
  )
}
