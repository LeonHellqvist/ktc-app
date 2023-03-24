import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ktc_app/ad_component.dart';
import 'package:ktc_app/ad_helper.dart';
import 'package:week_of_year/week_of_year.dart';
import '../caller.dart';
import 'models.dart';

Future<Food> fetchFood(int week, Caller caller,
    {bool forceRefresh = false}) async {
  int year = DateTime.now().year;
  Response response;
  if (forceRefresh) {
    response = await caller.refreshForceCacheCall(
        'https://tools-proxy.leonhellqvist.workers.dev/?service=skolmaten&subService=menu&school=76517002&year=$year&week=$week');
  } else {
    response = await caller.requestCall(
        'https://tools-proxy.leonhellqvist.workers.dev/?service=skolmaten&subService=menu&school=76517002&year=$year&week=$week');
  }

  if (response.statusCode == 200 || response.statusCode == 304) {
    return Food.fromJson(response.data);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load schedule (status: ${response.statusCode})');
  }
}

class FoodPage extends StatefulWidget {
  const FoodPage({super.key, required this.caller, required this.showAds});

  final Caller caller;
  final bool showAds;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage>
    with TickerProviderStateMixin, RestorationMixin {
  TabController? _tabController;
  final RestorableInt tabIndex = RestorableInt(DateTime.now().weekOfYear - 1);

  @override
  String get restorationId => 'tab_scrollable_demo';

  void updateState(int value) {
    setState(() {
      tabIndex.value = value;
    });
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController!.index = tabIndex.value;
  }

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 53,
      vsync: this,
    );
    _tabController!.addListener(() {
      updateState(_tabController!.index);
      log("changed");
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = List.generate(53, (index) => "${index + 1}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vecka"),
        bottom: TabBar(
          indicatorColor: Theme.of(context).colorScheme.primary,
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (final tab in tabs)
              tab == DateTime.now().weekOfYear.toString()
                  ? Tab(
                      child: Text(
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          tab))
                  : Tab(text: tab)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final tab in tabs)
                  TabViewComponent(
                    tab: tab,
                    tabIndex: tabIndex.value,
                    caller: widget.caller,
                  )
              ],
            ),
          ),
          AdComponent(
              adUnit: AdHelper.foodBannerAdUnit, showAds: widget.showAds)
        ],
      ),
    );
  }
}

class DayComponent extends StatefulWidget {
  const DayComponent(
      {super.key, required this.meals, required this.day, required this.week});
  final List<Meals> meals;
  final int day;
  final String week;

  static const List<String> weekDays = [
    "Måndag",
    "Tisdag",
    "Onsdag",
    "Torsdag",
    "Fredag",
    "Lördag",
    "Söndag"
  ];

  @override
  State<DayComponent> createState() => _DayComponentState();
}

class _DayComponentState extends State<DayComponent>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                          textScaleFactor: 1.5,
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                widget.day == DateTime.now().weekday - 1 &&
                                        DateTime.now().weekOfYear.toString() ==
                                            widget.week
                                    ? TextSpan(
                                        text: DayComponent.weekDays[widget.day],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary))
                                    : TextSpan(
                                        text: DayComponent.weekDays[widget.day],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        )),
                              ])),
                    ),
                    /* RichText(
                        textScaleFactor: 1.2,
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              widget.day == DateTime.now().weekday - 1 &&
                                      DateTime.now().weekOfYear.toString() ==
                                          widget.week
                                  ? TextSpan(
                                      text: 'Idag',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  : const TextSpan(),
                            ])), */
                  ],
                ),
              ),
              Column(
                  children: widget.meals
                      .map((i) => Align(
                            alignment: Alignment.centerLeft,
                            child:
                                // TODO: decide if we want to use this
                                /* Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                      style: TextStyle(height: 1),
                                      textScaleFactor: 1.2,
                                      " "),
                                ),
                                Expanded(
                                  child: Text(
                                      textAlign: TextAlign.left,
                                      textScaleFactor: 1.15,
                                      "${i.value}."),
                                ),
                              ],
                            ), */
                                Text(
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 1.05,
                                    "${i.value}."),
                          ))
                      .toList()),
              const SizedBox(
                height: 8,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Divider(
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabViewComponent extends StatefulWidget {
  const TabViewComponent(
      {super.key,
      required this.tab,
      required this.tabIndex,
      required this.caller});
  final String tab;
  final int tabIndex;
  final Caller caller;

  @override
  State<TabViewComponent> createState() => _TabViewComponentState();
}

class _TabViewComponentState extends State<TabViewComponent> {
  late Future<Food>? futureFood;

  @override
  void initState() {
    updateFood();
    super.initState();
  }

  Future<void> updateFood({bool forceRefresh = false}) async {
    setState(() {
      futureFood = fetchFood(int.parse(widget.tab), widget.caller,
          forceRefresh: forceRefresh);
    });
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => updateFood(forceRefresh: true),
      child: Center(
        child: FutureBuilder<Food>(
            future: futureFood,
            builder: (BuildContext context, AsyncSnapshot<Food> snapshot) {
              if (snapshot.data != null) {
                int foundMeals = 0;
                for (int i = 0;
                    i < snapshot.data!.menu.weeks[0].days.length;
                    i++) {
                  for (var meal in snapshot.data!.menu.weeks[0].days[i].meals) {
                    if (meal.value == "") {
                      foundMeals++;
                    }
                  }
                }

                if (foundMeals == 0) {
                  return ListView.builder(
                      itemCount: snapshot.data!.menu.weeks[0].days
                          .length, // getting map length you can use keyList.length too
                      itemBuilder: (BuildContext context, int index) {
                        return DayComponent(
                          meals: snapshot.data!.menu.weeks[0].days[index].meals,
                          day:
                              index // key // getting your map values from current key
                          ,
                          week: widget.tab,
                        );
                      });
                } else {
                  return const Text(
                      textScaleFactor: 1.5, "Finns ingen matsedel");
                }
              } else {
                return const Text("");
              }
            }),
      ),
    );
  }
}
