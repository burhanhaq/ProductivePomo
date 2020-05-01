import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
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
//  SharedPref sharedPref = SharedPref();
  var timerDurationController;
  var playPauseIconController;
  var playPauseIconAnimation;
  var verticalBarsController;
  var verticalBarsAnimation;
  var horizontalBarsController;
  var horizontalBarsAnimation;
  var backgroundOpacityController;
  var backgroundOpacityAnimation;
  var timerScaleController;
  var timerScaleAnimation;

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
      print(Exception.toString());
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

    verticalBarsController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    verticalBarsAnimation = CurvedAnimation(
        parent: verticalBarsController, curve: Curves.easeInExpo);
    horizontalBarsController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    horizontalBarsAnimation = CurvedAnimation(
        parent: horizontalBarsController, curve: Curves.bounceOut);
    backgroundOpacityController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    backgroundOpacityAnimation = CurvedAnimation(
        parent: backgroundOpacityController, curve: Curves.linear);
    timerScaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    timerScaleAnimation =
        CurvedAnimation(parent: timerScaleController, curve: Curves.bounceOut);
  }

  double spacingBetweenContainers = 5.0;

  @override
  Widget build(BuildContext context) {
    verticalBarsController.forward();
    horizontalBarsController.forward();
    backgroundOpacityController.forward();

    loadSharedPrefs();
    bool timerRunning = timerDurationController.isAnimating;
    var safeAreaPadding = MediaQuery.of(context).padding.top;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: trans,
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => CardState(),
          child: Consumer<CardState>(
            builder: (context, cardState, _) => Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity: backgroundOpacityAnimation.value,
                  child: Container(color: grey),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(
                        0,
                        -(height * 0.5 + safeAreaPadding) *
                            (1 - verticalBarsAnimation.value)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: height * (timerRunning ? 0.2 : 0.5) -
                              spacingBetweenContainers,
                          width: width * 0.2,
                          color: timerRunning ? darkYellow : yellow,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Opacity(
                            opacity: 0.8,
                            child: AnimatedContainer(
                              constraints: BoxConstraints(
                                maxHeight: height * 0.5,
                              ),
                              duration: Duration(milliseconds: 500),
                              height: height *
                                  (timerRunning ? 0.2 : 0.5) *
                                  widget.cardTile.cardModel.score.toDouble() /
                                  widget.cardTile.cardModel.goal.toDouble(),
                              width: width * 0.2,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Opacity(
                            opacity: 0.8,
                            child: AnimatedContainer(
                              constraints: BoxConstraints(
                                maxHeight: height * (timerRunning ? 0.2 : 0.5),
                              ),
                              duration: Duration(milliseconds: 500),
                              height: height *
                                  (timerRunning ? 0.2 : 0.5) *
                                  (widget.cardTile.cardModel.score.toDouble() -
                                      widget.cardTile.cardModel.goal
                                          .toDouble()) /
                                  widget.cardTile.cardModel.goal.toDouble(),
                              width: width * 0.2,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: AnimatedBorder(
                                child: Text(
                                  prefScore == null
                                      ? '-3'
                                      : prefScore.toString(),
                                  style: TextStyle(
                                    color: timerRunning
                                        ? Colors.white
                                        : Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 5,
                              width: 65,
                              color: timerRunning ? Colors.white : Colors.black,
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                prefGoal == null ? '-3' : prefGoal.toString(),
                                style: TextStyle(
                                  color: timerRunning
                                      ? Colors.white
                                      : Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(
                        width * 0.8 * (1 - horizontalBarsAnimation.value), 0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      color: timerRunning ? darkRed : red12,
                      width: width * (timerRunning ? 0.7 : 0.8) -
                          spacingBetweenContainers,
                      height: height * 0.2,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: AnimatedBorder(
                          child: Text(
                            'Alex',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IndieFlower',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(
                        -width * 0.8 * (1 - horizontalBarsAnimation.value), 0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: height * 0.5 - safeAreaPadding,
                      width: width * (timerRunning ? 0.7 : 0.8) -
                          spacingBetweenContainers,
                      color: timerRunning ? darkRed : red1,
                      child: Center(
                        child: Text(
                          prefTitle == null ? 'null' : prefTitle.toUpperCase(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 20,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Transform.translate(
                    offset: Offset(
                        0, height * 0.8 * (1 - verticalBarsAnimation.value)),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      color: timerRunning ? darkYellow : yellow,
                      width: width * 0.2,
                      height: height * (timerRunning ? 0.5 : 0.8) -
                          safeAreaPadding -
                          spacingBetweenContainers,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  cardState.subtractScore(widget.cardTile.cardModel);
                                  sharedPref.save(
                                      widget.cardTile.cardModel.title,
                                      widget.cardTile.cardModel.toJson());
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 40,
                                  color: grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cardState.addScore(widget.cardTile.cardModel);
                                  sharedPref.save(
                                      widget.cardTile.cardModel.title,
                                      widget.cardTile.cardModel.toJson());
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: grey,
                                ),
                              ),
                            ],
                          ),
                          Material(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                color: timerRunning ? white : yellow,
                                border: Border.all(
                                  width: 0,
                                  color: timerRunning ? darkYellow : yellow,
                                ),
                              ),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.replay),
                                    iconSize: 60,
                                    color: timerRunning ? red1 : grey,
                                    onPressed: () {
                                      timerDurationController.value = 0.0;
                                      playPauseIconController.reverse();
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (playPauseIconController.status ==
                                          AnimationStatus.dismissed) {
                                        // play pressed
                                        timerDurationController.forward();
                                        timerScaleController.forward();
                                        playPauseIconController.forward();
                                      } else {
                                        // pause pressed
                                        timerDurationController.stop();
                                        timerScaleController
                                            .reverse(); // todo doesn't do reverse curve
                                        playPauseIconController.reverse();
                                      }
                                    },
                                    child: AnimatedIcon(
                                      icon: AnimatedIcons.play_pause,
                                      progress: playPauseIconAnimation,
                                      size: 60,
                                      color: timerRunning ? red1 : grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          GestureDetector(
                            onTap: () {
                                cardState.settingsActive = !cardState.settingsActive;
                            },
                            child: Icon(
                              Icons.settings,
                              size: 40,
                              color: cardState.settingsActive ? blue : grey,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.235,
                  child: Transform.scale(
                    scale: 0.5 +
                        (timerScaleAnimation.value) *
                            (timerRunning ? 0.5 : 0.0),
                    child: AnimatedBorder(
                      child: BoxesDigitalClock(
                        min: widget.cardTile.cardModel.minutes,
                        sec: widget.cardTile.cardModel.seconds,
                        timerController: timerDurationController,
                      ),
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
    timerDurationController.dispose();
    playPauseIconController.dispose();
    verticalBarsController.dispose();
    horizontalBarsController.dispose();
    backgroundOpacityController.dispose();
    timerScaleController.dispose();
    super.dispose();
  }
}

class AnimatedBorder extends StatefulWidget {
  final Widget child;
  AnimatedBorder({this.child});
  @override
  _AnimatedBorderState createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder> {
  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 170),
      decoration: BoxDecoration(
        border: Border.all(color: cardState.settingsActive ? blue : trans, width: 3),
      ),
      child: widget.child,
    );
  }
}
