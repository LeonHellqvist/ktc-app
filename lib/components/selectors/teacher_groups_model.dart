class TeacherGroups {
  TeacherGroups({
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

  TeacherGroups.fromJson(Map<String, dynamic> json) {
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
  late final List<dynamic> classes;
  late final List<dynamic> rooms;
  late final List<Teachers> teachers;
  late final List<dynamic> students;

  Data.fromJson(Map<String, dynamic> json) {
    courses = List.castFrom<dynamic, dynamic>(json['courses']);
    subjects = List.castFrom<dynamic, dynamic>(json['subjects']);
    periods = List.castFrom<dynamic, dynamic>(json['periods']);
    groups = List.castFrom<dynamic, dynamic>(json['groups']);
    classes = List.castFrom<dynamic, dynamic>(json['classes']);
    rooms = List.castFrom<dynamic, dynamic>(json['rooms']);
    teachers =
        List.from(json['teachers']).map((e) => Teachers.fromJson(e)).toList();
    students = List.castFrom<dynamic, dynamic>(json['students']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['courses'] = courses;
    _data['subjects'] = subjects;
    _data['periods'] = periods;
    _data['groups'] = groups;
    _data['classes'] = classes;
    _data['rooms'] = rooms;
    _data['teachers'] = teachers.map((e) => e.toJson()).toList();
    _data['students'] = students;
    return _data;
  }
}

class Teachers {
  Teachers({
    this.name,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.isActiveUser,
    required this.integrity,
    required this.id,
    required this.reported,
    required this.personGuid,
    required this.readOnly,
    this.selectableBy,
  });
  late final Null name;
  late final String firstName;
  late final String lastName;
  late final String fullName;
  late final bool isActiveUser;
  late final bool integrity;
  late final String id;
  late final bool reported;
  late final String personGuid;
  late final bool readOnly;
  late final Null selectableBy;

  Teachers.fromJson(Map<String, dynamic> json) {
    name = null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    isActiveUser = json['isActiveUser'];
    integrity = json['integrity'];
    id = json['id'];
    reported = json['reported'];
    personGuid = json['personGuid'];
    readOnly = json['readOnly'];
    selectableBy = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['fullName'] = fullName;
    _data['isActiveUser'] = isActiveUser;
    _data['integrity'] = integrity;
    _data['id'] = id;
    _data['reported'] = reported;
    _data['personGuid'] = personGuid;
    _data['readOnly'] = readOnly;
    _data['selectableBy'] = selectableBy;
    return _data;
  }
}
