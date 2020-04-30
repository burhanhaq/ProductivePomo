import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home/home_screen.dart';
import 'constants.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/onboarding_screen_2.dart';
import 'card_state.dart';

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
//      initialRoute: OnboardingScreen2.id,
      initialRoute: Home.id,
      routes: <String, WidgetBuilder>{
        OnboardingScreen2.id: (context) => OnboardingScreen2(),
        Home.id: (context) => ChangeNotifierProvider(
            create: (context) => CardState()..resetNewVariables(),
            child: Home()),
      },
    );
  }
}
