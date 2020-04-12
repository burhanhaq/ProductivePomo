import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'constants.dart';
import 'second_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: Theme.of(context).copyWith(
        primaryColor: yellow,
        accentColor: grey,
      ),
//      home: Home(),
      initialRoute: Home.id,
      routes: {
        Home.id: (context) => Home(),
        SecondScreen.id: (context) => SecondScreen(),
      },
    );
  }
}
