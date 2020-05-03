import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../models/card_model.dart';

class DisplayChartItem extends StatefulWidget {
  final CardModel cardModel;

  DisplayChartItem({@required this.cardModel});

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
    var barLength = sectionWidth * 0.4;
    var coloredBarLength = 0.0;
    var maxScore = 0;
    cardState.cardModels.forEach((element) {if (element.score > maxScore) maxScore = element.score;});
    if (maxScore == 0) {
      if (widget.cardModel.score > 0)
        coloredBarLength = sectionWidth * 0.4;
      else
        coloredBarLength = 0.0;
    } else if (widget.cardModel.score > maxScore) {
      coloredBarLength = sectionWidth * 0.4;
    } else if (widget.cardModel.score == 0) {
      coloredBarLength = 0.0;
    } else {
      coloredBarLength = sectionWidth * 0.4 * widget.cardModel.score / maxScore;
    }
//    print('maxscore: ${maxScore}');
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: sectionWidth * 0.3,
            height: sectionHeight * 0.05,
            child: Text(widget.cardModel.title,
                maxLines: 1, style: kMonthsTextStyle.copyWith(fontSize: 20)),
          ),
          SizedBox(width: 20),
          Container(
            width: sectionWidth * 0.5,
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
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                    maxScore == widget.cardModel.score
                        ? yellow
                        :
                        grey,
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
