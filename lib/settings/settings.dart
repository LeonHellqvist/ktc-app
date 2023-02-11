import 'dart:convert';
import 'dart:io';

import 'package:ktc_app/components/selectors/favorites_selector.dart';
import 'package:ktc_app/components/selectors/primary_selector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktc_app/group_guid.dart';
import 'package:ktc_app/login_status.dart';

import '../config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key,
      required MyGroupGuid currentGroupGuid,
      required MyLoginStatus currentLoginStatus});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inställningar"),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          ExpansionTile(
            title: const Text('Utseende'),
            subtitle: const Text("Anpassa utseendet"),
            children: <Widget>[
              ListTile(
                  title: FilledButton.tonal(
                onPressed: () {
                  currentTheme.switchTheme();
                },
                child: const Text('Ändra mörkt/ljust läge'),
              )),
              Platform.isAndroid
                  ? ListTile(
                      title: FilledButton.tonal(
                      onPressed: () {
                        currentTheme.switchThemeDynamic();
                      },
                      child: const Text('Ändra dynamiskt/standard tema'),
                    ))
                  : const SizedBox(height: 0),
            ],
          ),
          ExpansionTile(
            title: Text('Schema'),
            subtitle: Text("Ändra klass"),
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
            ],
          ),
          ExpansionTile(
            title: const Text('Medverkande'),
            subtitle: const Text("Se alla som hjälpt till"),
            children: <Widget>[
              ListTile(
                title: Column(
                  children: [
                    const Text("Leon Hellqvist | TE21"),
                    TextButton(
                      child: const Text("Vill du hjälpa till? Besök projektet"),
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
                          child: const Text("Logga ut från ditt Google konto"),
                          onPressed: () =>
                              {currentLoginStatus.setLoginStatus("logout")},
                        ),
                      ),
                    )),
                  ],
                )
              : const Text(""),
        ]));
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
