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
  bool progressIndicator = true;
  AnimationController addSectionController;
  Animation addSectionAnimation;

  AnimationController deleteSectionController;
  Animation deleteSectionAnimation;

  AnimationController progressIndicatorController;
  Animation progressIndicatorAnimation;
  AnimationStatus progressIndicatorStatus = AnimationStatus.dismissed;
  int progressIndicatorCount = 0;

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
        setState(() {
        });
      });

    deleteSectionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    deleteSectionAnimation = CurvedAnimation(
      parent: deleteSectionController,
      curve: Curves.easeOutBack,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {
        });
      });

    progressIndicatorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    progressIndicatorAnimation = CurvedAnimation(
      parent: progressIndicatorController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {
          progressIndicatorStatus = status;
        });
      });
    progressIndicatorController.forward();
  }

  getCardListFromJson() async {
    // todo add circular bar for waiting for await
    List<dynamic> prefCardModelList = await sharedPref.get();
    for (int i = 0; i < prefCardModelList.length; i++) {
      CardModel.cardModelsX.add(CardModel(
        index: i,
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
    if (progressIndicator) {
      if (cardTileList.length > 0) {
        progressIndicator = false;
      }
    }
    if (cardState.addNewScreen) {
      addSectionController.forward();
    } else {
      addSectionController.reverse();
    }
    if (cardState.deleteCardScreen) {
      deleteSectionController.forward();
    } else {
      deleteSectionController.reverse();
    }

    if (!progressIndicatorController.isAnimating && progressIndicator) {
      if (progressIndicatorStatus == AnimationStatus.completed) {
        progressIndicatorController.reverse();
        progressIndicatorCount++;
        if (progressIndicatorCount > 10) {
          progressIndicator = false;
        }
      } else {
        progressIndicatorController.forward();
        progressIndicatorCount++;
      }
    }

    return SafeArea(
      child: Material(
        child: Scaffold(
          body: Container(
            color: Theme.of(context).accentColor,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          cardState.currentIndex = null;
                        },
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: cardTileList,
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: Offstage(
                          offstage: false,
//                          offstage: !cardState.progressIndicator,
                          child: Transform.translate(
                            offset: Offset(0,
//                                progressIndicatorAnimation.value < 0.5
//                                    ? 40 * progressIndicatorAnimation.value
//                                    : 40 * (1-progressIndicatorAnimation.value),
                                0),
                            child: Transform.scale(
                              scale: progressIndicator ? 2 * progressIndicatorAnimation.value : 0,
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
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.03,
                        color: yellow,
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
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Transform.translate(
                          offset: Offset(
                              -MediaQuery.of(context).size.width *
                                  (1 - deleteSectionAnimation.value) *
                                  0.69,
                              0),
                          child: DeleteCardSection(),
                        ),
                      ),
                    ],
                  ),
                ),
                HomeRightBar(
                  cardTileList: cardTileList,
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
    addSectionController.dispose();
    deleteSectionController.dispose();
    super.dispose();
  }
}

class DeleteCardSection extends StatefulWidget {
  @override
  _DeleteCardSectionState createState() => _DeleteCardSectionState();
}

class _DeleteCardSectionState extends State<DeleteCardSection> {
  @override
  Widget build(BuildContext context) {
    var cardState = Provider.of<CardState>(context);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.72,
        color: red1,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                enabled: cardState.addNewScreen,
                style: TextStyle(
                    color: white, fontSize: 30, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: yellow),
                  hintText: 'Name to delete',
                  fillColor: blue,
                ),
                onChanged: (value) {
                  setState(() {
                    cardState.deleteTitle = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewCardSection extends StatefulWidget {
  @override
  _AddNewCardSectionState createState() => _AddNewCardSectionState();
}

class _AddNewCardSectionState extends State<AddNewCardSection> {
  @override
  Widget build(BuildContext context) {
    var cardState = Provider.of<CardState>(context);
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
    //FocusScope.of(context).requestFocus(new FocusNode());
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
//              Text('Title', style: TextStyle(color: yellow, fontSize: 100)),
              TextField(
                enabled: cardState.addNewScreen,
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
                        ]),
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
  List<CardTile> cardTileList;

  HomeRightBar({@required this.cardTileList});

  @override
  _HomeRightBarState createState() => _HomeRightBarState();
}

class _HomeRightBarState extends State<HomeRightBar>
    with TickerProviderStateMixin {
  AnimationController addNewIconController;
  Animation addNewIconAnimation;
  AnimationController closeIconController;
  Animation closeIconAnimation;
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
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    return Container(
      color: red1,
      width: MediaQuery.of(context).size.width * 0.25,
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Offstage(
              offstage: cardState.currentIndex == null ? true : false,
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
            Expanded(child: Container()),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print('--------------');
                      print('cardModelsX: ${CardModel.cardModelsX.toString()}');
                      print('--------------');
                    });
                  },
                  child: Icon(
                    Icons.grain,
                    size: 80,
                    color: yellow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      sharedPref.removeAll();
                      cardState.clearCardModelsList();
                      // todo: throws error when pressed because it checks for index for empty list
                    });
                  },
                  child: Icon(
                    Icons.do_not_disturb_on,
                    size: 80,
                    color: yellow,
                  ),
                ),
                Transform.rotate(
                  angle: math.pi * closeIconAnimation.value,
                  child: GestureDetector(
                    onTap: () {
                      // todo implement clearing text fields when hit
                      setState(() {
                        addNewIconController.reverse();
                        if (closeIconController.isCompleted) {
                          closeIconController.reverse();
                        } else {
                          closeIconController.forward();
                        }
                        if (cardState.addNewScreen) {
                          cardState.newTitle = '';
                          cardState.newGoal = '';
                          cardState.newMinutes = '30';
                          cardState.newSeconds = '10';
                          cardState.addNewScreen = !cardState.addNewScreen;
                        } else if (!cardState.deleteCardScreen) {
                          // todo implement delete card mode
                          cardState.deleteCardScreen =
                              !cardState.deleteCardScreen;
                        } else if (cardState.deleteCardScreen) {
                          cardState.deleteCardScreen =
                              !cardState.deleteCardScreen;
                          sharedPref.remove(cardState.deleteTitle);
//                                        CardModel.cardModelsX.removeAt(index); // todo need to update index when removed
                        }
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 80,
                      color: yellow,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  overflow: Overflow.visible,
                  children: [
                    Transform.translate(
                      offset: Offset(
                          MediaQuery.of(context).size.width *
                              0.25 *
                              (1 - addNewIconAnimation.value),
                          0),
                      child: GestureDetector(
                        onTap: () async {
                          // todo implement clearing text fields when hit
                          // todo add some initial goal value if null, or maybe make it a number drop down
                          var keys = await sharedPref.getKeys();
                          setState(() {
                            bool canAddNewScreen = cardState.addNewScreen &&
                                cardState.newTitle.isNotEmpty &&
                                !keys.contains(cardState
                                    .newTitle); // todo add animation for duplicate entry
                            if (canAddNewScreen) {
                              addNewIconController.reverse();
                              cardState.addToCardModelsList(
                                CardModel(
                                  index: cardState.length,
                                  title: cardState.newTitle,
                                  score: 0,
                                  goal: int.tryParse(cardState.newGoal) == null
                                      ? '-2'
                                      : int.tryParse(cardState.newGoal),
                                  minutes: int.parse(cardState.newMinutes),
                                  seconds: int.parse(cardState.newSeconds),
                                ),
                              );
                              widget.cardTileList.add(CardTile(
                                  cardModel:
                                      cardState.at(cardState.length - 1)));
                              cardState.addNewScreen = !cardState.addNewScreen;
                              print(CardModel.cardModelsX.toString());
                              sharedPref.save(cardState.newTitle,
                                  cardState.at(cardState.length - 1).toJson());
                            } else {
                              print('Not added');
                              print('Tried to add title ${cardState.newTitle}');
                            }
                          });
                        },
                        child: Icon(
                          Icons.check_box,
                          size: 80,
                          color: yellow,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                          MediaQuery.of(context).size.width *
                              0.25 *
                              addNewIconAnimation.value,
                          0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!cardState.addNewScreen) {
                              cardState.addNewScreen = true;
                              addNewIconController.forward();
                            }
                          });
                        },
                        child: Icon(
                          Icons.add_box,
                          size: 80,
                          color: yellow,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: cardState.addNewScreen ||
                          CardModel.cardModelsX.length > 1,
                      // todo add if <= 2 items
                      child: Transform.translate(
                        offset:
                            Offset(-MediaQuery.of(context).size.width * 0.3, 0),
                        child: Text('Press \'+\' to add items -->',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'IndieFlower',
                            )),
                      ),
                    ),
                    Offstage(
                      // todo: moves up when shown, try to disable that
                      // todo: has a red background while screen is moving, try to change it
                      offstage: !cardState.addNewScreen,
                      child: Transform.translate(
                        offset:
                            Offset(-MediaQuery.of(context).size.width * 0.3, 0),
                        child: Container(
                          color: red1,
                          child: Text('Press \'✓\' to add item -->',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'IndieFlower',
                              )),
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
    );
  }

  @override
  void dispose() {
    addNewIconController.dispose();
    closeIconController.dispose();
    super.dispose();
  }
}
