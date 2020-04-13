import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../constants.dart';

class Clock extends StatefulWidget {
  final Duration duration;
  Clock({@required this.duration});
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = widget.duration * (1 - controller.value);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  IconData playIcon = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 150, width: 150,
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return CustomPaint(
                  painter: CustomTimerPainter(
                animation: controller,
                backgroundColor: red1,
                color: grey,
              ));
            },
          ),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              width: 135,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(playIcon, size: 25, color: red3),
                    Text(timerString, style: TextStyle(fontSize: 25.0, color: red2)),
                  ],
                ),
                color: red1,
                onPressed: () {
                  print('Button pressed');
                  setState(() {
                    if (controller.isAnimating) {
                      controller.stop();
                      playIcon = Icons.play_arrow;
                    } else {
                      controller.forward(
                          from:
                          controller.value == 1.0 ? 0.0 : controller.value);
                      playIcon = Icons.pause;
                    }
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
