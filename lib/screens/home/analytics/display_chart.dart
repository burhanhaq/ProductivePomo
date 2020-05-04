import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../models/card_model.dart';
import '../../../database_helper.dart';

class DisplayChart extends StatefulWidget {
  final title;
  final DisplayChartItemType displayChartItem;

  DisplayChart({@required this.title, @required this.displayChartItem});

  @override
  _DisplayChartState createState() => _DisplayChartState();
}

var dateFromDB = [];
var dateFromDBtoCardModelList = [];

class _DisplayChartState extends State<DisplayChart> {
  Future<dynamic> getDBInfo(String date) async {
    dateFromDB = await DB.instance.queryModelsWithDate(date);
//    x = await DB.instance.queryDatesWithModel('Flutter'); // works
    dateFromDBtoCardModelList.clear(); // todo: not super efficient perhaps
    for (int i = 0; i < dateFromDB.length; i++) {
      dateFromDBtoCardModelList.add(CardModel.fromJson(dateFromDB[i]));
    }
  }

//  Stream<List<CardModel>> someData() async* {
//    yield* Stream.periodic(Duration(milliseconds: 5000), (int a) {
//      return dateFromDBtoCardModelList;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    if (cardState.callDB) {
      getDBInfo(cardState.getDate());
//      cardState.callDB = false;
      print('called db to update or pull');
    }
    var displayChartItemList = List.generate(
      // todo doesn't update state
      dateFromDBtoCardModelList.length,
      (index) => DisplayChartItem(
        cardModel: dateFromDBtoCardModelList[index],
        chartItemType: widget.displayChartItem,
      ),
    );
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Text(widget.title, style: kMonthsTextStyle),
          SizedBox(
            height: sectionHeight * 0.5,
            child: ListView(
              children: displayChartItemList,
            ),
          ),
        ],
      ),
    );
  }
}

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
    var barLength = sectionWidth * 0.4;
    var coloredBarLength = sectionWidth * 0.4;
    switch (widget.chartItemType) {
      case DisplayChartItemType.MaxScore:
        var maxScore = 0;
        cardState.cardModels.forEach((element) {
          if (element.score > maxScore) maxScore = element.score;
        });
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else {
          coloredBarLength *= widget.cardModel.score / maxScore;
        }
        break;
      case DisplayChartItemType.ScoreOverGoal:
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else if (widget.cardModel.score > widget.cardModel.goal) {
          // do nothing
        } else {
          coloredBarLength *= widget.cardModel.score / widget.cardModel.goal;
        }
        break;
    }
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: sectionWidth * 0.3,
            height: sectionHeight * 0.05,
            child: Text(widget.cardModel.title,
                textAlign: TextAlign.end,
                maxLines: 1,
                style: kMonthsTextStyle.copyWith(fontSize: 20)),
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
                    color: grey,
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
