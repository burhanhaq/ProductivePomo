import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'constants.dart';

class CustomCard extends StatefulWidget {
  final String title;
  CustomCard({@required this.title});
  @override
  _CustomCardState createState() => _CustomCardState();
}

enum Position { None, Left, Right }

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  int count = 0;
  Position pos = Position.None;
  AnimationController flipCardController;
  Animation flipCardAnimation;
  AnimationStatus flipCardStatus = AnimationStatus.dismissed;
  double x = 0;
  double y = 0;
  double z = 0;
  @override
  void initState() {
    super.initState();
    flipCardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    flipCardAnimation =
        Tween<double>(end: 1, begin: 0).animate(flipCardController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            flipCardStatus = status;
          });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..setEntry(1, 1, 1 + flipCardAnimation.value)
        ..rotateX(math.pi * flipCardAnimation.value),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
//            y = y - details.delta.dx / 100;
//            x = x - details.delta.dy / 100;
          });
        },
        onTap: () {
          setState(() {
            if (flipCardStatus == AnimationStatus.dismissed) {
              flipCardController.forward();
            } else {
              flipCardController.reverse();
            }
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 0.0),
          margin: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
//            borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(20),
//              bottomLeft: Radius.circular(20),
//            ),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              Material(
                color: Theme.of(context).primaryColor,
                child: IconButton(
                    icon: Icon(Icons.chevron_left),
                    iconSize: 60,
                    onPressed: () {
                      setState(() {
                        count++;
                      });
                    },
                    color: Theme.of(context).accentColor),
              ),
              Text(count.toString(), style: kLabel.copyWith(fontSize: 40)),
              Expanded(
                child: Text(''),
              ),
              Text(widget.title, style: kLabel),
            ],
          ),
        ),
      ),
    );
  }
}
