import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/clock.dart';
import '../card_state.dart';
import '../widgets/card_tile.dart';
import '../shared_pref.dart';
import '../models/card_model.dart';
import '../widgets/boxes_digital_clock.dart';

class SecondScreen extends StatefulWidget {
  static final id = 'SecondScreen';
  final CardTile cardTile;

  SecondScreen({@required this.cardTile});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
  SharedPref sharedPref = SharedPref();
  var timerController;

  var playPauseIconController;
  var playPauseIconAnimation;

  String prefTitle;
  int prefScore;
  int prefGoal;

  loadSharedPrefs() async {
    try {
      CardModel model = CardModel.fromJson(
          await sharedPref.read(widget.cardTile.cardModel.title));
      setState(() {
        prefTitle = model.title;
        prefScore = model.score;
        prefGoal = model.goal;
      });
    } catch (Exception) {
      print('Exception in SecondScreen');
    }
  }

//  setTimerValues() {
//    Duration duration = Duration(
//            minutes: widget.cardTile.cardModel.minutes,
//            seconds: widget.cardTile.cardModel.seconds) *
//        (1 - timerController.value);
//    tensMin = (duration.inMinutes / 10).floor() % 10;
//    onesMin = duration.inMinutes % 10;
//    tensSec = ((duration.inSeconds % 60) / 10).floor() % 10;
//    onesSec = (duration.inSeconds % 60) % 10;
//  }

  @override
  void initState() {
    super.initState();
    timerController = AnimationController(
      vsync: this,
      duration: Duration(
          minutes: widget.cardTile.cardModel.minutes,
          seconds: widget.cardTile.cardModel.seconds),
    );

    playPauseIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    playPauseIconAnimation = CurvedAnimation(
      curve: Curves.bounceIn,
      parent: playPauseIconController,
    );
  }

  @override
  Widget build(BuildContext context) {
//    setTimerValues();
    loadSharedPrefs();
    int index = widget.cardTile.cardModel.index;
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => CardState(),
        child: Consumer<CardState>(
          builder: (context, cardState, _) => Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(color: grey),
                      Container(
                        decoration: BoxDecoration(
                          color: grey,
                          border: Border.all(
                            width: 3,
                            color: yellow,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100),
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      prefTitle == null
                                          ? 'null'
                                          : prefTitle.toUpperCase(),
                                      textAlign: TextAlign.end,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 35,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
//                              Expanded(child: Container()),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    BoxesDigitalClock(
                                        min: widget.cardTile.cardModel.minutes,
                                        sec: widget.cardTile.cardModel.seconds,
                                        controllerValue: timerController.value),
                                  ],
                                ),
                              ),
//                              Container(
//                                width: MediaQuery.of(context).size.width * 0.41,
//                                height:
//                                    MediaQuery.of(context).size.width * 0.41,
//                                decoration: BoxDecoration(
//                                  color: red1,
//                                  shape: BoxShape.circle,
//                                ),
//                                child: Clock(duration: duration),
//                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
//                                  cardState.changeCardScreen();
//                                  cardState.changeCurrentCardScreen();
//                                  print('Going right, change screen bool is: ${cardState.onCurrentCardScreen}');
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 40,
                                    color: yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: grey,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              prefScore == null ? '-3' : prefScore.toString(),
//                                  : cardState.at(index).score.toString(),
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 50,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(height: 5, width: 80, color: white),
                            Text(
                              prefGoal == null ? '-3' : prefGoal.toString(),
//                                  : cardState.at(index).goal.toString(),
                              style: TextStyle(
                                color: white,
                                fontSize: 50,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        Material(
                          child: Container(
                            decoration: BoxDecoration(
                              color: grey,
                              border: Border.all(
                                color: yellow,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  // todo: program it to be disabled if at 0 I guess
                                  icon: Icon(Icons.stop),
                                  iconSize: 60,
                                  color: red1,
                                  onPressed: () {
                                    print('Stop pressed');
                                    timerController.value = 0.0;
                                    playPauseIconController.reverse();
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (playPauseIconController.status ==
                                        AnimationStatus.dismissed) {
                                      print('Play pressed');
                                      timerController.forward();
                                      playPauseIconController.forward();
                                    } else {
                                      print('Pause pressed');
                                      timerController.stop();
                                      playPauseIconController.reverse();
                                    }
                                  },
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: playPauseIconAnimation,
                                    size: 60,
                                    color: red1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
//                SizedBox(height: 30),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  cardState.subtract(index);
                                  sharedPref.save(
                                      widget.cardTile.cardModel.title,
                                      cardState.at(index).toJson());
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 40,
                                  color: yellow,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  cardState.add(index);
                                  sharedPref.save(
                                      widget.cardTile.cardModel.title,
                                      cardState.at(index).toJson());
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
    timerController.dispose();
    super.dispose();
  }
}
