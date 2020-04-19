import 'package:flutter/cupertino.dart';
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
          color: Theme.of(context).accentColor,
          child: Row(
            children: <Widget>[
              Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        cardState.selectTile = null;
                        cardState.closeHomeRightBar();
                        cardState.tappedEmptyAreaUnderListView = true;
//                        cardState.tappedEmptyAreaUnderListView = !cardState.tappedEmptyAreaUnderListView;
                        print('tapped everywhere');
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
                      child: ListView(
                        // todo add person's name above this
                        physics: BouncingScrollPhysics(),
                        children: cardTileList,
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
      cardState.clearTitleTextEditingControllerSwitch();
    }
    var minutesList = List.generate(
        13,
        (index) => DropdownMenuItem(
            child: Text(
                index == 0 || index == 1 ? '0${index * 5}' : '${index * 5}',
                style: TextStyle(fontSize: 30, color: yellow)),
            value: '${index * 5}'));
    var secondsList = List.generate(
        12,
        (index) => DropdownMenuItem(
            child: Text(
                index == 0 || index == 1 ? '0${index * 5}' : '${index * 5}',
                style: TextStyle(fontSize: 30, color: yellow)),
            value: '${index * 5}'));
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.72,
        color: red1,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//              Text('Title', style: TextStyle(color: yellow, fontSize: 100)), // todo adding would be cool
              TextField(
                enabled: cardState.addNewScreen,
                controller: titleTextController,
                autofocus: false,
                style: TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: yellow),
                  hintText: 'Title',
                  fillColor: blue,
                ),
                onChanged: (value) {
                  setState(() {
                    cardState.newTitle = value;
                  });
                },
              ),
              TextField(
                enabled: cardState.addNewScreen,
                autofocus: false,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                style: TextStyle(
                    color: white, fontSize: 30, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: yellow),
                  hintText: 'Goal',
                  fillColor: blue,
                ),
                onChanged: (value) {
                  setState(() {
                    cardState.newGoal = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Duration',
                      style: TextStyle(
                          color: yellow,
                          fontSize: 30,
                          fontWeight: FontWeight.w600)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                          icon: Icon(Icons.arrow_drop_down, size: 0),
                          dropdownColor: red1,
                          onChanged: (inputValue) {
                            setState(() {
                              cardState.newMinutes = inputValue;
                            });
                          },
                          value: cardState.newMinutes.toString(),
                          items: minutesList,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(':',
                              style: TextStyle(
                                  color: yellow,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900)),
                        ),
                        DropdownButton(
                          icon: Icon(Icons.arrow_drop_down, size: 0),
                          dropdownColor: red1,
                          onChanged: (inputValue) {
                            setState(() {
                              cardState.newSeconds = inputValue;
                            });
                          },
                          value: cardState.newSeconds.toString(),
                          items: secondsList,
                        ),
                      ],
                    ),
                  ),
                ],
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
  var closeIconController; // not being used for the moment. might change later
  var closeIconAnimation;
  var rightBarController;
  var rightBarAnimation;
  var rightBarStatus = AnimationStatus.dismissed;
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
    closeIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    closeIconAnimation = CurvedAnimation(
      curve: Curves.bounceInOut,
      parent: closeIconController,
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
                        : (1 - rightBarAnimation.value)))
            // todo maybe limit to if < 2 items
            ),
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
                    offstage: !cardState.devMode,
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
                  GestureDetector(
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
                  Offstage(
                    offstage: cardState.selectedIndex == null,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // todo add confirmation to delete, like a double tap
                          // todo add scale transition
                          sharedPref.remove(cardState
                              .cardModels[cardState.selectedIndex].title);
                          CardModel.cardModelsX
                              .removeAt(cardState.selectedIndex);
                          cardState.selectTile = null;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 80,
                            color: yellow,
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
                    // todo add scale transition/size transition
                    offstage: !cardState.addNewScreen,
                    // todo this can't be seen right now
//                  offstage: false,
                    child: GestureDetector(
                      onTap: () {
                        // todo implement clearing text fields when hit
                        setState(() {
                          addNewIconController.reverse();
                          if (cardState.addNewScreen) {
                            if (closeIconController.isCompleted) {
                              closeIconController.reverse();
                            } else {
                              closeIconController.forward();
                            }
                            cardState.newTitle =
                                ''; // todo create init or something
                            cardState.newGoal = '';
                            cardState.newMinutes = '30';
                            cardState.newSeconds = '10';
                            cardState.addNewScreen = !cardState.addNewScreen;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: math.pi * closeIconAnimation.value,
                            child: Icon(
                              Icons.close,
                              size: 80,
                              color: yellow,
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
                                (1 - addNewIconAnimation.value)),
                        child: GestureDetector(
                          onTap: () async {
                            // todo add some initial goal value if null, or maybe make it a number drop down
                            var keys = await sharedPref.getKeys();
                            setState(() {
                              bool canAddNewScreen = cardState.addNewScreen &&
                                  cardState.newTitle.isNotEmpty &&
                                  !keys.contains(cardState
                                      .newTitle); // todo add animation for duplicate entry
                              if (canAddNewScreen) {
                                addNewIconController.reverse();
                                cardState
                                    .clearTitleTextEditingControllerSwitch();
                                cardState.addToCardModelsList(
                                  CardModel(
                                    title: cardState.newTitle,
                                    score: 0,
                                    goal:
                                        int.tryParse(cardState.newGoal) == null
                                            ? '-2'
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
                                cardState.addNewScreen = true;
                                cardState.closeHomeRightBar();
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
    closeIconController.dispose();
    rightBarController.dispose();
    super.dispose();
  }
}
