import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/card_tile.dart';
import '../../card_state.dart';
import '../../models/card_model.dart';
import '../../shared_pref.dart';
import 'custom_icon_buttom.dart';

class RightBar extends StatefulWidget {
  final List<CardTile> cardTileList;

  RightBar({@required this.cardTileList});

  @override
  _RightBarState createState() => _RightBarState();
}

class _RightBarState extends State<RightBar> with TickerProviderStateMixin {
  var addNewIconController;
  var addNewIconAnimation;
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
        duration: Duration(milliseconds: 120),
        color: red1,
        width: MediaQuery.of(context).size.width *
            (cardState.homeRightBarOpen
                ? kHomeRightBarOpenMul
                : (kHomeRightBarClosedMul +
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
                    Container(height: 6, width: 60, color: yellow),
                    Text(
                      cardState.firstPageGoal == null
                          ? 'y'
                          : cardState.firstPageGoal.toString(),
                      style: TextStyle(
                        color: yellow,
                        fontSize: 30,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  CustomIconButton(
                    name: 'Print All',
                    iconData: Icons.grain,
                    offstage: kReleaseMode,
                    textOffstage: !cardState.homeRightBarOpen,
                    func: () => print(
                        'cardModelsX: ${CardModel.cardModelsX.toString()}'),
                  ),
                  CustomIconButton(
                    name: 'Delete All',
                    iconData: Icons.do_not_disturb_on,
                    offstage: kReleaseMode,
                    textOffstage: !cardState.homeRightBarOpen,
                    func: () => deleteAllIconF(cardState),
                  ),
                  ScaleTransition(
                    scale: deleteIconScaleAnimation,
                    child: CustomIconButton(
                      name: 'Delete Item',
                      iconData: Icons.delete,
                      offstage: cardState.selectedIndex == null,
                      textOffstage: !cardState.homeRightBarOpen,
                      func: () => deleteIconF(cardState),
                      c: cardState.selectedIndex == cardState.confirmDeleteIndex
                          ? blue
                          : yellow,
                    ),
                  ),
                  ScaleTransition(
                    scale: cancelIconScaleAnimation,
                    child: CustomIconButton(
                      name: 'Cancel',
                      iconData: Icons.cancel,
                      offstage: !cardState.addNewScreen,
                      textOffstage: !cardState.homeRightBarOpen,
                      func: () => cancelIconF(cardState),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(
                          0,
                          MediaQuery.of(context).size.height *
                              0.2 *
                              (1 - addNewIconAnimation.value),
                        ),
                        child: CustomIconButton(
                          name: 'Confirm Item',
                          iconData: Icons.check_box,
                          textOffstage: !cardState.homeRightBarOpen,
                          func: () => checkBoxIconF(cardState),
                          c: canAddScreen(cardState) ? yellow : red2,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            0,
                            MediaQuery.of(context).size.height *
                                0.2 *
                                addNewIconAnimation.value),
                        child: CustomIconButton(
                          name: 'Add Item',
                          iconData: Icons.add_box,
                          textOffstage: !cardState.homeRightBarOpen,
                          func: () => addIconF(cardState),
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

  bool canAddScreen(CardState cardState) {
//    var keys = await sharedPref.getKeys(); // maybe i can perform this with cardList instead
    var keys = [];
    CardModel.cardModelsX.forEach((element) {
      keys.add(element.title.toLowerCase());
    });
    return cardState.addNewScreen &&
        cardState.newTitle.isNotEmpty &&
        !keys.contains(cardState.newTitle);
  }

  checkBoxIconF(CardState cardState) {
    setState(() {
      bool canAddNewScreen = canAddScreen(cardState);
      if (canAddNewScreen) {
        addNewIconController.reverse();
        cancelIconScaleController.reverse();
//                                cardState.clearTitleTextEditingControllerSwitch();
        cardState.addToCardModelsList(
          CardModel(
            title: cardState.newTitle,
            score: 0,
            goal: int.tryParse(cardState.newGoal) == null
                ? '777'
                : int.tryParse(cardState.newGoal),
            minutes: int.parse(cardState.newMinutes),
            seconds: int.parse(cardState.newSeconds),
          ),
        );
        widget.cardTileList
            .add(CardTile(cardModel: cardState.cardModels[cardState.cardModels.length - 1]));
        cardState.addNewScreen = !cardState.addNewScreen;
        sharedPref.save(
            cardState.newTitle, cardState.cardModels[cardState.cardModels.length - 1].toJson());
        cardState.resetNewVariables();
      } else {
        print('can not add');
      }
    });
  }

  addIconF(CardState cardState) {
    if (!cardState.addNewScreen) {
      cancelIconScaleController.forward();
      cardState.addNewScreen = true;
      cardState.closeHomeRightBar();
      cardState.selectTile = null;
      addNewIconController.forward();
    }
  }

  cancelIconF(CardState cardState) {
    addNewIconController.reverse();
    cancelIconScaleController.reverse();
    if (cardState.addNewScreen) {
      cardState.resetNewVariables();
      cardState.addNewScreen = !cardState.addNewScreen;
    }
  }

  deleteIconF(CardState cardState) {
    if (cardState.confirmDeleteIndex == cardState.selectedIndex) {
      // second tap
      sharedPref.remove(cardState.cardModels[cardState.selectedIndex].title);
      CardModel.cardModelsX.removeAt(cardState.selectedIndex);
      cardState.selectTile = null;
    } else {
      // first tap for confirmation
      cardState.confirmDeleteIndex = cardState.selectedIndex;
    }
  }

  deleteAllIconF(CardState cardState) {
    sharedPref.removeAll();
    cardState.clearCardModelsList();
  }

  @override
  void dispose() {
    addNewIconController.dispose();
    rightBarController.dispose();
    cancelIconScaleController.dispose();
    deleteIconScaleController.dispose();
    super.dispose();
  }
}
