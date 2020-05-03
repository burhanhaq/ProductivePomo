import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import 'display_chart_item.dart';
import 'bottom_date_dial.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;

    var dayList = List.generate(30, (index) => index + 1);
    var monthList = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    var yearList = [2019, 2020, 2021, 2022];
//    cardState.cardModels.forEach((element) {
//      if (element.score > cardState.maxScore)
//        cardState.maxScore = element.score;
//    });
//    cardState.maxScore = 3;
    var displayChartItemList = List.generate(
      cardState.cardModels.length,
      (index) => DisplayChartItem(cardModel: cardState.cardModels[index]),
    );

    return GestureDetector(
      onTap: () {
        cardState.closeHomeRightBar();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: sectionWidth,
        height: sectionHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(kMainRadius),
            bottomLeft: Radius.circular(kMainRadius),
          ),
          color: grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: grey2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SizedBox(
                height: sectionHeight * 0.5,
                child: ListView(
                  children: displayChartItemList,
                ),
              ),
            ),
            Spacer(),
            Column(
              children: <Widget>[
                BottomDateDial(contentList: dayList),
//                Icon(Icons.keyboard_arrow_up),
                BottomDateDial(contentList: monthList),
//                Icon(Icons.eject),
                BottomDateDial(contentList: yearList),
//                Icon(Icons.arrow_drop_up),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

