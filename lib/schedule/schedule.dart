import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ktc_app/ad_component.dart';
import 'package:ktc_app/group_guid.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:dio/dio.dart';
import 'package:ktc_app/ad_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config.dart';

import 'models.dart';

Future<Schedule> fetchSchedule(String groupGuid, int scheduleDay, int week,
    int width, int height, Dio dio, bool dayView) async {
  int year = DateTime.now().year;

  String selectionType = groupGuid.split(":")[1];
  String requestGroupGuid = groupGuid.split(":")[0];

  if (!dayView) {
    scheduleDay = 0;
    height += 50;
  }

  String url =
      'https://tools-proxy.leonhellqvist.workers.dev/?service=skola24&subService=getLessons&hostName=katrineholm.skola24.se&unitGuid=ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj&groupGuid=$requestGroupGuid&year=$year&week=$week&scheduleDay=$scheduleDay&selectionType=$selectionType&lines=true&width=$width&height=$height';

  log(url);

  final response = await dio.getUri(Uri.parse(url));

  if (response.statusCode == 200 || response.statusCode == 304) {
    return Schedule.fromJson(jsonDecode(response.data));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load schedule (status: ${response.statusCode})');
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({
    super.key,
    required this.currentGroupGuid,
    required this.dio,
    required this.showAds,
  });
  final MyGroupGuid currentGroupGuid;
  final Dio dio;
  final bool showAds;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int tabIndex = (DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday) - 1;

  int height = 0;
  int width = 0;

  int selectedWeek = DateTime.now().weekOfYear;

  bool altSchedule = false;

  bool dayView = true;

  late AdSize adSize;

  bool _scrollingEnabled = true;
  final TransformationController _transformationController =
      TransformationController();
  @override
  void initState() {
    _tabController = TabController(
      initialIndex: tabIndex,
      length: 5,
      vsync: this,
    );
    _tabController!.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      setState(() {
        tabIndex = _tabController!.index;
      });
    });
    _tabController!.animation!.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      if (tabIndex != (_tabController!.animation!.value).round()) {
        setState(() {
          tabIndex = (_tabController!.animation!.value).round();
        });
      }
    });
    Future.delayed(Duration.zero, () {
      setState(() {
        tabIndex = _tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ["Mån", "Tis", "Ons", "Tors", "Fre"];

    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Text("Schema ${currentGroupGuid.currentGroupName()}"),
        actions: <Widget>[
          IconButton(
            icon: dayView
                ? const Icon(Icons.view_week_rounded)
                : const Icon(Icons.view_day_rounded),
            onPressed: () {
              setState(() {
                dayView = !dayView;
              });
            },
          ),
        ],
        bottom: dayView
            ? TabBar(
                controller: _tabController,
                isScrollable: false,
                tabs: [
                  for (final tab in tabs) Tab(text: tab),
                ],
              )
            : null,
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, (widget.showAds ? 60 : 0)),
        child: SizedBox(
          width: 170,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      title: const Text('Byt till en favorit'),
                      content: SizedBox(
                        height: 175.0,
                        width: 150.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: currentGroupGuid
                              .currentGroupGuidFavorites()
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                title: FilledButton.tonal(
                              child: Text(currentGroupGuid
                                  .currentGroupNameFavorites()[index]),
                              onPressed: () {
                                currentGroupGuid.setGroup(
                                    currentGroupGuid
                                        .currentGroupGuidFavorites()[index],
                                    currentGroupGuid
                                        .currentGroupNameFavorites()[index]);
                                setState(() {
                                  altSchedule = !altSchedule;
                                });
                                Navigator.pop(context);
                              },
                            ));
                          },
                        ),
                      )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 126,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedWeek -= 1;
                              });
                            },
                            icon: const Icon(Icons.arrow_left)),
                        Expanded(
                            child: Text(
                          "v.$selectedWeek",
                          textAlign: TextAlign.center,
                        )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedWeek += 1;
                              });
                            },
                            icon: const Icon(Icons.arrow_right))
                      ],
                    )),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                  child: SizedBox(width: 20, child: Icon(Icons.people)),
                )),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(builder: (context1) {
              double fullHeight = MediaQuery.of(context1).size.height;
              final appBar =
                  AppBar(); //Need to instantiate this here to get its size
              double appBarHeight = appBar.preferredSize.height +
                  MediaQuery.of(context).padding.top;
              /* height = fullHeight.toInt() - appBarHeight.toInt(); */
              height = fullHeight.toInt() -
                  appBarHeight.toInt() * 2 -
                  40 -
                  (widget.showAds ? 60 : 0);
              width = MediaQuery.of(context).size.width.toInt();
              log(fullHeight.toString());
              log(appBarHeight.toString());
              log(height.toString());
              return TabBarView(
                physics: (dayView
                    ? _scrollingEnabled
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics()),
                controller: _tabController,
                children: [
                  for (final tab in tabs)
                    InteractiveViewer(
                        transformationController: _transformationController,
                        onInteractionStart: (scale) {
                          setState(() => _scrollingEnabled = false);
                        },
                        onInteractionEnd: (details) {
                          if (_transformationController.value
                                  .getMaxScaleOnAxis() ==
                              1) {
                            setState(() => _scrollingEnabled = true);
                          }
                        },
                        child: TabViewComponent(
                          tab: tab,
                          tabIndex: tabIndex,
                          currentGroupGuid: currentGroupGuid,
                          height: height,
                          width: width,
                          altSchedule: altSchedule,
                          dio: widget.dio,
                          selectedWeek: selectedWeek,
                          dayView: dayView,
                        ))
                ],
              );
            }),
          ),
          AdComponent(
            adUnit: AdHelper.scheduleBannerAdUnit,
            showAds: widget.showAds,
          )
        ],
      ),
    );
  }
}

Color _getColorFromHex(String hexColor, bool text, context) {
  var color = TinyColor.fromString(hexColor);
  if (color.color == TinyColor.fromString("#808080").color) {
    return TinyColor.fromColor(Theme.of(context).colorScheme.background)
        .desaturate(6)
        .color;
  }
  if (currentTheme.currentTheme() == ThemeMode.light) {
    return color.color;
  }
  if (text) {
    return Colors.white;
  }
  if (color.color == Colors.white) {
    return Theme.of(context).colorScheme.background;
  }
  if (color.color == Colors.black) {
    return const Color.fromARGB(75, 255, 255, 255);
  }
  if (color.color == TinyColor.fromString("#cccccc").color) {
    return Colors.black38;
  }
  color.darken(15);
  color.desaturate(60);
  return color.color;
}

class DayComponent extends StatefulWidget {
  const DayComponent({super.key, required this.futureSchedule});

  final Schedule futureSchedule;

  @override
  State<DayComponent> createState() => _DayComponentState();
}

class _DayComponentState extends State<DayComponent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: CustomPaint(
          painter: ScheduleComponent(
              futureSchedule: widget.futureSchedule, context: context)),
    );
  }
}

class ScheduleComponent extends CustomPainter {
  const ScheduleComponent(
      {required this.futureSchedule, required this.context});

  final Schedule futureSchedule;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < futureSchedule.boxList.length; i++) {
      BoxList box = futureSchedule.boxList[i];
      var paint = Paint()
        ..color = _getColorFromHex(box.bColor, false, context)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
          Offset(box.x.toDouble(), box.y.toDouble() - 25) &
              Size(box.width.toDouble(), box.height.toDouble()),
          paint);

      var paintS = Paint()
        ..color = _getColorFromHex("#000000", false, context)
        ..style = PaintingStyle.stroke;

      if (i != 0) {
        canvas.drawRect(
            Offset(box.x.toDouble(), box.y.toDouble() - 25) &
                Size(box.width.toDouble(), box.height.toDouble()),
            paintS);
      }
    }
    for (int i = 0; i < futureSchedule.lineList.length; i++) {
      LineList line = futureSchedule.lineList[i];
      var paint = Paint()
        ..color = _getColorFromHex(line.color, false, context)
        ..strokeWidth = 1;

      canvas.drawLine(Offset(line.p1x.toDouble(), line.p1y.toDouble() - 25),
          Offset(line.p2x.toDouble(), line.p2y.toDouble() - 25), paint);
    }
    for (int i = 0; i < futureSchedule.textList.length; i++) {
      TextList text = futureSchedule.textList[i];
      FontWeight weight =
          text.bold == true ? FontWeight.bold : FontWeight.normal;
      FontStyle style =
          text.italic == true ? FontStyle.italic : FontStyle.normal;

      var textStyle = TextStyle(
        color: _getColorFromHex(text.fColor, true, context),
        fontSize: text.fontsize.toDouble(),
        fontWeight: weight,
        fontStyle: style,
        letterSpacing: 0.5,
      );

      var offset = Offset(text.x.toDouble(), text.y.toDouble() - 23);

      if (!kIsWeb) {
        textStyle = TextStyle(
          color: _getColorFromHex(text.fColor, true, context),
          fontSize: Platform.isIOS
              ? text.fontsize.toDouble()
              : text.fontsize.toDouble() - 1,
          fontWeight: weight,
          fontStyle: style,
          letterSpacing: Platform.isIOS ? 0 : 0.5,
        );
        offset = Offset(
            text.x.toDouble(), text.y.toDouble() - (Platform.isIOS ? 25 : 23));
      }

      final textSpan = TextSpan(
        text: text.text,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TabViewComponent extends StatefulWidget {
  const TabViewComponent({
    super.key,
    required this.tab,
    required this.tabIndex,
    required this.currentGroupGuid,
    required this.height,
    required this.width,
    required this.altSchedule,
    required this.dio,
    required this.selectedWeek,
    required this.dayView,
  });
  final String tab;
  final int tabIndex;
  final MyGroupGuid currentGroupGuid;
  final int height;
  final int width;
  final bool altSchedule;
  final Dio dio;
  final int selectedWeek;
  final bool dayView;

  @override
  State<TabViewComponent> createState() => _TabViewComponentState();
}

class _TabViewComponentState extends State<TabViewComponent> {
  Map<String, int> dayMap = {"Mån": 0, "Tis": 1, "Ons": 2, "Tors": 3, "Fre": 4};

  Future<Schedule>? futureSchedule;

  @override
  void initState() {
    if (currentGroupGuid.currentGroupGuid() != "") {
      setState(() {
        futureSchedule = fetchSchedule(
          currentGroupGuid.currentGroupGuid(),
          dayMap[widget.tab]! + 1,
          widget.selectedWeek,
          widget.width,
          widget.height,
          widget.dio,
          widget.dayView,
        );
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if ((oldWidget.altSchedule != widget.altSchedule) ||
        (oldWidget.selectedWeek != widget.selectedWeek ||
            (oldWidget.dayView != widget.dayView))) {
      setState(() {
        futureSchedule = fetchSchedule(
          currentGroupGuid.currentGroupGuid(),
          dayMap[widget.tab]! + 1,
          widget.selectedWeek,
          widget.width,
          widget.height,
          widget.dio,
          widget.dayView,
        );
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
        future: futureSchedule,
        builder: (BuildContext context, AsyncSnapshot<Schedule> snapshot) {
          if (snapshot.data != null) {
            return DayComponent(futureSchedule: snapshot.data!);
          } else {
            return const Text("");
          }
        });
  }
}
