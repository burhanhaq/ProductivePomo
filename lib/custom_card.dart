import 'package:flutter/material.dart';
import 'package:pomodoro_app/second_screen.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'card_state.dart';
import 'models/card_model.dart';

class CustomCard extends StatefulWidget {
  CardModel cardModel;

  CustomCard({@required this.cardModel});

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
    final int index = widget.cardModel.index;
    final String title = widget.cardModel.title;
//    final int score = widget.cardModel.score;
//    final int goal = widget.cardModel.goal;
//    final Duration duration = widget.cardModel.duration;
//    final bool selected = widget.cardModel.selected;
    double screenWidth = MediaQuery.of(context).size.width;
    final cardState = Provider.of<CardState>(context);
    bool isCardSelected = cardState.at(index).selected;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (details.primaryDelta < 0) {
            screenChangeController.forward();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondScreen(customCard: widget),
              ),
            );
          } else {
            screenChangeController.reverse();
          }
        });
      },
      onTap: () {
        setState(() {
          print('Tapped: $title');
          cardState.currentIndex = index;
        });
      },
      child: Transform.translate(
        offset: Offset(-(screenChangeAnimation.value * screenWidth * 0.5), 0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
          curve: Curves.fastOutSlowIn,
          width: double.infinity,
          height: isCardSelected ? 200 : 100,
          decoration: BoxDecoration(
            color: isCardSelected ? red1 : yellow,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: isCardSelected
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.chevron_left,
                    size: 60,
                    color: isCardSelected ? white : grey,
                  ),
                  Text(
                    cardState.at(index).score.toString(),
                    style: isCardSelected ? kScore.copyWith(color: white) : kScore,
                  ),
                  Expanded(
                    child: Text(
                      cardState.at(index).title.length > 12
                          ? title.substring(0, 12) + '..'
                          : title,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: isCardSelected
                          ? kLabel.copyWith(color: white)
                          : kLabel,
                    ),
                  ),
                  SizedBox(width: 20.0),
                ],
              ),
              Offstage(
                child: Text('brhn.dev', style: kLabel.copyWith(color: white)),
                offstage: !isCardSelected,
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
