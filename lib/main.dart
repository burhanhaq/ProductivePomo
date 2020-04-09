import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: Theme.of(context).copyWith(
        primaryColor: Color(0xffF7CE47),
        accentColor: Color(0xff343437),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: Home(),
    );
  }
}
