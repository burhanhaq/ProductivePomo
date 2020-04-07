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
    return Transform.translate(
      offset: Offset(30, 0),
      child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
//          border: Border.all(
//            color: Colors.black,
//            width: 1.0,
//          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.chevron_left,
                size: 60, color: Theme.of(context).accentColor),
            Text(count.toString(), style: kLabel.copyWith(fontSize: 40)),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.title.length > 9
                          ? widget.title.substring(0, 9) + '..'
                          : widget.title,
                      maxLines: 2,
                      style: kLabel,
                    ),
                  ),
                  SizedBox(width: 50.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
