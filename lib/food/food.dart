import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:http/http.dart' as http;
import 'package:ktc_app/throttler.dart';

import 'models.dart';

Future<Food> fetchFood(int week) async {
  int year = DateTime.now().year;
  final response = await http.get(Uri.parse(
      'https://tools-proxy.leonhellqvist.workers.dev/?service=skolmaten&subService=menu&school=76517002&year=$year&week=$week'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Food.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load food');
  }
}

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage>
    with TickerProviderStateMixin, RestorationMixin {
  var throttler = Throttler();

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
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.

      updateState(_tabController!.index);
      print("changed");

      /* throttler.run(() {
        
      }); */
    });
    /* _tabController!.animation!.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      print(_tabController!.animation!.value);
      if (tabIndex.value != (_tabController!.animation!.value).round()) {
        updateState((_tabController!.animation!.value).round());
        print("animation");

        /* throttler.run(() {
          
        }); */
      }
      // TODO: fixa att man kan välja klass
    }); */
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    tabIndex.dispose();
    throttler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
      "24",
      "25",
      "26",
      "27",
      "28",
      "29",
      "30",
      "31",
      "32",
      "33",
      "34",
      "35",
      "36",
      "37",
      "38",
      "39",
      "40",
      "41",
      "42",
      "43",
      "44",
      "45",
      "46",
      "47",
      "48",
      "49",
      "50",
      "51",
      "52",
      "53"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vecka"),
        bottom: TabBar(
          indicatorColor: Colors.green,
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (final tab in tabs)
            TabViewComponent(
              tab: tab,
              tabIndex: tabIndex.value,
            )
        ],
      ),
    );
  }
}

class DayComponent extends StatefulWidget {
  const DayComponent({super.key, required this.meals, required this.day});
  final List<Meals> meals;
  final int day;

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
                child: Text(
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.5,
                    DayComponent.weekDays[widget.day]),
              ),
              Column(
                  children: widget.meals
                      .map((i) => Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.15,
                                i.value),
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
      {super.key, required this.tab, required this.tabIndex});
  final String tab;
  final int tabIndex;

  @override
  State<TabViewComponent> createState() => _TabViewComponentState();
}

class _TabViewComponentState extends State<TabViewComponent> {
  late Future<Food>? futureFood;

  @override
  void initState() {
    setState(() {
      futureFood = fetchFood(int.parse(widget.tab));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Food>(
          future: futureFood,
          builder: (BuildContext context, AsyncSnapshot<Food> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.menu.weeks[0].days
                      .length, // getting map length you can use keyList.length too
                  itemBuilder: (BuildContext context, int index) {
                    return DayComponent(
                        meals: snapshot.data!.menu.weeks[0].days[index].meals,
                        day:
                            index // key // getting your map values from current key
                        );
                  });
            } else {
              return const Text("");
            }
          }),
    );
  }
}
