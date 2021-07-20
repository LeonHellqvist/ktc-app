import React, { useState, useEffect } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Paper from "@material-ui/core/Paper";
import InputLabel from "@material-ui/core/InputLabel";
import MenuItem from "@material-ui/core/MenuItem";
import FormHelperText from "@material-ui/core/FormHelperText";
import FormControl from "@material-ui/core/FormControl";
import Select from "@material-ui/core/Select";
import Button from "@material-ui/core/Button";
import SaveIcon from "@material-ui/icons/Save";
import Grid from "@material-ui/core/Grid";
import TextField from "@material-ui/core/TextField";

const axios = require("axios");

const useStyles = makeStyles((theme) => ({
  paper: {
    position: "absolute",
    top: "5vh",
    left: "5vw",
    right: "5vw",
    bottom: "5vh",
  },
  gridItem: {
    margin: "10px",
  },
  formControl: {
    margin: theme.spacing(1),
    minWidth: 120,
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
          <hr />
        </Grid>
        <Grid item xs="auto">
          <FormControl variant="outlined" className={classes.formControl}>
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
            <FormHelperText>Vänligen välj din klass</FormHelperText>
          </FormControl>
        </Grid>
        <Grid item xs="auto" className={classes.gridItem}>
          <TextField
            id="firstnameInput"
            label="Förnamn"
            variant="outlined"
            onChange={fistNameHandleChange}
          />
        </Grid>
        <Grid item xs="auto" className={classes.gridItem}>
          <TextField
            id="lastnameInput"
            label="Efternamn"
            variant="outlined"
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
