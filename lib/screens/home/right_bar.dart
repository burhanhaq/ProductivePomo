import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/card_tile.dart';
import '../../card_state.dart';
import '../../models/card_model.dart';
import '../../shared_pref.dart';
import 'custom_icon_button.dart';
import '../../database_helper.dart';

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
      onTap: () => cardState.onTapRightBar(),
      onHorizontalDragUpdate: (details) =>
          cardState.onHorizontalDragUpdateRightBar(details),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          YellowUnderlay(),
          AnimatedContainer(
            duration: Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: red1,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
              ),
            ),
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
                        FittedBox(
                          // todo fix: moves around when score increases
                          fit: BoxFit.fitHeight,
                          child: Text(
                            cardState.firstPageScore == null
                                ? 'x'
                                : cardState.firstPageScore.toString(),
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              decoration: TextDecoration.none,
                            ),
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
//              Spacer(),
                  Column(
                    children: [
                      Offstage(
                        offstage: !kDebugMode,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                await DB.instance.recreateTable();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text('Recreate table'),
                              ),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await DB.instance.rando();
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text('Rando'))),
                            GestureDetector(
                                onTap: () async {
//                                  var two = await DB.instance
//                                      .insertOrUpdateRecord(widget
//                                              .cardTileList[2].cardModel
//                                              .toJson()
//                                          );
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text('Insert'))),
                            GestureDetector(
                                onTap: () async {
                                  var query = await DB.instance.queryRecords();
                                  print('query: $query');
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text('Query'))),
                            GestureDetector(
                                onTap: () async {
                                  var update =
                                      await DB.instance.insertOrUpdateRecord({
                                    DB.columnTitle: 'two',
                                    DB.columnDate: 2012,
                                    DB.columnScore: 1,
                                    DB.columnGoal: 2,
                                    DB.columnMinutes: 2,
                                  });
                                  print('update: $update');
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text('Update'))),
                            GestureDetector(
                                onTap: () async {
//                                  var delete = await DB.instance
//                                      .deleteRecord('one', '2017');
//                                  print('delete: $delete');
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text('Delete'))),
                          ],
                        ),
                      ),
                      CustomIconButton(
                        name: 'Print All',
                        iconData: Icons.grain,
                        offstage: kReleaseMode,
                        textOffstage: !cardState.homeRightBarOpen,
                        func: () {
                          print(
                              'cardModelsX: ${CardModel.cardModelsX.toString()}');
                        },
                      ),
                      CustomIconButton(
                        name: 'Delete All',
                        iconData: Icons.do_not_disturb_on,
                        offstage: kReleaseMode || !cardState.homeRightBarOpen,
                        textOffstage: !cardState.homeRightBarOpen,
                        func: () => cardState.onTapDeleteAllRightBar(),
                      ),
                      ScaleTransition(
                        scale: deleteIconScaleAnimation,
                        child: CustomIconButton(
                          name: 'Delete Item',
                          iconData: Icons.delete,
                          offstage: cardState.selectedIndex == null,
                          textOffstage: !cardState.homeRightBarOpen,
                          func: () => cardState.onTapDeleteRightBar(),
                          c: cardState.selectedIndex ==
                                  cardState.confirmDeleteIndex
                              ? blue
                              : yellow,
                        ),
                      ),
                      ScaleTransition(
                        scale: cancelIconScaleAnimation,
                        child: CustomIconButton(
                          name: 'Cancel',
                          iconData: Icons.cancel,
                          offstage: !cardState.onAddNewScreen,
                          textOffstage: !cardState.homeRightBarOpen,
                          func: () => cardState.onTapCancelRightBar(
                              addNewIconController, cancelIconScaleController),
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
                              func: () => cardState.onTapCheckBoxRightBar(
                                  widget.cardTileList,
                                  addNewIconController,
                                  cancelIconScaleController),
                              c: cardState.canAddItem() ? yellow : red2,
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
                              func: () => cardState.onTapAddRightBar(
                                  addNewIconController,
                                  cancelIconScaleController),
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
        ],
      ),
    );
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

class YellowUnderlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
//      width: MediaQuery.of(context).size.width *
//          (kHomeRightBarClosedMul + kHomeYellowDividerMul),
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(25),
        ),
      ),
      width: MediaQuery.of(context).size.width *
          ((cardState.homeRightBarOpen
                  ? kHomeRightBarOpenMul
                  : kHomeRightBarClosedMul) +
              kHomeYellowDividerMul),
    );
  }
}
