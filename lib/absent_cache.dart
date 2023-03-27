import 'dart:convert';

import 'package:flutter/material.dart';

import 'config.dart';

class MyAbsentCache with ChangeNotifier {
  static String absentCache = "";

  MyAbsentCache() {
    if (box!.containsKey('absentCache')) {
      absentCache = box!.get('absentCache');
    } else {
      box!.put('absentCache', absentCache);
    }
  }

  AbsentList getAbsentCache() {
    if (absentCache == "") {
      return AbsentList(absents: []);
    } else {
      return AbsentList.fromJson(json.decode(absentCache));
    }
  }

  void setAbsentCache(newAbsentCache) {
    absentCache = json.encode(newAbsentCache);
    box!.put('absentCache', absentCache);
    notifyListeners();
  }

  void addAbsentCache(Absent absent) {
    AbsentList newAbsentCache = getAbsentCache();
    newAbsentCache.absents.add(absent);
    setAbsentCache(newAbsentCache);
  }

  void clearAbsentCache() {
    box!.put('absentCache', "");
    notifyListeners();
  }

  Absent findAbsentCache(String name) {
    for (Absent absent in getAbsentCache().absents) {
      if (absent.name.toLowerCase() == name.toLowerCase().split(" - ")[0]) {
        return absent;
      }
    }
    return Absent(email: "Loading", name: "Loading", photoUrl: "Loading");
  }
}

class AbsentList {
  List<Absent> absents;

  AbsentList({required this.absents});

  factory AbsentList.fromJson(List<dynamic> json) {
    List<Absent> absents = [];
    absents = json.map((i) => Absent.fromJson(i)).toList();
    return AbsentList(absents: absents);
  }

  List<dynamic> toJson() {
    return absents.map((i) => i.toJson()).toList();
  }
}

class Absent {
  String name;
  String email;
  String photoUrl;

  Absent({required this.name, required this.email, required this.photoUrl});

  factory Absent.fromJson(Map<String, dynamic> json) {
    return Absent(
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
