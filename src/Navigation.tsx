import React from "react";
import BottomNavigation from "@mui/material/BottomNavigation";
import BottomNavigationAction from "@mui/material/BottomNavigationAction";
import FolderIcon from "@mui/icons-material/Folder";
import RestoreIcon from "@mui/icons-material/Restore";
import FavoriteIcon from "@mui/icons-material/Favorite";
import LocationOnIcon from "@mui/icons-material/LocationOn";
import Box from "@mui/material/Box";
import CssBaseline from "@mui/material/CssBaseline";
import ArchiveIcon from "@mui/icons-material/Archive";
import Paper from "@mui/material/Paper";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemAvatar from "@mui/material/ListItemAvatar";
import ListItemText from "@mui/material/ListItemText";
import Avatar from "@mui/material/Avatar";
import TodayIcon from "@mui/icons-material/Today";
import RestaurantIcon from "@mui/icons-material/Restaurant";
import SickIcon from "@mui/icons-material/Sick";
import ChatIcon from "@mui/icons-material/Chat";

interface props {
  parallaxRef: React.MutableRefObject<HTMLInputElement | undefined>;
}

export default function Navigation({ parallaxRef }: props) {
  const [value, setValue] = React.useState(0);

  return (
    <Paper
      sx={{ position: "fixed", bottom: 0, left: 0, right: 0 }}
      elevation={3}
    >
      <BottomNavigation
        value={value}
        onChange={(event, newValue) => {
          setValue(newValue);
          if (parallaxRef.current) {
            parallaxRef.current.scrollTo(newValue);
          }
        }}
      >
        <BottomNavigationAction label="Schema" value={0} icon={<TodayIcon />} />
        <BottomNavigationAction
          label="Matsedel"
          value={1}
          icon={<RestaurantIcon />}
        />
        <BottomNavigationAction
          label="Frånvarande"
          value={2}
          icon={<SickIcon />}
        />
        {/* <BottomNavigationAction
          label="Chatt"
          value="chatt"
          icon={<ChatIcon />}
        /> */}
      </BottomNavigation>
    </Paper>
  );
}
