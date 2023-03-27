import 'dart:developer';

class Schedule {
  Schedule({
    required this.boxList,
    required this.lessonInfo,
    required this.lineList,
    required this.textList,
  });
  late final List<BoxList> boxList;
  late final List<LessonInfo> lessonInfo;
  late final List<LineList> lineList;
  late final List<TextList> textList;

  Schedule.fromJson(Map<String, dynamic> json) {
    boxList =
        List.from(json['boxList']).map((e) => BoxList.fromJson(e)).toList();
    lessonInfo = json['lessonInfo'] != null
        ? List.from(json['lessonInfo'])
            .map((e) => LessonInfo.fromJson(e))
            .toList()
        : [];
    lineList =
        List.from(json['lineList']).map((e) => LineList.fromJson(e)).toList();
    textList =
        List.from(json['textList']).map((e) => TextList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['boxList'] = boxList.map((e) => e.toJson()).toList();
    data['lessonInfo'] = lessonInfo.map((e) => e.toJson()).toList();
    data['lineList'] = lineList.map((e) => e.toJson()).toList();
    data['textList'] = textList.map((e) => e.toJson()).toList();
    return data;
  }
}

class BoxList {
  BoxList({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.bColor,
    required this.fColor,
    required this.id,
    this.parentId,
    required this.type,
    required this.lessonGuids,
  });
  late final int x;
  late final int y;
  late final int width;
  late final int height;
  late final String bColor;
  late final String fColor;
  late final int id;
  late final int? parentId;
  late final String type;
  late final List<dynamic>? lessonGuids;

  BoxList.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    width = json['width'];
    height = json['height'];
    bColor = json['bColor'];
    fColor = json['fColor'];
    id = json['id'];
    parentId = null;
    type = json['type'];
    lessonGuids = json['lessonGuids'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    data['width'] = width;
    data['height'] = height;
    data['bColor'] = bColor;
    data['fColor'] = fColor;
    data['id'] = id;
    data['parentId'] = parentId;
    data['type'] = type;
    data['lessonGuids'] = lessonGuids;
    return data;
  }
}

class LessonInfo {
  LessonInfo({
    required this.guidId,
    required this.texts,
    required this.timeStart,
    required this.timeEnd,
    required this.dayOfWeekNumber,
    required this.blockName,
  });
  late final String guidId;
  late final List<String> texts;
  late final String timeStart;
  late final String timeEnd;
  late final int dayOfWeekNumber;
  late final String blockName;

  LessonInfo.fromJson(Map<String, dynamic> json) {
    guidId = json['guidId'];
    texts = json['texts'] == null
        ? []
        : List.castFrom<dynamic, String>(json['texts']);
    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
    dayOfWeekNumber = json['dayOfWeekNumber'];
    blockName = json['blockName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['guidId'] = guidId;
    data['texts'] = texts;
    data['timeStart'] = timeStart;
    data['timeEnd'] = timeEnd;
    data['dayOfWeekNumber'] = dayOfWeekNumber;
    data['blockName'] = blockName;
    return data;
  }
}

class LineList {
  LineList({
    required this.p1x,
    required this.p1y,
    required this.p2x,
    required this.p2y,
    required this.color,
    required this.id,
    required this.parentId,
    required this.type,
  });
  late final int p1x;
  late final int p1y;
  late final int p2x;
  late final int p2y;
  late final String color;
  late final int id;
  late final int parentId;
  late final String type;

  LineList.fromJson(Map<String, dynamic> json) {
    p1x = json['p1x'];
    p1y = json['p1y'];
    p2x = json['p2x'];
    p2y = json['p2y'];
    color = json['color'];
    id = json['id'];
    parentId = json['parentId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['p1x'] = p1x;
    data['p1y'] = p1y;
    data['p2x'] = p2x;
    data['p2y'] = p2y;
    data['color'] = color;
    data['id'] = id;
    data['parentId'] = parentId;
    data['type'] = type;
    return data;
  }
}

class TextList {
  TextList({
    required this.x,
    required this.y,
    required this.fColor,
    required this.fontsize,
    required this.text,
    required this.bold,
    required this.italic,
    required this.id,
    required this.parentId,
    required this.type,
  });
  late final int x;
  late final int y;
  late final String fColor;
  late final int fontsize;
  late final String text;
  late final bool bold;
  late final bool italic;
  late final int id;
  late final int? parentId;
  late final String type;

  TextList.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    fColor = json['fColor'];
    fontsize = json['fontsize'];
    text = json['text'];
    bold = json['bold'];
    italic = json['italic'];
    id = json['id'];
    parentId = json['parentId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    data['fColor'] = fColor;
    data['fontsize'] = fontsize;
    data['text'] = text;
    data['bold'] = bold;
    data['italic'] = italic;
    data['id'] = id;
    data['parentId'] = parentId;
    data['type'] = type;
    return data;
  }
}

class Lesson {
  late String guidId;
  late List<String> texts;
  late String timeStart;
  late String timeEnd;
  late String blockName;

  Lesson(LessonInfo lesson) {
    guidId = lesson.guidId;
    texts = lesson.texts;
    timeStart = lesson.timeStart;
    timeEnd = lesson.timeEnd;
    blockName = lesson.blockName;
  }
}

class Block {
  String blockName;
  String timeStart;
  String timeEnd;
  List<Lesson> lessons;

  Block(this.blockName, this.timeStart, this.timeEnd, this.lessons);

  void addLesson(LessonInfo lesson) {
    if (lessons.isNotEmpty) {
      if (hhmmssToM(lessons.last.timeStart) > hhmmssToM(lesson.timeStart)) {
        timeStart = lesson.timeStart;
      }
      if (hhmmssToM(lessons.last.timeEnd) < hhmmssToM(lesson.timeEnd)) {
        timeEnd = lesson.timeEnd;
      }
      lessons.add(Lesson(lesson));
    }
  }
}

class Group {
  String timeStart;
  String timeEnd;
  List<Block> blocks = [];
  List<Lesson> lessons = [];
  int count = 1;

  Group(this.timeStart, this.timeEnd, add) {
    if (add is Block) {
      blocks.add(add);
    } else {
      lessons.add(add);
    }
  }

  void add(add) {
    if (add is Block) {
      if (hhmmssToM(add.timeStart) < hhmmssToM(timeStart)) {
        timeStart = add.timeStart;
      }
      if (hhmmssToM(add.timeEnd) > hhmmssToM(timeEnd)) {
        timeEnd = add.timeEnd;
      }
      blocks.add(add);
    } else if (add is Lesson) {
      if (hhmmssToM(add.timeStart) < hhmmssToM(timeStart)) {
        timeStart = add.timeStart;
      }
      if (hhmmssToM(add.timeEnd) > hhmmssToM(timeEnd)) {
        timeEnd = add.timeEnd;
      }
      lessons.add(add);
    }
    count++;
  }
}

int hhmmssToM(String hhmmss) {
  String hh = hhmmss.substring(0, 2);
  String mm = hhmmss.substring(3, 5);
  int minutes = int.parse(hh) * 60 + int.parse(mm);
  return minutes;
}
