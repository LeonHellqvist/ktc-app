import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ktc_app/config.dart';

class MyOnboardingPage extends StatefulWidget {
  const MyOnboardingPage({super.key});

  @override
  State<MyOnboardingPage> createState() => _MyOnboardingPageState();
}

const snackBar = SnackBar(
  content: Text('Du måste välja både din klass och en alternativ klass!'),
  backgroundColor: Colors.red,
);

class _MyOnboardingPageState extends State<MyOnboardingPage> {
  void homeScreen() {
    Navigator.pushReplacementNamed(context, '/');
  }

  bool hasSelected() {
    if (currentGroupGuid.currentGroupName() == "") return false;
    if (currentGroupGuid.currentGroupNameAlt() == "") return false;
    return true;
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  late Future<Groups> futureGroups;

  @override
  void initState() {
    setState(() {
      futureGroups = fetchGroups();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
            child: Column(
              children: <Widget>[
                Image.asset("assets/images/ktcBuilding.png"),
                const Text(
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    "KTC Appen"),
                const Text(
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                    "Välkommen till KTC Appen! Här kan du se ditt schema, matsedeln och frånvarande lärare"),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                      "För att komma igång måste du bara ange din klass och en alternativ klass som du snabbt kan byta mellan"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
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
                                              for (var item in snapshot
                                                  .data!.data.classes)
                                                RadioListTile(
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  title: Text(item.groupName),
                                                  value: item.groupGuid,
                                                  groupValue: currentGroupGuid
                                                      .currentGroupGuid(),
                                                  onChanged: (value) {
                                                    currentGroupGuid.setGroup(
                                                        value!, item.groupName);
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
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                                currentGroupGuid.currentGroupName() == ""
                                    ? "Din klass"
                                    : currentGroupGuid.currentGroupName())),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
                                              for (var item in snapshot
                                                  .data!.data.classes)
                                                RadioListTile(
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  title: Text(item.groupName),
                                                  value: item.groupGuid,
                                                  groupValue: currentGroupGuid
                                                      .currentGroupGuidAlt(),
                                                  onChanged: (value) {
                                                    currentGroupGuid
                                                        .setGroupAlt(value!,
                                                            item.groupName);
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
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                                currentGroupGuid.currentGroupNameAlt() == ""
                                    ? "Alternativ klass"
                                    : currentGroupGuid.currentGroupNameAlt())),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: FilledButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: hasSelected() ? homeScreen : showError,
                    child: const Text("Börja använda appen!"),
                  ),
                ),
              )
            ],
          )
        ],
      ),
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
