import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../constants.dart';
import '../widgets/card_tile.dart';
import '../card_state.dart';
import '../models/card_model.dart';
import '../shared_pref.dart';

class Home extends StatefulWidget {
  static final id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  SharedPref sharedPref = SharedPref();
  List<CardTile> cardTileList = [];
  bool loadingIndicator = true;
  AnimationController addSectionController;
  Animation addSectionAnimation;

  AnimationController loadingIndicatorController;
  Animation loadingIndicatorAnimation;
  AnimationStatus loadingIndicatorStatus = AnimationStatus.dismissed;
  int loadingIndicatorCount = 0;

  @override
  void initState() {
    super.initState();
    getCardListFromJson();

    addSectionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    addSectionAnimation = CurvedAnimation(
      parent: addSectionController,
      curve: Curves.easeOutBack,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {});
      });

    loadingIndicatorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    loadingIndicatorAnimation = CurvedAnimation(
      parent: loadingIndicatorController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {
          loadingIndicatorStatus = status;
        });
      });
    loadingIndicatorController.forward();
  }

  getCardListFromJson() async {
    List<dynamic> prefCardModelList = await sharedPref.get();
    for (int i = 0; i < prefCardModelList.length; i++) {
      CardModel.cardModelsX.add(CardModel(
        title: prefCardModelList[i]['title'],
        score: prefCardModelList[i]['score'],
        goal: prefCardModelList[i]['goal'],
        minutes: prefCardModelList[i]['minutes'],
        seconds: prefCardModelList[i]['seconds'],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    cardTileList = List.generate(cardState.cardModels.length, (index) {
      return CardTile(cardModel: cardState.cardModels[index]);
    });
    if (loadingIndicator) {
      if (cardTileList.length > 0 && cardTileList[0].cardModel.score < 0) {
        loadingIndicator = false;
      }
    }
    if (cardState.addNewScreen) {
      addSectionController.forward();
    } else {
      addSectionController.reverse();
    }

    if (!loadingIndicatorController.isAnimating && loadingIndicator) {
      if (loadingIndicatorStatus == AnimationStatus.completed) {
        loadingIndicatorController.reverse();
        loadingIndicatorCount++;
        if (loadingIndicatorCount > 10) {
          loadingIndicator = false;
        }
      } else {
        loadingIndicatorController.forward();
        loadingIndicatorCount++;
      }
    }

    return SafeArea(
      child: Material(
        child: Container(
          color: grey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.72,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
//                          color: Colors.grey[850], // todo pick a good color
                          gradient: LinearGradient(
                            colors: [grey2, grey],
                            stops: [0.7, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: white,
                            fontFamily: 'IndieFlower',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.08,
                      child: GestureDetector(
                        onTap: () {
                          cardState.selectTile = null;
                          cardState.closeHomeRightBar();
                          cardState.tappedEmptyAreaUnderListView = true;
                        },
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            if (details.delta.dx < 0) {
                              cardState.openHomeRightBar();
                            } else {
                              cardState.closeHomeRightBar();
                            }
                          });
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.88,
                          width: MediaQuery.of(context).size.width * 0.72,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: cardTileList,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Transform.scale(
                        scale: loadingIndicator
                            ? 2 * loadingIndicatorAnimation.value
                            : 0,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Transform.translate(
                          offset: Offset(
                              -MediaQuery.of(context).size.width *
                                  (1 - addSectionAnimation.value) *
                                  0.69,
                              0),
                          child: AddNewCardSection()),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.03,
                decoration: BoxDecoration(
                  color: yellow,
                  border: Border.all(width: 0, color: yellow),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 0),
                child: HomeRightBar(
                  cardTileList: cardTileList,
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
    addSectionController.dispose();
    loadingIndicatorController.dispose();
    super.dispose();
  }
}

class AddNewCardSection extends StatefulWidget {
  @override
  _AddNewCardSectionState createState() => _AddNewCardSectionState();
}

class _AddNewCardSectionState extends State<AddNewCardSection> {
  TextEditingController titleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cardState = Provider.of<CardState>(context);
    if (cardState.isClearTitleTextEditingController) {
      titleTextController.clear();
//      cardState.clearTitleTextEditingControllerSwitch();
    }
    var sectionWidth = MediaQuery.of(context).size.width * 0.72;
    var sectionHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        height: sectionHeight,
        width: sectionWidth,
        color: red1,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: sectionHeight * 0.2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Name', style: kAddNewSectionTextStyle),
                    ),
                  ),
                  TextField( // todo implement clear on hit
                    enabled: cardState.addNewScreen,
                    controller: titleTextController,
                    autofocus: false,
                    style: TextStyle(
                      color: white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: yellow),
                    focusColor: blue,
                    ),
                    onChanged: (value) {
                      setState(() {
                        cardState.newTitle = value;
                      });
                    },
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: sectionHeight * 0.6,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 20),child: Text('Duration (min)', style: kAddNewSectionTextStyle)),
                      SliderTheme(
                        data: kSliderThemeData,
                        child: Slider(
                          value: double.tryParse(cardState.newMinutes),
                          onChanged: (value) {
                            if (value != null)
                              cardState.newMinutes = value.round().toInt().toString();
                          },
                          divisions: 59,
                          label: cardState.newMinutes,
                          max: 60,
                          min: 1,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 20),child: Text('Goal', style: kAddNewSectionTextStyle)),
                      SliderTheme(
                        data: kSliderThemeData,
                        child: Slider(
                          value: double.tryParse(cardState.newGoal),
                          onChanged: (value) {
                            if (value != null)
                              cardState.newGoal = value.round().toInt().toString();
                          },
                          divisions: 29,
                          label: cardState.newGoal,
                          max: 30,
                          min: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class HomeRightBar extends StatefulWidget {
  final List<CardTile> cardTileList;

  HomeRightBar({@required this.cardTileList});

  @override
  _HomeRightBarState createState() => _HomeRightBarState();
}

class _HomeRightBarState extends State<HomeRightBar>
    with TickerProviderStateMixin {
  var addNewIconController;
  var addNewIconAnimation;
  var cancelIconController; // not being used for the moment. might change later
  var cancelIconAnimation;
  var rightBarController;
  var rightBarAnimation;
  var rightBarStatus = AnimationStatus.dismissed;
  var deleteIconScaleController;
  var deleteIconScaleAnimation;
  var cancelIconScaleController;
  var cancelIconScaleAnimation;
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    addNewIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    addNewIconAnimation = CurvedAnimation(
      curve: Curves.elasticInOut,
      parent: addNewIconController,
    )..addListener(() {
        setState(() {});
      });
    cancelIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    cancelIconAnimation = CurvedAnimation(
      curve: Curves.bounceInOut,
      parent: cancelIconController,
    )..addListener(() {
        setState(() {});
      });
    rightBarController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    rightBarAnimation =
        CurvedAnimation(parent: rightBarController, curve: Curves.elasticInOut)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            setState(() {
              rightBarStatus = status;
            });
          });
    deleteIconScaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    deleteIconScaleAnimation = CurvedAnimation(
        parent: deleteIconScaleController, curve: Curves.bounceIn);
    cancelIconScaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    cancelIconScaleAnimation = CurvedAnimation(
        parent: cancelIconScaleController, curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    if (cardState.tappedEmptyAreaUnderListView &&
        rightBarStatus == AnimationStatus.dismissed) {
      rightBarController.forward(from: 0.0);
    } else if (rightBarStatus == AnimationStatus.completed) {
      rightBarStatus = AnimationStatus.dismissed;
      cardState.tappedEmptyAreaUnderListView = false;
    }
    if (cardState.selectedIndex != null) {
      deleteIconScaleController.forward();
    } else {
      deleteIconScaleController.reverse();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (cardState.homeRightBarOpen) {
            cardState.closeHomeRightBar();
          } else {
            cardState.openHomeRightBar();
          }
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (details.delta.dx < 0) {
            cardState.openHomeRightBar();
          } else {
            cardState.closeHomeRightBar();
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        color: red1,
        width: MediaQuery.of(context).size.width *
            (cardState.homeRightBarOpen
                ? 0.55
                : (0.25 +
                    (rightBarAnimation.value < 0.5
                        ? rightBarAnimation.value
                        : (1 - rightBarAnimation.value)))),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Offstage(
                offstage: cardState.selectedIndex == null,
                child: Column(
                  children: [
                    Text(
                      // todo: need to update this when we get back from SecondScreen
                      cardState.firstPageScore == null
                          ? 'x'
                          : cardState.firstPageScore.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Container(height: 10, width: 80, color: yellow),
                    Text(
                      cardState.firstPageGoal == null
                          ? 'y'
                          : cardState.firstPageGoal.toString(),
                      style: TextStyle(
                        color: yellow,
                        fontSize: 50,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Offstage(
                    offstage: kReleaseMode,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print(
                              'cardModelsX: ${CardModel.cardModelsX.toString()}');
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.grain,
                            size: 80,
                            color: yellow,
                          ),
                          Offstage(
                            offstage: !cardState.homeRightBarOpen,
                            child: Text(
                              'Lol',
                              style: TextStyle(
                                color: yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: kReleaseMode,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          sharedPref.removeAll();
                          cardState.clearCardModelsList();
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.do_not_disturb_on,
                            size: 80,
                            color: yellow,
                          ),
                          Offstage(
                            offstage: !cardState.homeRightBarOpen,
                            child: Text(
                              'Delete All',
                              style: TextStyle(
                                color: yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: cardState.selectedIndex == null,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (cardState.confirmDeleteIndex ==
                              cardState.selectedIndex) {
                            // second tap
                            sharedPref.remove(cardState
                                .cardModels[cardState.selectedIndex].title);
                            CardModel.cardModelsX
                                .removeAt(cardState.selectedIndex);
                            cardState.selectTile = null;
                          } else {
                            // first tap for confirmation
                            cardState.confirmDeleteIndex =
                                cardState.selectedIndex;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          ScaleTransition(
                            scale: deleteIconScaleAnimation,
                            child: Icon(
                              Icons.delete,
                              size: 80,
                              color: cardState.selectedIndex ==
                                      cardState.confirmDeleteIndex
                                  ? blue
                                  : yellow,
                            ),
                          ),
                          Offstage(
                            offstage: !cardState.homeRightBarOpen,
                            child: Text(
                              'Delete Item',
                              style: TextStyle(
                                color: yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !cardState.addNewScreen,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          addNewIconController.reverse();
                          cancelIconScaleController.reverse();
                          if (cardState.addNewScreen) {
                            if (cancelIconController.isCompleted) {
                              cancelIconController.reverse();
                            } else {
                              cancelIconController.forward();
                            }
//                            cardState.newTitle = '';
//                            cardState.newGoal = '10';
//                            cardState.newMinutes = '30';
//                            cardState.newSeconds = '10';
                            cardState.resetAddNewScreenVariables();
                            cardState.addNewScreen = !cardState.addNewScreen;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: math.pi * cancelIconAnimation.value,
                            child: ScaleTransition(
                              scale: cancelIconScaleAnimation,
                              child: Icon(
                                Icons.cancel,
                                size: 80,
                                color: yellow,
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: !cardState.homeRightBarOpen,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
//                    overflow: Overflow.visible,
                    children: [
                      Transform.translate(
                        offset: Offset(
                          0,
                          MediaQuery.of(context).size.height *
                              0.2 *
                              (1 - addNewIconAnimation.value),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            // todo maybe make it a number drop down
                            var keys = await sharedPref
                                .getKeys(); // todo maybe i can perform this with cardList instead
                            setState(() {
                              bool canAddNewScreen = cardState.addNewScreen &&
                                  cardState.newTitle.isNotEmpty &&
                                  !keys.contains(cardState
                                      .newTitle); // todo add animation for duplicate entry
                              if (canAddNewScreen) {
                                addNewIconController.reverse();
                                cancelIconScaleController.reverse();
//                                cardState.clearTitleTextEditingControllerSwitch();
                                cardState.addToCardModelsList(
                                  CardModel(
                                    title: cardState.newTitle,
                                    score: 0,
                                    goal:
                                        int.tryParse(cardState.newGoal) == null
                                            ? '777'
                                            : int.tryParse(cardState.newGoal),
                                    minutes: int.parse(cardState.newMinutes),
                                    seconds: int.parse(cardState.newSeconds),
                                  ),
                                );
                                widget.cardTileList.add(CardTile(
                                    cardModel:
                                        cardState.at(cardState.length - 1)));
                                cardState.addNewScreen =
                                    !cardState.addNewScreen;
                                sharedPref.save(
                                    cardState.newTitle,
                                    cardState
                                        .at(cardState.length - 1)
                                        .toJson());
                                cardState.resetAddNewScreenVariables();
                              } else {
                                // todo add animation for incorrect entry and maybe explain why
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                size: 80,
                                color: yellow,
                              ),
                              Offstage(
                                offstage: !cardState.homeRightBarOpen,
                                child: Text(
                                  'Confirm Item',
                                  style: TextStyle(
                                    color: yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            0,
                            MediaQuery.of(context).size.height *
                                0.2 *
                                addNewIconAnimation.value),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!cardState.addNewScreen) {
                                cancelIconScaleController.forward();
                                cardState.addNewScreen = true;
                                cardState.closeHomeRightBar();
                                cardState.selectTile = null;
                                addNewIconController.forward();
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_box,
                                size: 80,
                                color: yellow,
                              ),
                              Offstage(
                                offstage: !cardState.homeRightBarOpen,
                                child: Text(
                                  'Add Item',
                                  style: TextStyle(
                                    color: yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addNewIconController.dispose();
    cancelIconController.dispose();
    rightBarController.dispose();
    cancelIconScaleController.dispose();
    deleteIconScaleController.dispose();
    super.dispose();
  }
}
