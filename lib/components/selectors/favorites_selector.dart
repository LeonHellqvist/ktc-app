import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktc_app/config.dart';

import 'groups_model.dart';
import 'teacher_groups_model.dart';

class FavoritesSelector extends StatefulWidget {
  const FavoritesSelector({super.key});

  @override
  State<FavoritesSelector> createState() => _FavoritesSelectorState();
}

class _FavoritesSelectorState extends State<FavoritesSelector> {
  late Future<Groups> futureGroups;
  late Future<TeacherGroups> futureTeacherGroups;

  @override
  void initState() {
    setState(() {
      futureGroups = fetchGroups();
      futureTeacherGroups = fetchTeacherGroups();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        showDialog<bool>(
            context: context,
            builder: (BuildContext context) => DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Scaffold(
                        appBar: AppBar(
                            title: const Text("Favorit scheman"),
                            bottom: const TabBar(
                              tabs: <Widget>[
                                Tab(
                                  text: "Elevschema",
                                ),
                                Tab(
                                  text: "Lärarschema",
                                ),
                              ],
                            )),
                        body: TabBarView(children: <Widget>[
                          FutureBuilder<Groups>(
                              future: futureGroups,
                              builder: (BuildContext context,
                                  AsyncSnapshot<Groups> snapshot) {
                                if (snapshot.data != null) {
                                  return SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      for (var item
                                          in snapshot.data!.data.classes)
                                        ListTile(
                                          leading: Checkbox(
                                            value: currentGroupGuid
                                                .currentGroupGuidFavorites()
                                                .contains(
                                                    "${item.groupGuid}:0"),
                                            onChanged: (bool? selected) {
                                              if (selected!) {
                                                currentGroupGuid
                                                    .addGroupFavorite(
                                                        "${item.groupGuid}:0",
                                                        item.groupName);
                                              } else {
                                                currentGroupGuid
                                                    .removeGroupFavorite(
                                                        "${item.groupGuid}:0");
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          title: Text(item.groupName),
                                        )
                                    ],
                                  ));
                                } else {
                                  return const Text("");
                                }
                              }),
                          FutureBuilder<TeacherGroups>(
                              future: futureTeacherGroups,
                              builder: (BuildContext context,
                                  AsyncSnapshot<TeacherGroups> snapshot) {
                                if (snapshot.data != null) {
                                  return SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      for (var item
                                          in snapshot.data!.data.teachers)
                                        ListTile(
                                          leading: Checkbox(
                                            value: currentGroupGuid
                                                .currentGroupGuidFavorites()
                                                .contains(
                                                    "${item.personGuid}:7"),
                                            onChanged: (bool? selected) {
                                              if (selected!) {
                                                currentGroupGuid
                                                    .addGroupFavorite(
                                                        "${item.personGuid}:7",
                                                        item.id);
                                              } else {
                                                currentGroupGuid
                                                    .removeGroupFavorite(
                                                        "${item.personGuid}:7");
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          title: Text(item.fullName),
                                        )
                                    ],
                                  ));
                                } else {
                                  return const Text("");
                                }
                              }),
                        ]),
                      )),
                ));
      },
      child: const Text("Favorit scheman"),
    );
  }
}

Future<Groups> fetchGroups() async {
  final response = await http.get(Uri.parse(
      'https://tools-proxy.leonhellqvist.workers.dev/?service=skola24&subService=getClasses&unitGuid=ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj&hostName=katrineholm.skola24.se'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Groups.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load groups');
  }
}

Future<TeacherGroups> fetchTeacherGroups() async {
  final response = await http.get(Uri.parse(
      'https://tools-proxy.leonhellqvist.workers.dev/?service=skola24&subService=getTeachers&unitGuid=ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj&hostName=katrineholm.skola24.se'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return TeacherGroups.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load groups');
  }
}
