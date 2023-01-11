import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as api;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ktc_app/loginStatus.dart';

import 'config.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class AbsentPage extends StatefulWidget {
  const AbsentPage({super.key, required MyLoginStatus currentLoginStatus});

  @override
  State<AbsentPage> createState() => _AbsentPageState();
}

class _AbsentPageState extends State<AbsentPage> with TickerProviderStateMixin {
  final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId:
              "114566651471-f1h56f08a47mbmvol2iok2v7jg8d453d.apps.googleusercontent.com",
          scopes: <String>[api.SheetsApi.spreadsheetsReadonlyScope],
        )
      : GoogleSignIn(
          scopes: <String>[api.SheetsApi.spreadsheetsReadonlyScope],
        );

  GoogleSignInAccount? _currentUser;

  TabController? _tabController;
  int tabIndex = (DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday) - 1;

  List<List<Object?>>? absent;

  String loginStatus = "in";

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(
      initialIndex:
          (DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday) - 1,
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
    loginStatus = currentLoginStatus.getLoginStatus();
    super.initState();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      if (currentLoginStatus.getLoginStatus() == "logout") {
        _googleSignIn.signOut();
        currentLoginStatus.setLoginStatus("out");
      }
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        if (loginStatus == "out") {
          currentLoginStatus.setLoginStatus("in");
        }
        var httpClient = (await _googleSignIn.authenticatedClient())!;
        var sheetsApi = api.SheetsApi(httpClient);
        api.ValueRange sheet = await sheetsApi.spreadsheets.values.get(
            "1g8BA1HngopNXsQaw-VieouP0uR1x3rAnPGYJSmloVH8", "Blad1",
            majorDimension: "COLUMNS");
        List<List<Object?>> values = sheet.values!;
        for (int i = 0; i < values.length; i++) {
          values[i].removeRange(0, 5);
          values[i].removeWhere((y) => y == "");
        }
        setState(() {
          absent = values;
        });
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;
    final tabs = ["Mån", "Tis", "Ons", "Tors", "Fre"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frånvarande"),
        bottom: TabBar(
          indicatorColor: Colors.green,
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (user != null) {
          if (absent != null) {
            return TabBarView(controller: _tabController, children: [
              for (final days in absent!)
                RefreshIndicator(
                    onRefresh: _pullRefresh, child: AbsentView(days: days))
            ]);
          } else {
            return Text("");
          }
        } else {
          if (loginStatus == "out") {
            print("out");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: const [
                        Text(
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                            'För att se frånvarande personal måste du\nlogga in med ditt skolkonto!'),
                        Text(
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            'Du måste även godkänna att appen kan se alla dina kalkylark men appen använder bara frånvarande personal dokumentet'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _handleSignIn,
                    child: const Text('LOGGA IN'),
                  ),
                ],
              ),
            );
          }
          return Text("");
        }
      }),
    );
  }

  Future<void> _pullRefresh() async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var sheetsApi = api.SheetsApi(httpClient);
    api.ValueRange sheet = await sheetsApi.spreadsheets.values.get(
        "1g8BA1HngopNXsQaw-VieouP0uR1x3rAnPGYJSmloVH8", "Blad1",
        majorDimension: "COLUMNS");
    List<List<Object?>> values = sheet.values!;
    for (int i = 0; i < values.length; i++) {
      values[i].removeRange(0, 5);
      values[i].removeWhere((y) => y == "");
    }
    setState(() {
      absent = values;
    });
  }
}

class AbsentView extends StatefulWidget {
  const AbsentView({super.key, required this.days});

  final days;
  @override
  State<AbsentView> createState() => _AbsentViewState();
}

class _AbsentViewState extends State<AbsentView>
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
      child: ListView.builder(
        itemCount: widget.days.length,
        prototypeItem: ListTile(
          title: Text(widget.days[0].toString()),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: index == 0
                ? Text(widget.days[index].toString().toCapitalized(),
                    textScaleFactor: 1.3)
                : Text(widget.days[index].toString()),
          );
        },
      ),
    );
  }
}



/* if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    } */