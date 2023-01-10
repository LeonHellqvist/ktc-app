import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../caller.dart';
import '../config.dart';

import 'models.dart';

Future<Schedule> fetchSchedule(
    String groupGuid, int scheduleDay, int week, int width, int height) async {
  int year = DateTime.now().year;

  String url =
      'https://tools-proxy.leonhellqvist.workers.dev/?service=skola24&subService=getLessons&hostName=katrineholm.skola24.se&unitGuid=ZGI0OGY4MjktMmYzNy1mMmU3LTk4NmItYzgyOWViODhmNzhj&groupGuid=$groupGuid&year=$year&week=$week&scheduleDay=$scheduleDay&lines=true&width=$width&height=$height';

  print(url);

  // TODO: Remove this
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
  const SchedulePage({super.key, required this.currentGroupGuid});
  final String currentGroupGuid;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

late CacheStore cacheStore;
late CacheOptions cacheOptions;
late Dio dio;
late Caller caller;

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  Future<Schedule>? futureSchedule;

  TabController? _tabController;
  int tabIndex = (DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday) - 1;

  int height = 0;

  bool _scrollingEnabled = true;
  TransformationController _transformationController =
      TransformationController();
  @override
  void initState() {
    cacheStore = MemCacheStore();
    cacheOptions = CacheOptions(
      policy: CachePolicy.forceCache,
      priority: CachePriority.high,
      maxStale: const Duration(days: 7),
      store: cacheStore,
      hitCacheOnErrorExcept: [],
      allowPostMethod: false, // for offline behaviour
    );

    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(options: cacheOptions),
      );
    caller = Caller(
      cacheStore: cacheStore,
      cacheOptions: cacheOptions,
      dio: dio,
    );
    _tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    _tabController!.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      setState(() {
        tabIndex = _tabController!.index;
        int week = DateTime.now().weekOfYear;
        futureSchedule = fetchSchedule(widget.currentGroupGuid, tabIndex + 1,
            week, MediaQuery.of(context).size.width.toInt(), height);
      });
      // TODO: fixa att man kan välja klass
    });
    Future.delayed(Duration.zero, () {
      setState(() {
        tabIndex = _tabController!.index;
        int week = DateTime.now().weekOfYear;
        futureSchedule = fetchSchedule(widget.currentGroupGuid, tabIndex + 1,
            week, MediaQuery.of(context).size.width.toInt(), height);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    dio.close();
    cacheStore.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ["Mån", "Tis", "Ons", "Tors", "Fre"];

    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: const Text("Schema"),
        bottom: TabBar(
          indicatorColor: Colors.green,
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: Builder(builder: (context1) {
        double fullHeight = MediaQuery.of(context1).size.height;
        final appBar = AppBar(); //Need to instantiate this here to get its size
        double appBarHeight =
            appBar.preferredSize.height + MediaQuery.of(context).padding.top;
        /* height = fullHeight.toInt() - appBarHeight.toInt(); */
        height = fullHeight.toInt() - appBarHeight.toInt() * 2 - 40;
        log(fullHeight.toString());
        log(appBarHeight.toString());
        log(height.toString());
        return TabBarView(
          physics: _scrollingEnabled
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            for (final tab in tabs)
              tab == tabs[tabIndex]
                  ? FutureBuilder<Schedule>(
                      future: futureSchedule,
                      builder: (BuildContext context,
                          AsyncSnapshot<Schedule> snapshot) {
                        if (snapshot.data != null) {
                          return InteractiveViewer(
                              transformationController:
                                  _transformationController,
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
                                  futureSchedule: futureSchedule));
                        } else {
                          return const Text("");
                        }
                      })
                  : const Text("")
          ],
        );
      }),
    );
  }
}

Color _getColorFromHex(String hexColor, bool text) {
  var color = TinyColor.fromString(hexColor);
  if (currentTheme.currentTheme() == ThemeMode.light) {
    return color.color;
  }
  if (text) {
    return Colors.white;
  }
  if (color.color == Colors.white) {
    return const Color.fromARGB(255, 48, 48, 48);
  }
  if (color.color == Colors.black) {
    return const Color.fromARGB(75, 255, 255, 255);
  }
  if (color.color == TinyColor.fromString("#cccccc").color) {
    return Colors.black12;
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
          painter: ScheduleComponent(futureSchedule: widget.futureSchedule)),
    );
  }
}

class ScheduleComponent extends CustomPainter {
  const ScheduleComponent({required this.futureSchedule});

  final Schedule futureSchedule;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < futureSchedule.boxList.length; i++) {
      BoxList box = futureSchedule.boxList[i];
      var paint = Paint()
        ..color = _getColorFromHex(box.bColor, false)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
          Offset(box.x.toDouble(), box.y.toDouble() - 25) &
              Size(box.width.toDouble(), box.height.toDouble()),
          paint);

      var paintS = Paint()
        ..color = _getColorFromHex("#000000", false)
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
        ..color = _getColorFromHex(line.color, false)
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
        color: _getColorFromHex(text.fColor, true),
        fontSize: text.fontsize.toDouble(),
        fontWeight: weight,
        fontStyle: style,
        letterSpacing: 0.5,
      );

      var offset = Offset(text.x.toDouble(), text.y.toDouble() - 23);

      if (!kIsWeb) {
        textStyle = TextStyle(
          color: _getColorFromHex(text.fColor, true),
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
  const TabViewComponent({super.key, required this.futureSchedule});
  final futureSchedule;

  @override
  State<TabViewComponent> createState() => _TabViewComponentState();
}

class _TabViewComponentState extends State<TabViewComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
        future: widget.futureSchedule,
        builder: (BuildContext context, AsyncSnapshot<Schedule> snapshot) {
          if (snapshot.data != null) {
            return DayComponent(futureSchedule: snapshot.data!);
          } else {
            return const Text("");
          }
        });
  }
}
