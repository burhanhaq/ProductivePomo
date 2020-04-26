import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../constants.dart';
import '../../widgets/animating_crosshair.dart';

class OnboardingScreen extends StatefulWidget {
  static final String id = 'OnboardingScreen';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  var rotateTextController;
  var scaleController;
  var xTranslateController;
  var yTranslateController;
  var yTranslateController2;
  var opacityController;
  var randomLoc = math.Random();
  var randomWidth;
  var randomHeight;

  @override
  void initState() {
    super.initState();
    randomWidth = randomLoc.nextDouble();
    randomHeight = randomLoc.nextDouble();

    rotateTextController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    xTranslateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    yTranslateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    yTranslateController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    opacityController = AnimationController(
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

    if (yTranslateController.status == AnimationStatus.completed) {
      xTranslateController.forward();
      scaleController.forward();
      if (xTranslateController.status == AnimationStatus.completed) {
        yTranslateController2.forward();
        if (yTranslateController2.status == AnimationStatus.completed) {
          rotateTextController.forward();
          if (rotateTextController.status == AnimationStatus.completed) {
            scaleController.reverse();
            if (scaleController.status == AnimationStatus.dismissed) {
              opacityController.forward();
            }
          }
        }
      }
    }

    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          yTranslateController.forward();
          print('tapped nickname');
        },
        onVerticalDragDown: (details) {
          yTranslateController.reverse();
          yTranslateController2.reverse();
          xTranslateController.reverse();
          rotateTextController.reverse();
          opacityController.reverse();
        },
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              color: red1,
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(
                      (-width / 3) * (1 - xTranslateController.value),
                      (height * 0.5) * (1 - yTranslateController.value) +
                          (height * 0.4) * (1 - yTranslateController2.value),
                    ),
                    child: Transform.rotate(
                      alignment: FractionalOffset.center,
                      angle: -math.pi / 2 * (1 - rotateTextController.value),
                      child: Transform.scale(
                        scale: 1 + 1.5 * scaleController.value,
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          'nickname',
                          style: TextStyle(
                            color: yellow,
                            fontSize: 60,
                            fontWeight: FontWeight.w100,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
//                  opacity: opacityController.value,
                    opacity: 1.0,
                    child: Transform.translate(
                      offset: Offset(140, 50),
                      child: Icon(Icons.arrow_forward, color: yellow, size: 60),
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
                offset: Offset(randomWidth * width*0.8 - width/2*0.8,
                    randomHeight * height*0.8 - height/2*0.8),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                      randomWidth = randomLoc.nextDouble();
                      randomHeight = randomLoc.nextDouble();
                      });
                      print('tapped crosshair----------------------');
                    },
                    child: AnimatingCrosshair())),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    rotateTextController.dispose();
    opacityController.dispose();
    scaleController.dispose();
    yTranslateController.dispose();
    yTranslateController2.dispose();
    xTranslateController.dispose();
    super.dispose();
  }
}
