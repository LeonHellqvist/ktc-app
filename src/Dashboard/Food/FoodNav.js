import React from "react";
import { makeStyles } from '@material-ui/core/styles';
import Pagination from '@material-ui/lab/Pagination';

const useStyles = makeStyles((theme) => ({
  root: {
    '& > * + *': {
      marginTop: theme.spacing(2),
    },
 
    position: "fixed",
    bottom: 65,
    left: "50%",
    transform: "translate(-50%, 0)",
    backgroundColor: "white",
    borderRadius: 5,
    borderStyle: "solid",
    borderWidth: 1,
    borderColor: "rgba(0,0,0,0.2)",
  },
  pagination: {
    '& .MuiPagination-ul': {
      flexWrap: "nowrap",
    } 
  }
}));

export default function FoodNav( {offset, setOffset} ) {
  const classes = useStyles();
  const handleChange = (event, value) => {
    setOffset(value - 1);
  };

  return (
    <div className={classes.root}>
      <Pagination className={classes.pagination} count={9} page={offset + 1} onChange={handleChange} shape="rounded" hideNextButton={true} hidePrevButton={true} color="primary" />
    </div>
  );
}
