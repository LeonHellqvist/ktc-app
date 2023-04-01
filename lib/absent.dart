import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as sheets_api;
import 'package:googleapis/drive/v3.dart' as drive_api;
import 'package:googleapis/people/v1.dart' as people_api;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ktc_app/absent_cache.dart';
import 'package:ktc_app/ad_component.dart';
import 'package:ktc_app/ad_helper.dart';
import 'package:ktc_app/login_status.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeletons/skeletons.dart';

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
  const AbsentPage(
      {super.key,
      required MyLoginStatus currentLoginStatus,
      required this.showAds});

  final bool showAds;

  @override
  State<AbsentPage> createState() => _AbsentPageState();
}

class _AbsentPageState extends State<AbsentPage> with TickerProviderStateMixin {
  final GoogleSignIn _googleSignIn = Platform.isAndroid
      ? GoogleSignIn(
          clientId:
              "114566651471-2ne2tukjh0r1t2cn6blqmulj0e8tk49j.apps.googleusercontent.com",
          scopes: <String>[
            sheets_api.SheetsApi.spreadsheetsReadonlyScope,
            drive_api.DriveApi.driveReadonlyScope,
            people_api.PeopleServiceApi.directoryReadonlyScope,
          ],
        )
      : GoogleSignIn(
          scopes: <String>[
            sheets_api.SheetsApi.spreadsheetsReadonlyScope,
            drive_api.DriveApi.driveReadonlyScope,
            people_api.PeopleServiceApi.directoryReadonlyScope
          ],
        );

  GoogleSignInAccount? _currentUser;

  TabController? _tabController;
  int tabIndex = (DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday) - 1;

  List<List<Object?>>? absent;
  DateTime lastEdited = DateTime.fromMillisecondsSinceEpoch(0);

  String loginStatus = "in";

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  updateCache(values, peopleApi) async {
    for (int i = 0; i < values.length; i++) {
      for (int j = 1; j < values[i].length; j++) {
        bool found = false;
        for (int k = 0;
            k < currentAbsentCache.getAbsentCache().absents.length;
            k++) {
          if (values[i][j].toString().split(" - ")[0].toLowerCase() ==
              currentAbsentCache
                  .getAbsentCache()
                  .absents[k]
                  .name
                  .toLowerCase()) {
            found = true;
            break;
          }
        }
        if (!found) {
          peopleApi.people.searchDirectoryPeople(
              query: values[i][j].toString().split(" - ")[0],
              pageSize: 1,
              readMask: "emailAddresses,photos",
              sources: [
                "DIRECTORY_SOURCE_TYPE_DOMAIN_PROFILE"
              ]).then((people_api.SearchDirectoryPeopleResponse response) {
            if (response.people != null) {
              currentAbsentCache.addAbsentCache(Absent(
                  email:
                      response.people![0].emailAddresses![0].value.toString(),
                  name: values[i][j].toString().split(" - ")[0],
                  photoUrl: response.people![0].photos == null
                      ? "Default"
                      : response.people![0].photos![0].url!));
            }
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {});
        }
      }
    }
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
        var sheetsApi = sheets_api.SheetsApi(httpClient);
        sheets_api.ValueRange sheet = await sheetsApi.spreadsheets.values.get(
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
        var driveApi = drive_api.DriveApi(httpClient);
        driveApi.files
            .get("1g8BA1HngopNXsQaw-VieouP0uR1x3rAnPGYJSmloVH8",
                $fields: "modifiedTime")
            .then((file) {
          var stringFile = json.encode(file);
          DateTime editedDate =
              DateTime.parse(json.decode(stringFile)["modifiedTime"].toString())
                  .toLocal();
          setState(() {
            lastEdited = editedDate;
          });
        });
        var peopleApi = people_api.PeopleServiceApi(httpClient);
        updateCache(values, peopleApi);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      log(error.toString());
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
          indicatorColor: Theme.of(context).colorScheme.primary,
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              if (user != null) {
                if (absent != null) {
                  return TabBarView(controller: _tabController, children: [
                    for (final days in absent!)
                      RefreshIndicator(
                          onRefresh: _pullRefresh,
                          child: AbsentView(
                            days: days,
                            lastEdited: lastEdited,
                          ))
                  ]);
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 8,
                  ));
                }
              } else {
                if (loginStatus == "out") {
                  log("out");
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text(
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                        'För att se frånvarande personal måste du\nlogga in med ditt skolkonto!'),
                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                              style: TextStyle(fontSize: 12),
                                              text:
                                                  "Du måste godkänna att appen kan se alla dina "),
                                          TextSpan(
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              text: "Google Kalkylark",
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  var uri = Uri.parse(
                                                      "https://www.google.com/intl/sv/sheets/about/");
                                                  if (await canLaunchUrl(uri)) {
                                                    await launchUrl(uri);
                                                  } else {
                                                    throw 'Could not launch $uri';
                                                  }
                                                }),
                                          const TextSpan(
                                              style: TextStyle(fontSize: 12),
                                              text:
                                                  " men appen använder bara \"Frånvarande Personal DU/KTC\" kalkylarket")
                                        ]))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SignInButton(
                                  Buttons.GoogleDark,
                                  text: "Logga in med Google",
                                  onPressed: () {
                                    _handleSignIn();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: SizedBox(
                            height: 20,
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      text: "Integritetspolicy",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          var uri = Uri.parse(
                                              "https://leonhellqvist.com/ktc-appen/privacy-policy.html");
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            throw 'Could not launch $uri';
                                          }
                                        }),
                                ])),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 8,
                ));
              }
            }),
          ),
          AdComponent(
            adUnit: AdHelper.absentBannerAdUnit,
            showAds: widget.showAds,
            placeholder: loginStatus == "in" ? false : true,
          )
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var sheetsApi = sheets_api.SheetsApi(httpClient);
    sheets_api.ValueRange sheet = await sheetsApi.spreadsheets.values.get(
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
    var driveApi = drive_api.DriveApi(httpClient);
    driveApi.files
        .get("1g8BA1HngopNXsQaw-VieouP0uR1x3rAnPGYJSmloVH8",
            $fields: "modifiedTime")
        .then((file) {
      var stringFile = json.encode(file);
      DateTime editedDate =
          DateTime.parse(json.decode(stringFile)["modifiedTime"].toString())
              .toLocal();
      log(editedDate.toString());
      setState(() {
        lastEdited = editedDate;
      });
    });
  }
}

class AbsentView extends StatefulWidget {
  const AbsentView({super.key, required this.days, required this.lastEdited});

  final List<Object?> days;
  final DateTime lastEdited;
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

  String getInitials(String absent) => absent.isNotEmpty
      ? absent.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ListView.builder(
        itemCount: widget.days.length,
        itemBuilder: (context, index) {
          Absent absentCache =
              currentAbsentCache.findAbsentCache(widget.days[index].toString());
          return Padding(
            padding: index == 0
                ? const EdgeInsets.fromLTRB(20, 15, 20, 0)
                : const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              widget.days[index]
                                  .toString()
                                  .substring(widget.days[index]
                                      .toString()
                                      .indexOf(" "))
                                  .toCapitalized(),
                              textScaleFactor: 1.3),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: AnimatedSlide(
                              offset: widget.lastEdited !=
                                      DateTime.fromMillisecondsSinceEpoch(0)
                                  ? const Offset(0, 0)
                                  : const Offset(1, 0),
                              curve: Curves.easeOutExpo,
                              duration: const Duration(milliseconds: 700),
                              child: Chip(
                                label: Text(DateFormat('HH:mm - d/M')
                                    .format(widget.lastEdited)),
                                avatar: const Icon(Icons.edit),
                              ),
                            ),
                          )
                        ],
                      )
                    : Card(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: absentCache.photoUrl != "Loading"
                                ? absentCache.photoUrl == "Default"
                                    ? CircleAvatar(
                                        child:
                                            Text(getInitials(absentCache.name)),
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(absentCache.photoUrl),
                                      )
                                : const SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                        height: 40,
                                        width: 40,
                                        shape: BoxShape.circle)),
                            title: Text(
                                widget.days[index].toString().toTitleCase()),
                            subtitle: absentCache.email != "Loading"
                                ? Text(
                                    absentCache.email
                                        .replaceAll("-", "\ufeff-\ufeff"),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const SkeletonLine(
                                    style: SkeletonLineStyle(height: 14),
                                  ),
                          ),
                        ],
                      )),
                index != widget.days.length - 1
                    ? const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Divider(
                          height: 0,
                        ),
                      )
                    : const SizedBox(
                        height: 10,
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
