import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../constants.dart';


class AnimatingCrosshair extends StatefulWidget {
  @override
  _AnimatingCrosshairState createState() => _AnimatingCrosshairState();
}

class _AnimatingCrosshairState extends State<AnimatingCrosshair>
    with TickerProviderStateMixin {
  final spacingOffset = 20.0;
  final iconSize = 40.0;

  var rotateCrosshairController;
  var scaleCrosshairController;

  @override
  void initState() {
    super.initState();
    rotateCrosshairController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..addListener(() {
      setState(() {});
    });
    scaleCrosshairController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!rotateCrosshairController.isAnimating) {
      rotateCrosshairController.forward(from: 0.0);
    }
    switch (scaleCrosshairController.status) {
      case AnimationStatus.completed:
        scaleCrosshairController.reverse();
        break;
      case AnimationStatus.dismissed:
        scaleCrosshairController.forward();
        break;
    }
    return Container(
      width: 80,
      height: 80,
      color: trans,
      child: Transform.rotate(
        angle: math.pi / 2 * rotateCrosshairController.value,
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 0.2 + 0.4 * scaleCrosshairController.value,
          child: Stack(
            alignment: FractionalOffset.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, -spacingOffset),
                child: Icon(Icons.keyboard_arrow_down,
                    color: yellow, size: iconSize),
              ),
              Transform.translate(
                offset: Offset(0, spacingOffset),
                child: Icon(Icons.keyboard_arrow_up,
                    color: yellow, size: iconSize),
              ),
              Transform.translate(
                offset: Offset(-spacingOffset, 0),
                child: Icon(Icons.keyboard_arrow_right,
                    color: yellow, size: iconSize),
              ),
              Transform.translate(
                offset: Offset(spacingOffset, 0),
                child: Icon(Icons.keyboard_arrow_left,
                    color: yellow, size: iconSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scaleCrosshairController.dispose();
    rotateCrosshairController.dispose();
    super.dispose();
  }
}
