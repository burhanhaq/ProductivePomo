import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pomodoro_app/second_screen.dart';
import 'package:pomodoro_app/shared_pref.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../card_state.dart';
import '../models/card_model.dart';

class CardTile extends StatefulWidget {
  CardModel cardModel;

  CardTile({@required this.cardModel});
  @override
  _CardTileState createState() => _CardTileState();
}

enum Position { None, Left, Right }

class _CardTileState extends State<CardTile> with SingleTickerProviderStateMixin {
  AnimationController screenChangeController;
  Animation screenChangeAnimation;
  SharedPref sharedPref = SharedPref();
//  CardModel prefCardData;
  int prefScore;

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

//    loadSharedPrefs();

//    Future<dynamic> data = loadSharedPrefs('card');
  }

  loadSharedPrefs() async {
    if (mounted) {
      try {
        CardModel model = CardModel.fromJson(await sharedPref.read(widget.cardModel.title));
        setState(() {
//          prefCardData = model;
          prefScore = model.score;
        });
      } catch (Exception) {
        // do something
        print('Exception in CardTile. Possible Leak!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int index = widget.cardModel.index;
    final String title = widget.cardModel.title;
    double screenWidth = MediaQuery.of(context).size.width;
    final cardState = Provider.of<CardState>(context);
    bool isCardSelected = cardState.at(index).selected;
    loadSharedPrefs();
//    sleep(Duration(seconds: 2));
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
//        setState(() {
          if (details.primaryDelta < 0) {
            screenChangeController.forward();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondScreen(cardTile: widget),
              ),
            );
          } else {
            screenChangeController.reverse();
          }
//        });
      },
      onTap: () {
//        setState(() {
          print('Tapped: $title');
          cardState.currentIndex = index;
//        });
      },
      child: Transform.translate( // todo: make this translate back when back from second screen
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
          child: Padding(
            padding: EdgeInsets.only(bottom: 5),
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
                      prefScore == null ? '-7' : prefScore.toString(),
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
      ),
    );
  }

  @override
  void dispose() {
    screenChangeController.dispose();
    sharedPref = null;
    super.dispose();
  }
}
