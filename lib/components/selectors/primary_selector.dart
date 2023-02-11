import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktc_app/config.dart';
import 'groups_model.dart';
import 'teacher_groups_model.dart';

class PrimarySelector extends StatefulWidget {
  const PrimarySelector({super.key});

  @override
  State<PrimarySelector> createState() => _PrimarySelectorState();
}

class _PrimarySelectorState extends State<PrimarySelector> {
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
                              title: const Text("Primärt schema"),
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
                                          RadioListTile(
                                            activeColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            title: Text(item.groupName),
                                            value: "${item.groupGuid}:0",
                                            groupValue: currentGroupGuid
                                                .currentGroupGuid(),
                                            onChanged: (value) {
                                              currentGroupGuid.updateMainGroup(
                                                  value!,
                                                  item.groupName,
                                                  currentGroupGuid
                                                      .currentGroupGuid());
                                              currentGroupGuid.setGroup(
                                                  value, item.groupName);
                                              setState(() {});
                                            },
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
                                          RadioListTile(
                                            activeColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            title: Text(item.fullName),
                                            value: "${item.personGuid}:7",
                                            groupValue: currentGroupGuid
                                                .currentGroupGuid(),
                                            onChanged: (value) {
                                              currentGroupGuid.updateMainGroup(
                                                  value!,
                                                  item.id,
                                                  currentGroupGuid
                                                      .currentGroupGuid());
                                              currentGroupGuid.setGroup(
                                                  value, item.id);
                                              setState(() {});
                                            },
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
        child: Text(currentGroupGuid.currentGroupName() == ""
            ? "Primärt schema"
            : currentGroupGuid.currentGroupName()));
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
