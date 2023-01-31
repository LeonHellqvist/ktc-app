import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktc_app/groupGuid.dart';
import 'package:ktc_app/loginStatus.dart';

import '../config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key,
      required MyGroupGuid currentGroupGuid,
      required MyLoginStatus currentLoginStatus});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inställningar"),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          ExpansionTile(
            title: const Text('Utseende'),
            subtitle: const Text("Anpassa utseendet"),
            children: <Widget>[
              ListTile(
                  title: FilledButton.tonal(
                onPressed: () {
                  currentTheme.switchTheme();
                },
                child: const Text('Ändra mörkt/ljust läge'),
              )),
              Platform.isAndroid
                  ? ListTile(
                      title: FilledButton.tonal(
                      onPressed: () {
                        currentTheme.switchThemeDynamic();
                      },
                      child: const Text('Ändra dynamiskt/standard tema'),
                    ))
                  : const SizedBox(height: 0),
            ],
          ),
          const ExpansionTile(
            title: Text('Schema'),
            subtitle: Text("Ändra klass"),
            children: <Widget>[
              ListTile(title: GroupSelector()),
            ],
          ),
          ExpansionTile(
            title: const Text('Medverkande'),
            subtitle: const Text("Se alla som hjälp till"),
            children: <Widget>[
              ListTile(
                title: Column(
                  children: [
                    const Text("Leon Hellqvist | TE21"),
                    TextButton(
                      child: const Text("Vill du hjälpa till? Besök projektet"),
                      onPressed: () => {_launchUrl()},
                    ),
                  ],
                ),
              ),
            ],
          ),
          currentLoginStatus.getLoginStatus() == "in"
              ? ExpansionTile(
                  title: const Text('Google konto'),
                  subtitle: const Text("Hantera ditt Google konto"),
                  children: <Widget>[
                    ListTile(
                        title: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: FilledButton.tonal(
                          child: const Text("Logga ut från ditt Google konto"),
                          onPressed: () =>
                              {currentLoginStatus.setLoginStatus("logout")},
                        ),
                      ),
                    )),
                  ],
                )
              : const Text(""),
        ]));
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(Uri.parse('https://github.com/LeonHellqvist/ktc-app'))) {
    throw 'Could not launch github';
  }
}

class GroupOptionsEntry {
  const GroupOptionsEntry(this.groupName, this.groupGuid);
  final String groupName;
  final String groupGuid;
}

class GroupSelector extends StatefulWidget {
  const GroupSelector({super.key});

  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

class _GroupSelectorState extends State<GroupSelector> {
  late Future<Groups> futureGroups;
  @override
  void initState() {
    Future<Groups> fetchedGroups = fetchGroups();
    setState(() {
      futureGroups = fetchGroups();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: FilledButton.tonal(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Välj din klass'),
                      content: FutureBuilder<Groups>(
                          future: futureGroups,
                          builder: (BuildContext context,
                              AsyncSnapshot<Groups> snapshot) {
                            if (snapshot.data != null) {
                              return SingleChildScrollView(
                                  child: Column(
                                children: [
                                  for (var item in snapshot.data!.data.classes)
                                    RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text(item.groupName),
                                      value: item.groupGuid,
                                      groupValue:
                                          currentGroupGuid.currentGroupGuid(),
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
                              return Text("");
                            }
                          }),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(currentGroupGuid.currentGroupName() == ""
                    ? "Din klass"
                    : currentGroupGuid.currentGroupName())),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: FilledButton.tonal(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Välj favoritklasser'),
                    content: FutureBuilder<Groups>(
                        future: futureGroups,
                        builder: (BuildContext context,
                            AsyncSnapshot<Groups> snapshot) {
                          if (snapshot.data != null) {
                            return SingleChildScrollView(
                                child: Column(
                              children: [
                                for (var item in snapshot.data!.data.classes)
                                  ListTile(
                                    leading: Checkbox(
                                      value: currentGroupGuid
                                          .currentGroupGuidFavorites()
                                          .contains(item.groupGuid),
                                      onChanged: (bool? selected) {
                                        if (selected!) {
                                          currentGroupGuid.addGroupFavorite(
                                              item.groupGuid, item.groupName);
                                        } else {
                                          currentGroupGuid.removeGroupFavorite(
                                              item.groupGuid);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                    title: Text(item.groupName),
                                  )
                              ],
                            ));
                          } else {
                            return Text("");
                          }
                        }),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Favoritklasser"),
            ),
          ),
        )
      ],
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

class Groups {
  Groups({
    this.error,
    required this.data,
    this.exception,
    required this.validation,
    this.sessionExpires,
    required this.needSessionRefresh,
  });
  late final Null error;
  late final Data data;
  late final Null exception;
  late final List<dynamic> validation;
  late final Null sessionExpires;
  late final bool needSessionRefresh;

  Groups.fromJson(Map<String, dynamic> json) {
    error = null;
    data = Data.fromJson(json['data']);
    exception = null;
    validation = List.castFrom<dynamic, dynamic>(json['validation']);
    sessionExpires = null;
    needSessionRefresh = json['needSessionRefresh'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['data'] = data.toJson();
    _data['exception'] = exception;
    _data['validation'] = validation;
    _data['sessionExpires'] = sessionExpires;
    _data['needSessionRefresh'] = needSessionRefresh;
    return _data;
  }
}

class Data {
  Data({
    required this.courses,
    required this.subjects,
    required this.periods,
    required this.groups,
    required this.classes,
    required this.rooms,
    required this.teachers,
    required this.students,
  });
  late final List<dynamic> courses;
  late final List<dynamic> subjects;
  late final List<dynamic> periods;
  late final List<dynamic> groups;
  late final List<Classes> classes;
  late final List<dynamic> rooms;
  late final List<dynamic> teachers;
  late final List<dynamic> students;

  Data.fromJson(Map<String, dynamic> json) {
    courses = List.castFrom<dynamic, dynamic>(json['courses']);
    subjects = List.castFrom<dynamic, dynamic>(json['subjects']);
    periods = List.castFrom<dynamic, dynamic>(json['periods']);
    groups = List.castFrom<dynamic, dynamic>(json['groups']);
    classes =
        List.from(json['classes']).map((e) => Classes.fromJson(e)).toList();
    rooms = List.castFrom<dynamic, dynamic>(json['rooms']);
    teachers = List.castFrom<dynamic, dynamic>(json['teachers']);
    students = List.castFrom<dynamic, dynamic>(json['students']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['courses'] = courses;
    _data['subjects'] = subjects;
    _data['periods'] = periods;
    _data['groups'] = groups;
    _data['classes'] = classes.map((e) => e.toJson()).toList();
    _data['rooms'] = rooms;
    _data['teachers'] = teachers;
    _data['students'] = students;
    return _data;
  }
}

class Classes {
  Classes({
    this.id,
    required this.groupGuid,
    required this.groupName,
    required this.absenceMessageNotDeliveredCount,
    required this.isResponsible,
    required this.isClass,
    required this.isAdmin,
    required this.isPrincipal,
    required this.isMentor,
    required this.isPreschoolGroup,
    this.teachers,
    this.selectableBy,
    this.substituteTeacherGuid,
    required this.teacherChangeStudentsInGroup,
  });
  late final Null id;
  late final String groupGuid;
  late final String groupName;
  late final int absenceMessageNotDeliveredCount;
  late final bool isResponsible;
  late final bool isClass;
  late final bool isAdmin;
  late final bool isPrincipal;
  late final bool isMentor;
  late final bool isPreschoolGroup;
  late final Null teachers;
  late final Null selectableBy;
  late final Null substituteTeacherGuid;
  late final int teacherChangeStudentsInGroup;

  Classes.fromJson(Map<String, dynamic> json) {
    id = null;
    groupGuid = json['groupGuid'];
    groupName = json['groupName'];
    absenceMessageNotDeliveredCount = json['absenceMessageNotDeliveredCount'];
    isResponsible = json['isResponsible'];
    isClass = json['isClass'];
    isAdmin = json['isAdmin'];
    isPrincipal = json['isPrincipal'];
    isMentor = json['isMentor'];
    isPreschoolGroup = json['isPreschoolGroup'];
    teachers = null;
    selectableBy = null;
    substituteTeacherGuid = null;
    teacherChangeStudentsInGroup = json['teacherChangeStudentsInGroup'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['groupGuid'] = groupGuid;
    _data['groupName'] = groupName;
    _data['absenceMessageNotDeliveredCount'] = absenceMessageNotDeliveredCount;
    _data['isResponsible'] = isResponsible;
    _data['isClass'] = isClass;
    _data['isAdmin'] = isAdmin;
    _data['isPrincipal'] = isPrincipal;
    _data['isMentor'] = isMentor;
    _data['isPreschoolGroup'] = isPreschoolGroup;
    _data['teachers'] = teachers;
    _data['selectableBy'] = selectableBy;
    _data['substituteTeacherGuid'] = substituteTeacherGuid;
    _data['teacherChangeStudentsInGroup'] = teacherChangeStudentsInGroup;
    return _data;
  }
}
