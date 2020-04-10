import 'package:flutter/material.dart';

import 'home.dart';
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
//        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
//      home: Home(),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/second': (context) => SecondScreen(),
      },
    );
  }
}
