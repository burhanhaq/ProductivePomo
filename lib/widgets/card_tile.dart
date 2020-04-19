import 'dart:io';

import 'package:flutter/material.dart';
import '../screens/second_screen.dart';
import 'package:pomodoro_app/shared_pref.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../card_state.dart';
import '../models/card_model.dart';
import '../screen_navigation/second_screen_navigation.dart';

class CardTile extends StatefulWidget {
  final CardModel cardModel;

  CardTile({@required this.cardModel});

  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile>
    with SingleTickerProviderStateMixin {
  AnimationController cardScreenController;
  Animation cardScreenAnimation;

  SharedPref sharedPref = SharedPref();
  int prefScore;

  @override
  void initState() {
    super.initState();
    cardScreenController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    cardScreenAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(cardScreenController)
          ..addListener(() {
            setState(() {});
          });
  }

  loadSharedPrefs() async {
    if (mounted) {
      try {
        CardModel model =
            CardModel.fromJson(await sharedPref.read(widget.cardModel.title));
        setState(() {
          prefScore = model.score;
        });
      } catch (Exception) {
        print('Exception in CardTile. Possible Leak!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    final String title = widget.cardModel.title;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isCardSelected = widget.cardModel.selected;
    loadSharedPrefs();
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta < 0) {
          cardState.selectTile = widget.cardModel;
          cardState.closeHomeRightBar();
          cardScreenController.forward(from: 0.0);
          Navigator.push(
            context,
            SecondScreenNavigation(
              widget: SecondScreen(cardTile: widget),
            ),
          );
        }
      },
      onTap: () {
        cardState.closeHomeRightBar();
        if (widget.cardModel.selected) {
          // tapped second time
          Navigator.push(
            context,
            SecondScreenNavigation(
              widget: SecondScreen(cardTile: widget),
            ),
          );
        }
        cardState.selectTile = widget.cardModel;
      },
      child: Transform.translate(
        offset: Offset(
            cardScreenAnimation.value < 0.5
                ? -(cardScreenAnimation.value * screenWidth * 0.5)
                : ((1 - cardScreenAnimation.value) * screenWidth * 0.5),
            0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.fromLTRB( // todo set values
              screenWidth * 0.07, 20.0, screenWidth * 0.04, 0.0),
          curve: Curves.fastOutSlowIn,
          width: double.infinity,
          height: isCardSelected ? 200 : 100,
          decoration: BoxDecoration(
            color: isCardSelected ? red1 : yellow,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(3),
              topLeft: Radius.circular(3),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, right: 10),
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
                      style: isCardSelected
                          ? kScore.copyWith(color: white)
                          : kScore,
                    ),
                    Expanded(
                      child: Text(
                        widget.cardModel.title.length > 12
                            ? title.substring(0, 12) + '..'
                            : title,
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        style: isCardSelected
                            ? kLabel.copyWith(color: white)
                            : kLabel,
                      ),
                    ),
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
    sharedPref = null;
    super.dispose();
  }
}
