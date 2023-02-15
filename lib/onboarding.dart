import 'package:flutter/material.dart';
import 'package:ktc_app/components/selectors/favorites_selector.dart';
import 'package:ktc_app/config.dart';
import 'package:ktc_app/components/selectors/primary_selector.dart';

class MyOnboardingPage extends StatefulWidget {
  const MyOnboardingPage({super.key});

  @override
  State<MyOnboardingPage> createState() => _MyOnboardingPageState();
}

const snackBar = SnackBar(
  content: Text('Du måste välja både din klass och en alternativ klass!'),
  backgroundColor: Colors.red,
);

class _MyOnboardingPageState extends State<MyOnboardingPage>
    with TickerProviderStateMixin {
  void homeScreen() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void hasSelected() {
    if (currentGroupGuid.currentGroupName() == "") {
      showError();
    } else {
      currentGroupGuid.setMainGroup(currentGroupGuid.currentGroupGuid(),
          currentGroupGuid.currentGroupName());
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Column(
              children: <Widget>[
                Image.asset("assets/images/ktcBuilding.png"),
                const Text(
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    "KTC Appen"),
                const Text(
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                    "Välkommen till KTC Appen! Här kan du se ditt schema, matsedeln och frånvarande lärare"),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                      "För att komma igång måste du bara ange ditt primära schema och välja några favoritklasser som du snabbt kan byta mellan om du vill"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: FilledButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: hasSelected,
                    child: const Text("Börja använda appen!"),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
