import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:ktc_app/components/selectors/favorites_selector.dart';
import 'package:ktc_app/components/selectors/primary_selector.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:ktc_app/group_guid.dart';
import 'package:ktc_app/login_status.dart';

import '../config.dart';

import '../util/license.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key,
      required MyGroupGuid currentGroupGuid,
      required MyLoginStatus currentLoginStatus});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  Color pickerColor = currentTheme.currentThemeDynamic().startsWith("custom")
      ? TinyColor.fromString(
              currentTheme.currentThemeDynamic().split("custom")[1])
          .color
      : const Color.fromARGB(255, 26, 120, 47);
  Color currentColor = currentTheme.currentThemeDynamic().startsWith("custom")
      ? TinyColor.fromString(
              currentTheme.currentThemeDynamic().split("custom")[1])
          .color
      : const Color.fromARGB(255, 26, 120, 47);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inställningar"),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            ExpansionTile(
              title: const Text('Utseende'),
              subtitle: const Text("Anpassa utseendet"),
              children: <Widget>[
                ListTile(
                    title: Row(children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: FilledButton.tonal(
                        onPressed: () {
                          currentTheme.switchThemeDynamic("app");
                        },
                        child: const Text("App tema")),
                  )),
                  Platform.isAndroid
                      ? Expanded(
                          child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: FilledButton.tonal(
                              onPressed: () {
                                currentTheme.switchThemeDynamic("system");
                              },
                              child: const Text("System")),
                        ))
                      : const SizedBox(),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: FilledButton.tonal(
                        onPressed: () {
                          showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) =>
                                  DefaultTabController(
                                    initialIndex: 0,
                                    length: 2,
                                    child: AlertDialog(
                                      title: const Text('Välj en temafärg'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: changeColor,
                                          enableAlpha: false,
                                          pickerAreaBorderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(30)),
                                          pickerAreaHeightPercent: 0.8,
                                          labelTypes: const [],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('Använd'),
                                          onPressed: () {
                                            currentTheme.switchThemeDynamic(
                                                "custom#${TinyColor.fromColor(pickerColor).toHex8().toString().substring(2)}");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: const Text("Eget tema")),
                  )),
                ])),
                ListTile(
                    title: FilledButton.tonal(
                  onPressed: () {
                    currentTheme.switchTheme();
                  },
                  child: const Text('Ändra mörkt/ljust läge'),
                )),
              ],
            ),
            ExpansionTile(
              title: const Text('Schema'),
              subtitle: const Text("Ändra klass"),
              children: <Widget>[
                ListTile(
                    title: Row(
                  children: const [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: PrimarySelector(),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: FavoritesSelector(),
                    )),
                  ],
                )),
                ListTile(
                    title: FilledButton.tonal(
                  onPressed: () {
                    currentTheme.switchThemeScheduleView();
                  },
                  child: const Text('Ändra vanligt/block schema'),
                )),
              ],
            ),
            ExpansionTile(
              title: const Text('Medverkande'),
              subtitle: const Text("Se alla som hjälpt till"),
              children: <Widget>[
                ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: InkWell(
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://github.com/leonhellqvist')),
                                  child: Image.asset(
                                      height: 20,
                                      'assets/images/github-mark-white.png'),
                                ),
                              ),
                              const Text("Leon Hellqvist, TE21"),
                            ],
                          ),
                          const Text("Skapare"),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: InkWell(
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://github.com/erikdahlqvist')),
                                  child: Image.asset(
                                      height: 20,
                                      'assets/images/github-mark-white.png'),
                                ),
                              ),
                              const Text("Erik Dahlqvist, TE21"),
                            ],
                          ),
                          const Text("Små fixar"),
                        ],
                      ),
                      TextButton(
                        child:
                            const Text("Vill du hjälpa till? Besök projektet"),
                        onPressed: () => {_launchUrl()},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Integritet'),
              subtitle: const Text("Se integritetpolicyn och användarvilloren"),
              children: <Widget>[
                ListTile(
                  title: Column(
                    children: [
                      TextButton(
                        child: const Text("Integritetspolicy"),
                        onPressed: () => {_launchUrlPrivacy()},
                      ),
                      TextButton(
                        child: const Text("Användarvillkor"),
                        onPressed: () => {_launchUrlTerms()},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            currentLoginStatus.getLoginStatus() == "in"
                ? ExpansionTile(
                    title: const Text('Google konto'),
                    subtitle: const Text("Hantera ditt Google konto"),
                    children: <Widget>[
                      ListTile(
                          title: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: FilledButton.tonal(
                            child:
                                const Text("Logga ut från ditt Google konto"),
                            onPressed: () =>
                                {currentLoginStatus.setLoginStatus("logout")},
                          ),
                        ),
                      )),
                    ],
                  )
                : const Text(""),
            ListTile(
              title: const Text('Programvara från tredje part'),
              subtitle:
                  const Text("Bra programvara som hjälpt med detta projekt"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LicenseScreen()),
                );
              },
            ),
          ]),
        ));
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(Uri.parse('https://github.com/LeonHellqvist/ktc-app'))) {
    throw 'Could not launch github';
  }
}

Future<void> _launchUrlPrivacy() async {
  if (!await launchUrl(
      Uri.parse('https://leonhellqvist.com/ktc-appen/privacy-policy.html'))) {
    throw 'Could not launch privacy policy';
  }
}

Future<void> _launchUrlTerms() async {
  if (!await launchUrl(
      Uri.parse('https://leonhellqvist.com/ktc-appen/terms-of-service.html'))) {
    throw 'Could not launch terms';
  }
}

class GroupOptionsEntry {
  const GroupOptionsEntry(this.groupName, this.groupGuid);
  final String groupName;
  final String groupGuid;
}

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textScaleFactor: 0.8, 'Programvara från tredje part'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: LicenseUtil.getLicenses().length,
          itemBuilder: (context, index) {
            final item = LicenseUtil.getLicenses()[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                color: Colors.black12,
                child: Column(
                  children: [
                    Text(item.name),
                    Text(item.version ?? 'n/a'),
                    Text(item.homepage ?? 'n/a'),
                    Text(item.repository ?? 'n/a'),
                    Container(height: 8),
                    Text(item.license),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
