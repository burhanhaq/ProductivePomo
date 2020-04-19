import 'package:flutter/material.dart';

import '../constants.dart';

class BoxesDigitalClock extends StatefulWidget {
  final int min;
  final int sec;
  final AnimationController timerController;

  BoxesDigitalClock(
      {@required this.min, @required this.sec, @required this.timerController});

  @override
  _BoxesDigitalClockState createState() => _BoxesDigitalClockState();
}

class _BoxesDigitalClockState extends State<BoxesDigitalClock> {
  int tensMin = 0;
  int onesMin = 0;
  int tensSec = 0;
  int onesSec = 0;

  setTimerValues() {
    Duration duration = Duration(minutes: widget.min, seconds: widget.sec) *
        (1 - widget.timerController.value);
    tensMin = (duration.inMinutes / 10).floor() % 10;
    onesMin = duration.inMinutes % 10;
    tensSec = ((duration.inSeconds % 60) / 10).floor() % 10;
    onesSec = (duration.inSeconds % 60) % 10;
  }

  @override
  Widget build(BuildContext context) {
    setTimerValues();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Digit(num: tensMin),
        SizedBox(width: 5),
        Digit(num: onesMin),
        SizedBox(width: 10),
        Digit(num: tensSec, extraPadding: -8),
        SizedBox(width: 5),
        Digit(num: onesSec, extraPadding: -8),
      ],
    );
  }
}

class Digit extends StatefulWidget {
  final int num;
  final double extraPadding;
  var boolList = [];

  Digit({@required this.num, this.extraPadding}) {
    boolList = getNumList(this.num);
  }

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
    double zeroPadding = 0; // useless so far
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
            Padding(
                padding: EdgeInsets.all(zeroPadding),
                child: BoxContainer(
                    isActive: zero, extraPadding: widget.extraPadding)),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: one,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: two,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: three,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: four,
                extraPadding: widget.extraPadding,
              ),
            ),
          ],
        ),
        SizedBox(width: spacing),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: five,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: six,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: seven,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: eighth,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: nine,
                extraPadding: widget.extraPadding,
              ),
            ),
          ],
        ),
        SizedBox(width: spacing),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: ten,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: eleven,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: twelve,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: thirteen,
                extraPadding: widget.extraPadding,
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.all(zeroPadding),
              child: BoxContainer(
                isActive: fourteen,
                extraPadding: widget.extraPadding,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BoxContainer extends StatefulWidget {
  bool isActive;
  double extraPadding = 0; // not being used

  BoxContainer({@required this.isActive, @required this.extraPadding}) {
    if (extraPadding == null) extraPadding = 0;
  }

  @override
  _BoxContainerState createState() => _BoxContainerState();
}

class _BoxContainerState extends State<BoxContainer> {
  @override
  Widget build(BuildContext context) {
    double sideLength = kBoxDim + widget.extraPadding;
    return AnimatedContainer(
      duration: Duration(milliseconds: 650),
      height: sideLength,
      width: sideLength,
      color: widget.isActive ? kBoxColor : trans,
    );
  }
}
