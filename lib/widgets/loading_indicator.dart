import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../constants.dart';

class LoadingIndicator extends StatefulWidget {
  bool showLoadingIndicator;
  int rotationsToDisableAfter;

  LoadingIndicator({
    @required this.showLoadingIndicator,
    this.rotationsToDisableAfter = 0,
  });

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  var ballSizeController;
  var rotationController;

  @override
  void initState() {
    super.initState();
    ballSizeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          rotationController.stop(); // todo check if it stops, it probably doesn't stop
        }
      });
    ballSizeController.forward();
    rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 850),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
      });
  }

  var rotations = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.showLoadingIndicator) {
      ballSizeController.forward();
      rotationController.forward();
    } else {
      ballSizeController.reverse();
    }
    if (rotationController.status == AnimationStatus.dismissed ||
        rotationController.status == AnimationStatus.completed) {
      rotationController.forward(from: 0.0);
      ++rotations;
    }
    if (widget.rotationsToDisableAfter != 0 &&
        widget.rotationsToDisableAfter == rotations) {
      widget.showLoadingIndicator = false;
      rotations = 0;
    }

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Ball(
            c: red1,
            translateOffset: Offset(0, -20),
            rotateOrigin: Offset(0, 20),
            rotationControllerValue: rotationController.value,
            sizeControllerValue: ballSizeController.value,
          ),
          Ball(
            c: red1,
            translateOffset: Offset(0, 20),
            rotateOrigin: Offset(0, -20),
            rotationControllerValue: rotationController.value,
            sizeControllerValue: ballSizeController.value,
          ),
          Ball(
            c: yellow,
            translateOffset: Offset(-20, 0),
            rotateOrigin: Offset(20, 0),
            rotationControllerValue: rotationController.value,
            sizeControllerValue: ballSizeController.value,
          ),
          Ball(
            c: yellow,
            translateOffset: Offset(20, 0),
            rotateOrigin: Offset(-20, 0),
            rotationControllerValue: rotationController.value,
            sizeControllerValue: ballSizeController.value,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ballSizeController.dispose();
    rotationController.dispose();
    super.dispose();
  }
}

class Ball extends StatelessWidget {
  final c;
  final translateOffset;
  final rotateOrigin;
  final rotationControllerValue;
  final sizeControllerValue;

  Ball({
    @required this.c,
    @required this.translateOffset,
    @required this.rotateOrigin,
    @required this.rotationControllerValue,
    @required this.sizeControllerValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.translate(
        offset: translateOffset,
        child: Transform.rotate(
          origin: rotateOrigin,
          angle: 2 * math.pi * rotationControllerValue,
          child: Container(
            width: 4 * sizeControllerValue,
            height: 4 * sizeControllerValue,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
