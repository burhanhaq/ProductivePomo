import 'package:flutter/material.dart';

import '../constants.dart';

class BoxesDigitalClock extends StatefulWidget {
  final int num;
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

  BoxesDigitalClock({@required this.num}) {
    boolList = getNumList(this.num);
  }

  getNumList(int num) {
    print(num);
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
  _BoxesDigitalClockState createState() => _BoxesDigitalClockState();
}

class _BoxesDigitalClockState extends State<BoxesDigitalClock> {
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
            BoxContainer(isActive: one),
            BoxContainer(isActive: two),
            BoxContainer(isActive: three),
            BoxContainer(isActive: four),
          ],
        ),
        Column(
          children: [
            BoxContainer(isActive: five),
            BoxContainer(isActive: six),
            BoxContainer(isActive: seven),
            BoxContainer(isActive: eighth),
            BoxContainer(isActive: nine),
          ],
        ),
        Column(
          children: [
            BoxContainer(isActive: ten),
            BoxContainer(isActive: eleven),
            BoxContainer(isActive: twelve),
            BoxContainer(isActive: thirteen),
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
