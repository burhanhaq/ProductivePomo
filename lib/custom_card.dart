import 'package:flutter/material.dart';

import 'constants.dart';
import 'card_state.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final AnimationController otherController;
//
  CustomCard({@required this.title, this.otherController});
//  CustomCard({@required this.title});

  @override
  _CustomCardState createState() => _CustomCardState();
}

enum Position { None, Left, Right }

class _CustomCardState extends State<CustomCard>
    with TickerProviderStateMixin {
  int count = 0;
  AnimationController screenChangeController;
  Animation screenChangeAnimation;
//  AnimationStatus screenChangeStatus = AnimationStatus.completed;

  @override
  void initState() {
    super.initState();
    screenChangeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    screenChangeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(screenChangeController)
          ..addListener(() {
            setState(() {});
          });
//          ..addStatusListener((status) {
//            screenChangeStatus = status;
//          });
  }

  double added = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (details.primaryDelta < 0) {
            screenChangeController.forward();
            widget.otherController.forward();
          } else {
            screenChangeController.reverse();
            widget.otherController.reverse();
          }
        });
      },
      onTap: () {
        setState(() {
          print('Tapped: ${widget.title}');
        });
      },
      child: Transform.translate(
        offset: Offset(kEndSpacing - (screenChangeAnimation.value * screenWidth), 0),
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
      ),
    );
  }

  @override
  void dispose() {
    screenChangeController.dispose();
    super.dispose();
  }
}
