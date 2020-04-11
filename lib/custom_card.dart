import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_app/second_screen.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'card_state.dart';

class CustomCard extends StatefulWidget {
  final int index;
  final String title;
  final int score;
  final int goal;
  final Duration duration;
  final bool selected;

  CustomCard({
    @required this.index,
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.duration,
    @required this.selected,
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
    final cardState = Provider.of<CardState>(context);
    bool selected = cardState.at(widget.index).selected;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (details.primaryDelta < 0) {
            screenChangeController.forward();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondScreen(
                  index: widget.index,
                  title: widget.title,
                  score: widget.score,
                  goal: widget.goal,
                  duration: widget.duration,
                  selected: widget.selected,
                ),
              ),
            );
          } else {
            screenChangeController.reverse();
          }
        });
      },
      onTap: () {
        setState(() {
          print('Tapped: ${widget.title}');
          cardState.currentIndex = widget.index;
        });
      },
      child: Transform.translate(
        offset: Offset(-(screenChangeAnimation.value * screenWidth * 0.5), 0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
          curve: Curves.fastOutSlowIn,
          width: double.infinity,
          height: selected ? 200 : 100,
          decoration: BoxDecoration(
            color: selected ? red1 : yellow,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: selected
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.chevron_left,
                    size: 60,
                    color: selected ? white : grey,
                  ),
                  Text(
                    cardState.at(widget.index).score.toString(),
                    style: selected ? kScore.copyWith(color: white) : kScore,
                  ),
                  Expanded(
                    child: Text(
                      cardState.at(widget.index).text.length > 12
                          ? widget.title.substring(0, 12) + '..'
                          : widget.title,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: selected
                          ? kLabel.copyWith(color: white)
                          : kLabel,
                    ),
                  ),
                  SizedBox(width: 20.0),
                ],
              ),
              Offstage(
                child: Text('brhn.dev', style: kLabel.copyWith(color: white)),
                offstage: !selected,
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
