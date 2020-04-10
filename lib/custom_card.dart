import 'package:flutter/material.dart';
import 'package:pomodoro_app/second_screen.dart';

import 'constants.dart';
import 'card_state.dart';
import 'card_state.dart';

class CustomCard extends StatefulWidget {
  final int index;
  final String title;
  final int score;
  final int goal;
  final Duration duration;
  CustomCard({
    @required this.index,
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.duration,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

enum Position { None, Left, Right }

class _CustomCardState extends State<CustomCard> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (details.primaryDelta < 0) {
            screenChangeController.forward();
//            widget.otherController.forward();
//          } else {
//            screenChangeController.reverse();
          }
        });
      },
      onTap: () {
        setState(() {
          print('Tapped: ${widget.title}');
//          Navigator.pushNamed(context, SecondScreen.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondScreen(
                  index: widget.index,
                  title: widget.title,
                  score: widget.score,
                  goal: widget.goal,
                  duration: widget.duration,
                ),
              ));
        });
      },
      child: Transform.translate(
        offset: Offset(
            -(screenChangeAnimation.value * screenWidth), 0),
        child: Container(
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
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
              Text(widget.score.toString(),
                  style: kLabel.copyWith(fontSize: 40)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.title.length > 9
                            ? widget.title.substring(0, 9) + '..'
                            : widget.title,
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        style: kLabel,
                      ),
                    ),
                    SizedBox(width: 20.0),
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
