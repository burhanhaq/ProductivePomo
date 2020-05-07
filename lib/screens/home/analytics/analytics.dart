import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import 'display_chart.dart';
import 'date_selector.dart';
import '../../../database_helper.dart';
import 'name_selector.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  List<bool> selectedList = [];

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    final displayAreaPageController = PageController(
      initialPage: cardState.analyticsPage,
    );
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: sectionWidth,
                  height: sectionHeight * 0.6,
                  child: PageView(
                    controller: displayAreaPageController,
                    onPageChanged: (index) {
                      cardState.analyticsPage = index;
                    },
                    children: <Widget>[
                      DisplayChart(
                        title: 'MaxScore',
                        displayChartType: DisplayChartItemType.MaxScore,
                      ),
                      DisplayChart(
                        title: 'Score/Goal',
                        displayChartType: DisplayChartItemType.ScoreOverGoal,
                      ),
                      DisplayChart(
                        title: 'ByName',
                        displayChartType: DisplayChartItemType.ByName,
                      ),
                      SomethingElse(
                        title: 'ByName2',
//                        displayChartType: DisplayChartItemType.ByName2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    PageViewAnimationSmallCircle(
                      displayChartType: DisplayChartItemType.MaxScore,
                    ),
                    SizedBox(width: 10),
                    PageViewAnimationSmallCircle(
                      displayChartType: DisplayChartItemType.ScoreOverGoal,
                    ),
                    SizedBox(width: 10),
                    PageViewAnimationSmallCircle(
                      displayChartType: DisplayChartItemType.ByName,
                    ),
                    SizedBox(width: 10),
                    PageViewAnimationSmallCircle(
                      displayChartType: DisplayChartItemType.ByName2,
                    ),
                  ],
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (cardState.analyticsPage >= 2) {
                  return NameSelectorWidget();
                } else {
                  return DateSelectorWidget();
                }
              },
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
//    displayAreaPageController.dispose();
    super.dispose();
  }
}
