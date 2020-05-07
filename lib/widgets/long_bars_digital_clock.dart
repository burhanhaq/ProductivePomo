import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../constants.dart';

class LongBarsDigitalClock extends StatefulWidget {
  @override
  _LongBarsDigitalClockState createState() => _LongBarsDigitalClockState();
}

class _LongBarsDigitalClockState extends State<LongBarsDigitalClock>
    with TickerProviderStateMixin {
  AnimationController conTRU;
  Animation aniTRU;
  AnimationController conTRD;
  Animation aniTRD;

  @override
  void initState() {
    super.initState();
    conTRU = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    aniTRU = Tween(begin: 0.0, end: math.pi / 2).animate(conTRU)
      ..addListener(() {
        setState(() {});
      });
    conTRD = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    aniTRD = Tween(begin: 0.0, end: math.pi / 2).animate(conTRD)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: kLong + 2 * kShort,
          child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // 1
                children: [
                  EmptyContainer(),
                  RowContainer(),
                  EmptyContainer(),
                ],
              ),
              Row(
                // 2
                children: [
                  ColContainer(),
                  Expanded(child: Container()),
                  Transform.rotate(
                    angle: aniTRU.value,
                    alignment: Alignment.topCenter,
                    origin: Offset(0, -kRotOffset),
                    child: Transform.rotate(
                      angle: aniTRD.value,
                      alignment: Alignment.bottomCenter,
                      origin: Offset(0, kRotOffset),
                      child: ColContainer(),
                    ),
                  ),
                ],
              ),
              Row(
                // 3
                children: [
                  EmptyContainer(),
                  RowContainer(),
                  EmptyContainer(),
                ],
              ),
              Row(
                // 4
                children: [
                  ColContainer(),
                  Expanded(child: Container()),
                  ColContainer(),
                ],
              ),
              Row(
                // 5
                children: [
                  EmptyContainer(),
                  RowContainer(),
                  EmptyContainer(),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
            onTap: () {
              if (conTRU.isCompleted) {
                print('reverse');
                conTRU.reverse();
              } else {
                print('forward');
                conTRU.forward();
              }
            },
            child: Container(height: 60, width: 60, color: Colors.green)),
        GestureDetector(
            onTap: () {
              if (conTRD.isCompleted) {
                print('reverse');
                conTRD.reverse();
              } else {
                print('forward');
                conTRD.forward();
              }
            },
            child: Container(height: 60, width: 60, color: Colors.red)),
      ],
    );
  }
  @override
  void dispose() {
    conTRD.dispose();
    conTRU.dispose();
    super.dispose();
  }
}

class RowContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kShort,
      width: kLong,
      color: blue,
    );
  }
}

class ColContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kLong,
      width: kShort,
      color: blue,
    );
  }
}

class EmptyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kShort,
      height: kShort,
      color: Colors.transparent,
    );
  }
}
