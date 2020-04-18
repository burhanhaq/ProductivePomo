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
  SharedPref sharedPref = SharedPref();
  var timerController;

  var playPauseIconController;
  var playPauseIconAnimation;

  var verticalBarsController;
  var verticalBarsAnimation;
  var horizontalBarsController;
  var horizontalBarsAnimation;
  var backgroundOpacityController;
  var backgroundOpacityAnimation;

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
    timerController = AnimationController(
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
    verticalBarsAnimation =
        CurvedAnimation(parent: verticalBarsController, curve: Curves.easeInExpo);
    horizontalBarsController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    horizontalBarsAnimation =
        CurvedAnimation(parent: horizontalBarsController, curve: Curves.bounceOut);
    backgroundOpacityController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    backgroundOpacityAnimation =
        CurvedAnimation(parent: backgroundOpacityController, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    verticalBarsController.forward();
    horizontalBarsController.forward();
    backgroundOpacityController.forward();

    loadSharedPrefs();
    int index = widget.cardTile.cardModel.index;
    bool timerRunning = timerController.isAnimating;
    var safeAreaPadding = MediaQuery.of(context).padding.top;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(color: trans,
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => CardState(),
          child: Consumer<CardState>(
            builder: (context, cardState, _) => Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity: backgroundOpacityAnimation.value,
                    child: Container(color: grey),),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(
                        0,
                        -(height * 0.5 + safeAreaPadding) *
                            (1 - verticalBarsAnimation.value)),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: height * (timerRunning ? 0.2 : 0.5),
                          width: width * 0.2,
                          color: timerRunning
                              ? Color(0xff6A5920)
                              : Color(0xffF7CE47),
                          child: Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  prefScore == null
                                      ? '-3'
                                      : prefScore.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Container(height: 5, width: 65, color: white),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  prefGoal == null ? '-3' : prefGoal.toString(),
                                  style: TextStyle(
                                    color: white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: height *
                                (timerRunning ? 0.2 : 0.5) *
                                widget.cardTile.cardModel.score.toDouble() /
                                widget.cardTile.cardModel.goal.toDouble(),
                            width: width * 0.2,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset:
                        Offset(width * 0.8 * (1 - horizontalBarsAnimation.value), 0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      color: timerRunning ? Color(0xff6E2929) : red1,
                      width: width * (timerRunning ? 0.7 : 0.8),
                      height: height * 0.2,
                      child: FittedBox(
                        fit: BoxFit.contain,
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(-width * 0.8 * (1-horizontalBarsAnimation.value), 0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: height * 0.5 - safeAreaPadding,
                      width: width * (timerRunning ? 0.7 : 0.8),
                      color: timerRunning ? Color(0xff6E2929) : red1,
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
                    offset: Offset(0, height * 0.8 * (1-verticalBarsAnimation.value)),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      color: timerRunning ? Color(0xff6A5920) : Color(0xffF7CE47),
                      width: width * 0.2,
                      height: height * (timerRunning ? 0.5 : 0.8) - safeAreaPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  cardState.subtract(index);
                                  sharedPref.save(widget.cardTile.cardModel.title,
                                      cardState.at(index).toJson());
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 40,
                                  color: grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cardState.add(index);
                                  sharedPref.save(widget.cardTile.cardModel.title,
                                      cardState.at(index).toJson());
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
                                color: timerRunning
                                    ? Color(0xff6A5920)
                                    : Color(0xffF7CE47),
                                border: Border.all(
                                  width: 0,
                                  color: timerRunning
                                      ? Color(0xff6A5920)
                                      : Color(0xffF7CE47),
                                ),
                              ),
                              child: Column(
                                children: [
                                  IconButton(
                                    // todo: program it to be disabled if at 0 I guess
                                    icon: Icon(Icons.replay),
                                    iconSize: 60,
                                    color: timerRunning ? red2 : grey,
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
                                      color: timerRunning ? red2 : grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          Icon(
                            Icons.settings,
                            size: 40,
                            color: grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.222,
                  child: Transform.scale(
                    scale: timerRunning ? 1 : 0.5,
                    child: BoxesDigitalClock(
                      // todo show it increase when page opens
                      min: widget.cardTile.cardModel.minutes,
                      sec: widget.cardTile.cardModel.seconds,
                      timerController: timerController,
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
