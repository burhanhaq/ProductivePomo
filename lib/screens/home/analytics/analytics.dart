import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import 'display_chart.dart';
import 'bottom_date_dial.dart';
import '../../../database_helper.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
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
                  ],
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (cardState.analyticsPage == 2) {
                  return FutureBuilder(
                      future: DB.instance.queryModelNames(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(); // todo return loading indicator maybe
                        List<Map<String, dynamic>> x = snapshot.data;
                        List<String> y = [];
                        x.forEach((element) {
                          y.add(element['title']);
                        });
                        return SizedBox(
                          height: sectionHeight * 0.3,
                          child: ListView(
                            children: List.generate(
                              y.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  cardState.nameX = y[index];
                                },
                                child: Text(y[index]),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.1,
                        child: Container(
                          width: 150,
                          height: sectionHeight * 0.24,
                          decoration: BoxDecoration(
                            color: grey2,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          BottomDateDial(
                            contentList: dayList,
                            onSelectedItemChanged: (val) =>
                                cardState.onDayChange(val),
                            dateInfo: DateTime.now().day,
                          ),
                          Container(
                            height: 1,
                            width: 20,
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          BottomDateDial(
                            contentList: monthList,
                            onSelectedItemChanged: (val) =>
                                cardState.onMonthChange(val),
                            dateInfo: DateTime.now().month,
                          ),
                          Container(
                            height: 1,
                            width: 20,
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          BottomDateDial(
                            contentList: yearList,
                            onSelectedItemChanged: (val) =>
                                cardState.onYearChange(val),
                            dateInfo: yearList.indexOf(DateTime.now().year),
                          ),
                        ],
                      ),
                    ],
                  );
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

class PageViewAnimationSmallCircle extends StatelessWidget {
  final DisplayChartItemType displayChartType;

  PageViewAnimationSmallCircle({@required this.displayChartType});

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      height: 7,
      width: cardState.analyticsPage == displayChartType.index ? 30 : 15,
      decoration: BoxDecoration(
        color:
            cardState.analyticsPage == displayChartType.index ? yellow : grey2,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
