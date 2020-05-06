import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../models/card_model.dart';

class DisplayChartItem extends StatefulWidget {
  final CardModel cardModel;
  final DisplayChartItemType chartItemType;

  DisplayChartItem({@required this.cardModel, @required this.chartItemType});

  @override
  _DisplayChartItemState createState() => _DisplayChartItemState();
}

class _DisplayChartItemState extends State<DisplayChartItem>
    with TickerProviderStateMixin {
  var sizeTransitionController;

  @override
  void initState() {
    super.initState();
    sizeTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    sizeTransitionController.forward();
  }

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    var barLength = sectionWidth * 0.5;
    var coloredBarLength = sectionWidth * 0.5;
    var textToShow;
    double barEndCircleSize = 5;
    Color barEndCircleColor = grey;
    switch (widget.chartItemType) {
      case DisplayChartItemType.MaxScore:
        textToShow = widget.cardModel.title;
        var maxScore = 0;
        cardState.cardModels.forEach((element) { // todo fix this, this doesn't look at dates elements, it looks at current elements
          if (element.score > maxScore) maxScore = element.score;
        });
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else if (maxScore == 0) {
          // do nothing
          print('Error. Please fix and add elements from date');
        } else {
          coloredBarLength *= widget.cardModel.score / maxScore;
        }
        if (maxScore == widget.cardModel.score) {
          barEndCircleSize = 10;
          barEndCircleColor = yellow;
        }
        break;
      case DisplayChartItemType.ScoreOverGoal:
        textToShow = widget.cardModel.title;
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else if (widget.cardModel.score > widget.cardModel.goal) {
          // do nothing
        } else {
          coloredBarLength *= widget.cardModel.score / widget.cardModel.goal;
        }
        if (widget.cardModel.score / widget.cardModel.goal >= 1) {
          barEndCircleSize = 10;
          barEndCircleColor = yellow;
        }
        break;
      case DisplayChartItemType.ByName:
        textToShow = widget.cardModel.date.substring(5);
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else if (widget.cardModel.score > widget.cardModel.goal) {
          // do nothing
        } else {
          coloredBarLength *= widget.cardModel.score / widget.cardModel.goal;
        }
        if (widget.cardModel.score / widget.cardModel.goal >= 1) {
          barEndCircleSize = 10;
          barEndCircleColor = yellow;
        }
        break;
      case DisplayChartItemType.ByName2:
        sectionHeight = 0;
        break;
    }
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: sectionWidth * 0.2,
            height: sectionHeight * 0.05,
            child: Text(textToShow,
                textAlign: TextAlign.end,
                maxLines: 1,
                style: kMonthsTextStyle.copyWith(fontSize: 15)),
          ),
          SizedBox(width: 20),
          Container(
            width: sectionWidth * 0.6,
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: widget.cardModel.score > 0 ? yellow2 : grey,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      width: barLength,
                      height: 1,
                      color: grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                    ),
                    SizeTransition(
                      sizeFactor: sizeTransitionController,
                      axis: Axis.horizontal,
                      axisAlignment: 0,
                      child: Container(
                        width: coloredBarLength,
                        height: 1,
                        color: yellow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                      ),
                    ),
                  ],
                ),
                Container(
//                  width: cardState.maxScore == widget.cardModel.score ? 10 : 5,
//                  height: cardState.maxScore == widget.cardModel.score ? 10 : 5,
                  width: barEndCircleSize,
                  height: barEndCircleSize,
                  decoration: BoxDecoration(
                    color: barEndCircleColor,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    sizeTransitionController.dispose();
    super.dispose();
  }
}
