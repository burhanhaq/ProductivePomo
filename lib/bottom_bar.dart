import 'dart:math' as math;

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
//  AnimationController controller;
//  CountdownTimer(this.controller);
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

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
              offset: Offset(0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(playIcon, size: 50),
                          ],
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          print('Button pressed');
                          setState(() {
                            if (controller.isAnimating) {
                              controller.stop();
                              playIcon = Icons.pause;
                            } else {
                              controller.reverse(
                                  from: controller.value == 0.0
                                      ? 1.0
                                      : controller.value);
                              playIcon = Icons.play_arrow;
                            }
                          });
                        },
                      );
                    },
                  ),
                  Text('Two'),
//                        Text('Two'),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(MediaQuery.of(context).size.width / 4, -80),
              child: Container(
                height: 150,
                width: 150,
//                        color: Colors.white,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return CustomPaint(
                        painter: CustomTimerPainter(
                      animation: controller,
                      backgroundColor: Colors.white,
                      color: Colors.yellow,
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
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
