import 'package:flutter/material.dart';
import '../screens/second/second_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../card_state.dart';
import '../models/card_model.dart';

class CardTile extends StatefulWidget {
  final CardModel cardModel;

  CardTile({@required this.cardModel});

  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> with TickerProviderStateMixin {
  var cardScreenTranslateController;
  var cardScreenTranslateAnimation;
  var iconSizeTransitionController;

  @override
  void initState() {
    super.initState();
    cardScreenTranslateController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    cardScreenTranslateAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(cardScreenTranslateController)
          ..addListener(() {
            setState(() {});
          });
    iconSizeTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    final String title = widget.cardModel.title;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isCardSelected = widget.cardModel.selected;
    if (isCardSelected) {
      iconSizeTransitionController.forward();
    } else {
      iconSizeTransitionController.reverse();
    }
    return GestureDetector(
      onHorizontalDragUpdate: (details) =>
          cardState.onHorizontalDragUpdateCardTile(details, widget.cardModel,
              context, cardScreenTranslateController),
      onTap: () => cardState.onTapCardTile(widget.cardModel, context),
      child: Transform.translate(
        offset: Offset(
            cardScreenTranslateAnimation.value < 0.5
                ? -(cardScreenTranslateAnimation.value * screenWidth * 0.5)
                : ((1 - cardScreenTranslateAnimation.value) *
                    screenWidth *
                    0.5),
            0),
        child: Container(
          margin: EdgeInsets.fromLTRB(
              screenWidth * 0.07, 20.0, screenWidth * 0.04, 0.0),
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.fromLTRB(7, 0, 7, 5),
                curve: Curves.fastOutSlowIn,
//          width: double.infinity,
                height: isCardSelected ? 150 : 100,
                decoration: BoxDecoration(
                  color: isCardSelected ? red1 : yellow,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    topLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                    bottomLeft: Radius.circular(3),
                  ),
                  border: Border.all(
                    width:
                        cardState.selectedIndex == cardState.confirmDeleteIndex
                            ? 2
                            : 0,
                    color:
                        cardState.selectedIndex == cardState.confirmDeleteIndex
                            ? blue
                            : trans,
                  ),
//            boxShadow: [
//             isCardSelected ? BoxShadow(
//               color: Colors.black,
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: Offset(7, 7),
//             ) :
//             BoxShadow(
//               blurRadius: 0,
//               spreadRadius: 0,
//               offset: Offset(0, 0),
//             ),
//            ],
                ),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: isCardSelected ? white : grey,
                            ),
                            Spacer(),
                            Text(
                              widget.cardModel.score.toString(),
                              style: isCardSelected
                                  ? kScore.copyWith(color: white)
                                  : kScore,
                            ),
                          ],
                        ),
                        Text(
                          widget.cardModel.title.length > 12
                              ? title.substring(0, 12) + '..'
                              : title,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          style: isCardSelected
                              ? kLabel.copyWith(color: white)
                              : kLabel,
                        ),
                      ],
                    ),
                    Spacer(),
                    Offstage(
                      offstage: !isCardSelected,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: SizeTransition(
                          sizeFactor: iconSizeTransitionController,
                          axisAlignment: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () => cardState
                                    .onTapSubtractScore(widget.cardModel),
                                child: CustomIconButtonStyle(
                                  child: Icon(
                                    Icons.remove,
                                    size: 40,
                                    color: red1,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    cardState.onTapAddScore(widget.cardModel),
                                child: CustomIconButtonStyle(
                                  child: Icon(
                                    Icons.add,
                                    size: 40,
                                    color: red1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: (widget.cardModel.score /
                                  widget.cardModel.goal *
                                  10000)
                              .toInt(),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 2,
                            color: isCardSelected ? yellow : red1,
                          ),
                        ),
                        Expanded(
                          flex: ((1 -
                                      widget.cardModel.score /
                                          widget.cardModel.goal) *
                                  10000)
                              .toInt(),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 2,
                            color: isCardSelected ? red1 : yellow,
                          ),
                        ),
                      ],
                    ),
                  ],
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
    cardScreenTranslateController.dispose();
    iconSizeTransitionController.dispose();
    super.dispose();
  }
}
