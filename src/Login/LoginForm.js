import React, { useState, useEffect } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Paper from "@material-ui/core/Paper";
import InputLabel from "@material-ui/core/InputLabel";
import MenuItem from "@material-ui/core/MenuItem";
import FormControl from "@material-ui/core/FormControl";
import Select from "@material-ui/core/Select";
import Button from "@material-ui/core/Button";
import SaveIcon from "@material-ui/icons/Save";
import Grid from "@material-ui/core/Grid";
import TextField from "@material-ui/core/TextField";
import Divider from '@material-ui/core/Divider';

const axios = require("axios");

const useStyles = makeStyles((theme) => ({
  paper: {
    position: "absolute",
    top: 25,
    left: 25,
    right: 25,
    paddingBottom: 25,
  },
  gridItem: {
    margin: "10px",
  },
  divider: {
    margin: 0,
    marginTop: 10,
    marginBottom: 10,
  },
  input: {
    minWidth: "60vw",
  },
  selectEmpty: {
    marginTop: theme.spacing(2),
  },
}));

export default function LoginForm({ setUserInfo }) {
  const classes = useStyles();

  const [classFinal, setClassFinal] = useState("");
  const [firstNameFinal, setFirstNameFinal] = useState("");
  const [lastNameFinal, setLastNameFinal] = useState("");
  const [errorMessage, setErrorMessage] = useState(null);
  const [classAvalible, setClassAvalible] = useState([]);

  // Checkar ifall all information är angiven och updateras sedan den informationen med App.js state. 
  // Detta innebär också att informationen sparas lokalt
  function saveInfo() {
    if (classFinal === "") {
      setErrorMessage("Du måste välja klass");
      return;
    }
    if (firstNameFinal === "") {
      setErrorMessage("Du måste skriva ditt förnamn");
      return;
    }
    if (lastNameFinal === "") {
      setErrorMessage("Du måste skriva ditt efternamn");
      return;
    }
    setErrorMessage(null);

    setUserInfo({
      userClass: classFinal,
      userFirstName: firstNameFinal,
      userLastName: lastNameFinal,
    });
  }

  //För att hämta alla klasser på KTC och lägga dom i (classAvalible)
  useEffect(() => {
    var data = JSON.stringify({
      s: "ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj",
    });

    //Vi gör en post request till leon pga CORS med Schema24
    var config = {
      method: "post",
      url: "https://leonhellqvist.com/api/ktc-app/classApi",
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

  //Tar hand om att byta värde när fält uppdateras
  const classHandleChange = (event) => {
    setClassFinal(event.target.value);
  };
  const fistNameHandleChange = (event) => {
    setFirstNameFinal(event.target.value);
  };
  const lastNameHandleChange = (event) => {
    setLastNameFinal(event.target.value);
  };

  return (
    <Paper className={classes.paper}>
      <Grid
        container
        direction="column"
        justifyContent="flex-start"
        alignItems="center"
      >
        <Grid item xs="auto">
          <h1>KTC appen</h1>
          <h2>Ange dina uppgifter</h2>
          <Divider variant="middle" className={classes.divider}/>
        </Grid>
        <Grid item xs="auto" className={classes.gridItem}>
          <FormControl variant="outlined" className={classes.input}>
            <InputLabel id="demo-simple-select-outlined-label">
              Klass
            </InputLabel>
            <Select
              id="classInput"
              variant="outlined"
              defaultValue=""
              value={classFinal}
              onChange={classHandleChange}
              label="Välj klass"
            >
              {classAvalible.map((option) => (
                <MenuItem key={option.groupGuid} value={option.groupName}>
                  {option.groupName}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </Grid>
        <Grid item xs="auto" className={classes.gridItem}>
          <TextField
            id="firstnameInput"
            label="Förnamn"
            variant="outlined"
            className={classes.input}
            onChange={fistNameHandleChange}
          />
        </Grid>
        <Grid item xs="auto" className={classes.gridItem}>
          <TextField
            id="lastnameInput"
            label="Efternamn"
            variant="outlined"
            className={classes.input}
            onChange={lastNameHandleChange}
          />
        </Grid>
        <Grid item xs="auto">
          <p>{errorMessage}</p>
        </Grid>
        <Grid item xs="auto" className={classes.gridItem}>
          <Button
            variant="contained"
            color="primary"
            size="large"
            className={classes.button}
            startIcon={<SaveIcon />}
            onClick={() => {
              saveInfo();
            }}
          >
            Spara
          </Button>
        </Grid>
      </Grid>
    </Paper>
  );
}
