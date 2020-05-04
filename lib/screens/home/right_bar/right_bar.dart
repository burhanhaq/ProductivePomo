import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../widgets/card_tile.dart';
import '../../../card_state.dart';
import '../../../models/card_model.dart';
import '../../../shared_pref.dart';
import 'custom_icon_button.dart';
import '../../../database_helper.dart';

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
                  Offstage(
                    offstage: !kDebugMode,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
//                          var all = await DB.instance.queryRecords();
                            print('--');
                            print(cardState.getDate());
//                          print(all);
                            print('--');
                          },
                          child: Text('dial date'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      CustomIconButton(
                        name: 'Print All',
                        iconData: Icons.grain,
                        offstage: kReleaseMode,
                        func: () => cardState.onTapExtraDebugRightBar(),
                      ),
                      CustomIconButton(
                        name: 'Contracts',
                        iconData: Icons.style,
                        offstage: kReleaseMode,
                        func: () {},
                      ),
                      CustomIconButton(
                        name: 'Delete All',
                        iconData: Icons.do_not_disturb_on,
                        offstage: kReleaseMode || !cardState.homeRightBarOpen,
                        func: () => cardState.onTapDeleteAllRightBar(),
                      ),
                      CustomIconButton(
                        name: 'Analytics',
                        iconData: Icons.assessment,
                        func: () {
                          cardState.showAnalytics = !cardState.showAnalytics;
                        },
                      ),
                      ScaleTransition(
                        scale: deleteIconScaleAnimation,
                        child: CustomIconButton(
                          name: 'Delete Item',
                          iconData: Icons.delete,
                          offstage: cardState.selectedIndex == null,
                          func: () => cardState.onTapDeleteItemRightBar(),
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
                              func: () => cardState.onTapAddItemRightBar(
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
