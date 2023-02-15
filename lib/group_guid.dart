import 'package:flutter/material.dart';

import 'config.dart';

class MyGroupGuid with ChangeNotifier {
  static String groupGuid = "";
  static String groupGuidFavorites = "";

  static String groupName = "";
  static String groupNameFavorites = "";

  MyGroupGuid() {
    if (box!.containsKey('currentGroupGuid')) {
      groupGuid = box!.get('currentGroupGuid');
    } else {
      box!.put('currentGroupGuid', groupGuid);
    }
    if (box!.containsKey('currentGroupGuidFavorites')) {
      groupGuidFavorites = box!.get('currentGroupGuidFavorites');
    } else {
      box!.put('currentGroupGuidFavorites', groupGuidFavorites);
    }

    if (box!.containsKey('currentGroupName')) {
      groupName = box!.get('currentGroupName');
    } else {
      box!.put('currentGroupName', groupName);
    }
    if (box!.containsKey('currentGroupNameFavorites')) {
      groupNameFavorites = box!.get('currentGroupNameFavorites');
    } else {
      box!.put('currentGroupNameFavorites', groupNameFavorites);
    }
  }

  String currentGroupGuid() => groupGuid;
  String currentGroupName() => groupName;

  List<String> currentGroupGuidFavorites() => groupGuidFavorites.split(";");
  List<String> currentGroupNameFavorites() => groupNameFavorites.split(";");

  void setGroup(String guid, String name) {
    groupGuid = guid;
    groupName = name;
    box!.put('currentGroupGuid', groupGuid);
    box!.put('currentGroupName', groupName);
    notifyListeners();
  }

  void setMainGroup(String guid, String name) {
    List<String> guids = groupGuidFavorites.split(";");
    List<String> names = groupNameFavorites.split(";");
    guids = [guid, ...guids];
    names = [name, ...names];
    guids.remove("");
    names.remove("");
    int indexOfDuplicate = -1;
    for (int i = 1; i < guids.length; i++) {
      if (guids[i] == guid) {
        indexOfDuplicate = i;
      }
    }
    if (indexOfDuplicate != -1) {
      guids.removeAt(indexOfDuplicate);
      names.removeAt(indexOfDuplicate);
    }
    groupGuidFavorites = guids.join(";");
    groupNameFavorites = names.join(";");
    box!.put('currentGroupGuidFavorites', groupGuidFavorites);
    box!.put('currentGroupNameFavorites', groupNameFavorites);
    notifyListeners();
  }

  void updateMainGroup(String guid, String name, String prevGuid) {
    List<String> guids = groupGuidFavorites.split(";");
    List<String> names = groupNameFavorites.split(";");
    guids.removeAt(0);
    names.removeAt(0);
    int index = guids.indexOf(prevGuid);
    if (index != -1) {
      guids.removeAt(index);
      names.removeAt(index);
    }
    guids = [guid, ...guids];
    names = [name, ...names];
    int indexOfDuplicate = -1;
    for (int i = 1; i < guids.length; i++) {
      if (guids[i] == guid) {
        indexOfDuplicate = i;
      }
    }
    if (indexOfDuplicate != -1) {
      guids.removeAt(indexOfDuplicate);
      names.removeAt(indexOfDuplicate);
    }
    groupGuidFavorites = guids.join(";");
    groupNameFavorites = names.join(";");
    box!.put('currentGroupGuidFavorites', groupGuidFavorites);
    box!.put('currentGroupNameFavorites', groupNameFavorites);
    notifyListeners();
  }

  void addGroupFavorite(String guid, String name) {
    List<String> guids = groupGuidFavorites.split(";");
    if ((guids[0] != guid) && currentGroupGuid() != guid) {
      groupGuidFavorites += ";$guid";
      groupNameFavorites += ";$name";
      box!.put('currentGroupGuidFavorites', groupGuidFavorites);
      box!.put('currentGroupNameFavorites', groupNameFavorites);
      notifyListeners();
    }
  }

  void removeGroupFavorite(String guid) {
    List<String> guids = groupGuidFavorites.split(";");
    List<String> names = groupNameFavorites.split(";");
    int index = guids.indexOf(guid);
    if ((index != 0 && currentGroupGuid() != guid)) {
      guids.removeAt(index);
      names.removeAt(index);
      groupGuidFavorites = guids.join(";");
      groupNameFavorites = names.join(";");
      box!.put('currentGroupGuidFavorites', groupGuidFavorites);
      box!.put('currentGroupNameFavorites', groupNameFavorites);
      notifyListeners();
    }
  }
}
