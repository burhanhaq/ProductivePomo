import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/onboarding/onboarding_screen.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/animating_crosshair.dart';
import '../home/home_screen.dart';
import '../../card_state.dart';

class OnboardingScreen2 extends StatefulWidget {
  static final String id = 'OnboardingScreen2';

  @override
  _OnboardingScreen2State createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2>
    with TickerProviderStateMixin {
  var randomLoc = math.Random();
  var randomWidth;
  var randomHeight;

  var cursorOpacityController;
  var cursorErrorController;
  var nextIconOpacityController;

  var nOff = true;
  var aOff = true;
  var mOff = true;
  var eOff = true;
  int taps = 0;

  @override
  void initState() {
    super.initState();
    randomWidth = randomLoc.nextDouble();
    randomHeight = randomLoc.nextDouble();

    cursorOpacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        setState(() {});
      });
    cursorErrorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          cursorErrorController.reverse();
        }
      });
    nextIconOpacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (cursorOpacityController.status == AnimationStatus.completed) {
      cursorOpacityController.reverse();
    } else if (cursorOpacityController.status == AnimationStatus.dismissed) {
      cursorOpacityController.forward();
    }

    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print('tapped main');
          setState(() {
            randomWidth = randomLoc.nextDouble();
            randomHeight = randomLoc.nextDouble();
            cursorErrorController.forward();
            nextIconOpacityController.reverse();

            nOff = true;
            aOff = true;
            mOff = true;
            eOff = true;
            taps = 0;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          // add a controller or something here maybe
          color: red1,
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Offstage(
                    offstage: nOff,
                    child: Text(
                      'n',
                      style: kOnboardingStyle,
                    ),
                  ),
                  Offstage(
                    offstage: aOff,
                    child: Text(
                      'a',
                      style: kOnboardingStyle,
                    ),
                  ),
                  Offstage(
                    offstage: mOff,
                    child: Text(
                      'm',
                      style: kOnboardingStyle,
                    ),
                  ),
                  Offstage(
                    offstage: eOff,
                    child: Text(
                      'e',
                      style: kOnboardingStyle,
                    ),
                  ),
                  Opacity(
                    opacity: cursorOpacityController.value,
                    child: Container(
                      width: 2,
                      height: 80,
                      color: yellow,
                    ),
                  ),
                  SizedBox(width: 0 + 40 * cursorErrorController.value),
                ],
              ),
              Transform.translate(
                offset: Offset(140, 0),
                child: IgnorePointer(
                  ignoring: taps != 4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('phew');
                      Navigator.pushNamed(context, Home.id);
                    },
                    child: Opacity(
                      opacity: nextIconOpacityController.value,
                      child: Icon(Icons.arrow_forward, color: yellow, size: 60),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(randomWidth * width * 0.8 - width / 2 * 0.8,
                    randomHeight * height * 0.8 - height / 2 * 0.8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      randomWidth = randomLoc.nextDouble();
                      randomHeight = randomLoc.nextDouble();
                      switch (++taps) {
                        case 1:
                          nOff = false;
                          break;
                        case 2:
                          aOff = false;
                          break;
                        case 3:
                          mOff = false;
                          break;
                        case 4:
                          eOff = false;
                          nextIconOpacityController.forward();
                          break;
                        default:
                          nextIconOpacityController.reverse();
                          nOff = true;
                          aOff = true;
                          mOff = true;
                          eOff = true;
                          taps = 0;
                      }
                    });
                  },
                  child: AnimatingCrosshair(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cursorOpacityController.dispose();
    nextIconOpacityController.dispose();
    cursorErrorController.dispose();
    super.dispose();
  }
}
