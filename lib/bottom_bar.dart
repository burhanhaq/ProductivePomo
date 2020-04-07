import 'dart:math' as math;

import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
//  AnimationController controller;
//  CountdownTimer(this.controller);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * (1 - controller.value);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  IconData playIcon = Icons.play_arrow;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF141414),
      child: SizedBox(
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.translate(
              offset: Offset(-MediaQuery.of(context).size.width / 4, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(playIcon, size: 60),
                            Text(timerString, style: TextStyle(fontSize: 40.0)),
                          ],
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          print('Button pressed');
                          setState(() {
                            if (controller.isAnimating) {
                              controller.stop();
                              playIcon = Icons.play_arrow;
                            } else {
                              controller.forward(
                                  from: controller.value == 1.0
                                      ? 0.0
                                      : controller.value);
                              playIcon = Icons.pause;
                            }
                          });
                        },
                      );
                    },
                  ),
//                  Text(timerString),
//                  Text('Two'),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(MediaQuery.of(context).size.width / 4, -100),
              child: Container(
                height: 150,
                width: 150,
//                color: Colors.white,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return CustomPaint(
                        painter: CustomTimerPainter(
                      animation: controller,
                      backgroundColor: Colors.green,
                      color: Colors.white,
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;
  CustomTimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
