import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: Theme.of(context).copyWith(
        primaryColor: Color(0xFFEB5757),
        accentColor: Color(0xFF343434),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: Home(),
    );
  }
}
