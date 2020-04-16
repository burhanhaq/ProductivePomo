import 'package:flutter/material.dart';

import '../constants.dart';

class BoxesDigitalClock extends StatefulWidget {
  final int min;
  final int sec;
  final double controllerValue;

  BoxesDigitalClock({@required this.min, @required this.sec, @required this.controllerValue});

  @override
  _BoxesDigitalClockState createState() => _BoxesDigitalClockState();
}

class _BoxesDigitalClockState extends State<BoxesDigitalClock> {
  int tensMin = 0;
  int onesMin = 0;
  int tensSec = 0;
  int onesSec = 0;

  setTimerValues() {
    Duration duration = Duration(
        minutes: widget.min,
        seconds: widget.sec) *
        (1 - widget.controllerValue);
    tensMin = (duration.inMinutes / 10).floor() % 10;
    onesMin = duration.inMinutes % 10;
    tensSec = ((duration.inSeconds % 60) / 10).floor() % 10;
    onesSec = (duration.inSeconds % 60) % 10;
  }
  @override
  Widget build(BuildContext context) {
    setTimerValues();
    return Row(
      children: <Widget>[
        Digit(num: tensMin),
        Digit(num: onesMin),
        SizedBox(width: 8),
        Digit(num: tensSec),
        Digit(num: onesSec),
      ],
    );
  }
}

class Digit extends StatefulWidget {
  final int num;
  Digit({@required this.num}) {
    boolList = getNumList(this.num);
  }
  var boolList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  getNumList(int num) {
    if (num == 0) {
      return [
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        false,
        false,
        true,
        true,
        true,
        true,
        true,
        true,
      ];
    } else if (num == 1) {
      return [
        false,
        false,
        false,
        false,
        false,
        true,
        true,
        true,
        true,
        true,
        false,
        false,
        false,
        false,
        false
      ];
    } else if (num == 2) {
      return [
        true,
        false,
        true,
        true,
        true,
        true,
        false,
        true,
        false,
        true,
        true,
        true,
        true,
        false,
        true,
      ];
    } else if (num == 3) {
      return [
        true,
        false,
        false,
        false,
        true,
        true,
        false,
        true,
        false,
        true,
        true,
        true,
        true,
        true,
        true,
      ];
    } else if (num == 4) {
      return [
        true,
        true,
        true,
        false,
        false,
        false,
        false,
        true,
        false,
        false,
        false,
        true,
        true,
        true,
        true,
      ];
    } else if (num == 5) {
      return [
        true,
        true,
        true,
        false,
        true,
        true,
        false,
        true,
        false,
        true,
        true,
        false,
        true,
        true,
        true,
      ];
    } else if (num == 6) {
      return [
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        true,
        false,
        true,
        true,
        false,
        true,
        true,
        true,
      ];
    } else if (num == 7) {
      return [
        true,
        false,
        false,
        false,
        false,
        true,
        false,
        false,
        false,
        false,
        true,
        true,
        true,
        true,
        true,
      ];
    } else if (num == 8) {
      return [
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        true,
        false,
        true,
        true,
        true,
        true,
        true,
        true
      ];
    } else if (num == 9) {
      return [
        true,
        true,
        true,
        false,
        false,
        true,
        false,
        true,
        false,
        false,
        true,
        true,
        true,
        true,
        true
      ];
    } else {
      return [
        true,
        false,
        false,
        false,
        true,
        false,
        false,
        true,
        false,
        false,
        true,
        false,
        false,
        false,
        true
      ];
    }
  }

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> {
  double spacing = 0.3;

  @override
  Widget build(BuildContext context) {
    bool zero = widget.boolList[0];
    bool one = widget.boolList[1];
    bool two = widget.boolList[2];
    bool three = widget.boolList[3];
    bool four = widget.boolList[4];
    bool five = widget.boolList[5];
    bool six = widget.boolList[6];
    bool seven = widget.boolList[7];
    bool eighth = widget.boolList[8];
    bool nine = widget.boolList[9];
    bool ten = widget.boolList[10];
    bool eleven = widget.boolList[11];
    bool twelve = widget.boolList[12];
    bool thirteen = widget.boolList[13];
    bool fourteen = widget.boolList[14];
    return Row(
      children: <Widget>[
        Column(
          children: [
            BoxContainer(isActive: zero),
            SizedBox(height: spacing),
            BoxContainer(isActive: one),
            SizedBox(height: spacing),
            BoxContainer(isActive: two),
            SizedBox(height: spacing),
            BoxContainer(isActive: three),
            SizedBox(height: spacing),
            BoxContainer(isActive: four),
          ],
        ),
        SizedBox(width: spacing),
        Column(
          children: [
            BoxContainer(isActive: five),
            SizedBox(height: spacing),
            BoxContainer(isActive: six),
            SizedBox(height: spacing),
            BoxContainer(isActive: seven),
            SizedBox(height: spacing),
            BoxContainer(isActive: eighth),
            SizedBox(height: spacing),
            BoxContainer(isActive: nine),
          ],
        ),
        SizedBox(width: spacing),
        Column(
          children: [
            BoxContainer(isActive: ten),
            SizedBox(height: spacing),
            BoxContainer(isActive: eleven),
            SizedBox(height: spacing),
            BoxContainer(isActive: twelve),
            SizedBox(height: spacing),
            BoxContainer(isActive: thirteen),
            SizedBox(height: spacing),
            BoxContainer(isActive: fourteen),
          ],
        ),
      ],
    );
  }
}


class BoxContainer extends StatefulWidget {
//  Color isActive;
  bool isActive;

  BoxContainer({@required this.isActive});

  @override
  _BoxContainerState createState() => _BoxContainerState();
}

class _BoxContainerState extends State<BoxContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 650),
      height: kBoxDim,
      width: kBoxDim,
      color: widget.isActive ? kHit : trans,
    );
  }
}
