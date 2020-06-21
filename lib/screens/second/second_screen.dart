import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers/audio_cache.dart';

import '../../constants.dart';
import '../../card_state.dart';
import '../../models/card_model.dart';
import '../../widgets/boxes_digital_clock.dart';

class SecondScreen extends StatefulWidget {
  static final id = 'SecondScreen';
  final CardModel cardModel;

  SecondScreen({@required this.cardModel});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
  var timerDurationController;
  var timerDurationStatus;
  var playPauseIconController;
  var playPauseIconAnimation;
  var replayIconRotationController;
  var replayIconRotationAnimation;

  @override
  void initState() {
    super.initState();
    timerDurationController = AnimationController(
      vsync: this,
      duration: Duration(
        minutes: widget.cardModel.minutes,
      ),
    )..addListener(() {
        setState(() {});
      });

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
  static AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    String cardTitle = widget.cardModel.title;
    int cardScore = widget.cardModel.score;
    int cardGoal = widget.cardModel.goal;
    bool timerRunning = timerDurationController.isAnimating;
    if (timerDurationController.status == AnimationStatus.completed) {
        player.play(kCombinedSound2);
    }
    Wakelock.toggle(on: timerRunning); // todo check if this works
    return SafeArea(
      child: Container(
        color: grey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            var width = constraints.maxWidth;
            var height = constraints.maxHeight;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: height * 0.2,
                  width: width,
                  decoration: BoxDecoration(
                    color: red1,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(kMainRadius),
                      bottomRight: Radius.circular(kMainRadius),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      cardTitle == null ? 'null' : cardTitle.toUpperCase(),
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
                BoxesDigitalClock(
                  min: widget.cardModel.minutes,
                  timerController: timerDurationController,
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Spacer(),
                    Material(
                      color: trans,
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
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
                            GestureDetector(
                              onTap: () => cardState.onTapPlaySecond(
                                  playPauseIconController,
                                  timerDurationController),
                              child: CustomIconButtonStyle(
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: playPauseIconAnimation,
                                  size: 100,
                                  color: timerRunning ? grey : grey,
                                ),
                              ),
                            ),
                            GestureDetector(
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    timerDurationController.dispose();
    replayIconRotationController.dispose();
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
