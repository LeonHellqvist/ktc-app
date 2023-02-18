import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animations/animations.dart';
import 'package:ktc_app/caller.dart';
import 'package:ktc_app/preload_image.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'config.dart';

import 'schedule/schedule.dart';
import 'food/food.dart';
import 'absent.dart';
import 'settings/settings.dart';
import 'onboarding.dart';

Future<void> main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('database');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await loadImage(const AssetImage('assets/images/ktcBuilding.png'));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
    currentGroupGuid.addListener(() {
      setState(() {});
    });
    currentLoginStatus.addListener(() {
      setState(() {});
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        // On Android S+ devices, use the provided dynamic color scheme.
        // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
        if (currentTheme.currentThemeDynamic()) {
          lightColorScheme = lightDynamic;

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic;
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.green,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          );
        }
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.green,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        );
      }

      return MaterialApp(
        title: 'KTC Appen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: lightColorScheme,
          appBarTheme: const AppBarTheme(
            elevation: 2,
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: darkColorScheme,
            useMaterial3: true,
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.white,
            )
            /* dark theme settings */
            ),
        themeMode: currentTheme.currentTheme(),
        home: const MyHomePage(title: 'KTC Appen'),
        routes: {'/onboarding': (context) => const MyOnboardingPage()},
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;
  String _authStatus = 'Unknown';

  late CacheStore cacheStore;
  late CacheOptions cacheOptions;
  late Dio dio;
  late Caller caller;

  late final List<Widget> pageList;

  late bool showAds;

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      log(status.toString());
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    MobileAds.instance.initialize();
    log("UUID: $uuid");
  }

  @override
  void initState() {
    showAds = true;
    if (Platform.isIOS) {
      initPlugin();
    }
    cacheStore = HiveCacheStore(null);
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
    pageList = <Widget>[
      SchedulePage(
        currentGroupGuid: currentGroupGuid,
        dio: dio,
        showAds: showAds,
      ),
      FoodPage(dio: dio, showAds: showAds),
      AbsentPage(currentLoginStatus: currentLoginStatus, showAds: showAds),
      SettingsPage(
          currentGroupGuid: currentGroupGuid,
          currentLoginStatus: currentLoginStatus)
    ];
    super.initState();
    Future(() {
      if (currentGroupGuid.currentGroupGuid() == "") {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    dio.close();
    cacheStore.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          child,
          animation,
          secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pageList[_pageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
        selectedIndex: _pageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.schedule),
            label: 'Schema',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Matsedel',
          ),
          NavigationDestination(
            icon: Icon(Icons.sick),
            label: 'Frånvarande',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Inställningar',
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<void> showCustomTrackingDialog(BuildContext context) async =>
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kära KTCare'),
        content: const Text(
          'Jag håller den här appen gratis genom att visa annonser. \n'
          'Kan jag fortsätta att använda din data för att skräddarsy annonser åt dig? '
          'Google samlar in och använder en unik identifierare på din enhet för att visa dig annonser.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fortsätt'),
          ),
        ],
      ),
    );
