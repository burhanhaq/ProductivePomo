import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../card_state.dart';
import '../widgets/card_tile.dart';
import '../shared_pref.dart';
import '../models/card_model.dart';
import '../widgets/boxes_digital_clock.dart';

class SecondScreen extends StatefulWidget {
//  static final id = 'SecondScreen';
  final CardTile cardTile;

  SecondScreen({@required this.cardTile});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
//  SharedPref sharedPref = SharedPref();
  var timerDurationController;
  var playPauseIconController;
  var playPauseIconAnimation;
  var replayIconRotationController;
  var replayIconRotationAnimation;

  var prefTitle;
  var prefScore;
  var prefGoal;

  loadSharedPrefs() async {
    try {
      CardModel model = CardModel.fromJson(
          await sharedPref.read(widget.cardTile.cardModel.title));
      setState(() {
//        prefTitle = model.title;
//        prefScore = model.score;
//        prefGoal = model.goal;
      });
    } catch (Exception) {
//      print('Exception in SecondScreen');
//      print(Exception.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    timerDurationController = AnimationController(
      vsync: this,
      duration: Duration(
        minutes: widget.cardTile.cardModel.minutes,
        seconds: widget.cardTile.cardModel.seconds,
      ),
    );

    playPauseIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    playPauseIconAnimation = CurvedAnimation(
      curve: Curves.bounceIn,
      parent: playPauseIconController,
    );
    replayIconRotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    replayIconRotationAnimation = CurvedAnimation(
      curve: Curves.easeInBack,
      parent: replayIconRotationController,
    );
  }

  bool added = false;

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();
    setState(() {
      prefTitle = widget.cardTile.cardModel.title;
      prefScore = widget.cardTile.cardModel.score;
      prefGoal = widget.cardTile.cardModel.goal;
    });
    CardState cardState = Provider.of<CardState>(context);
    bool timerRunning = timerDurationController.isAnimating;
//    if (timerDurationController.value == 1.0 && !added) {
//      cardState.addScore(widget.cardTile.cardModel);
//      sharedPref.save(widget.cardTile.cardModel.title,
//          widget.cardTile.cardModel.toJson());
//      added = true;
//    }
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        color: grey2,
        padding: const EdgeInsets.all(7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: height * 0.2,
                  width: width * 0.7,
                  decoration: BoxDecoration(
                    color: red12,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kSecondaryRadius),
                      topRight: Radius.circular(kSecondaryRadius),
                      bottomLeft: Radius.circular(kSecondaryRadius),
                      bottomRight: Radius.circular(kMainRadius),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      prefTitle == null ? 'null' : prefTitle.toUpperCase(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        letterSpacing: 2,
                        color: grey2,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: height * 0.2,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    color: red12,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kSecondaryRadius),
                      topRight: Radius.circular(kSecondaryRadius),
                      bottomLeft: Radius.circular(kMainRadius),
                      bottomRight: Radius.circular(kSecondaryRadius),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          prefScore == null ? '-3' : prefScore.toString(),
                          style: TextStyle(
                            color: grey2,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 65,
                        color: grey2,
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          prefGoal == null ? '-3' : prefGoal.toString(),
                          style: TextStyle(
                            color: grey2,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            BoxesDigitalClock(
              min: widget.cardTile.cardModel.minutes,
              sec: widget.cardTile.cardModel.seconds,
              timerController: timerDurationController,
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Spacer(),
                Material(
                  color: trans,
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: yellow2,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kMainRadius),
                        topRight: Radius.circular(kSecondaryRadius),
                        bottomLeft: Radius.circular(kSecondaryRadius),
                        bottomRight: Radius.circular(kSecondaryRadius),
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => cardState.onTapPlaySecond(
                              playPauseIconController, timerDurationController),
                          child: CustomIconButtonStyle(
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: playPauseIconAnimation,
                              size: 100,
                              color: timerRunning ? grey : grey,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => cardState.onTapReplaySecond(
                              timerDurationController,
                              playPauseIconController,
                              replayIconRotationController),
                          child: CustomIconButtonStyle(
                            child: RotationTransition(
                              turns: replayIconRotationAnimation,
                              child: Icon(
                                Icons.replay,
                                size: 50,
                                color: timerRunning ? grey : grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timerDurationController.dispose();
    playPauseIconController.dispose();
    super.dispose();
  }
}

class CustomIconButtonStyle extends StatelessWidget {
  final Widget child;

  CustomIconButtonStyle({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(5.0),
      alignment: Alignment.center,
      child: child,
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0.4,
            blurRadius: 5.0,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
    );
  }
}
