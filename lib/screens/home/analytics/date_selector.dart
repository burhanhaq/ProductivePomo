import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import 'bottom_date_dial.dart';

class DateSelectorWidget extends StatelessWidget { // todo convert to stateful if errors
  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: sectionHeight * 0.24,
          decoration: BoxDecoration(
            color: grey2.withOpacity(0.8),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        Column(
          children: <Widget>[
            BottomDateDial(
              contentList: dayList,
              onSelectedItemChanged: (val) => cardState.onDayChange(val),
              dateInfo: DateTime.now().day,
            ),
            Container(
              height: 1,
              width: 20,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            BottomDateDial(
              contentList: monthList,
              onSelectedItemChanged: (val) => cardState.onMonthChange(val),
              dateInfo: DateTime.now().month,
            ),
            Container(
              height: 1,
              width: 20,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            BottomDateDial(
              contentList: yearList,
              onSelectedItemChanged: (val) => cardState.onYearChange(val),
              dateInfo: yearList.indexOf(DateTime.now().year),
            ),
          ],
        ),
      ],
    );
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

class SomethingElse extends StatelessWidget {
  final title;

  SomethingElse({this.title});

  @override
  Widget build(BuildContext context) {
    List<Widget> gridList = List.generate(
      30,
      (index) => Container(
        margin: const EdgeInsets.all(4),
        height: 10,
        width: 10,
        color: grey,
      ),
    );
    gridList.insert(0, Center(child: Text('S')));
    gridList.insert(0, Center(child: Text('S')));
    gridList.insert(0, Center(child: Text('F')));
    gridList.insert(0, Center(child: Text('T')));
    gridList.insert(0, Center(child: Text('W')));
    gridList.insert(0, Center(child: Text('T')));
    gridList.insert(0, Center(child: Text('M')));
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Text(title, style: kMonthsTextStyle),
          SizedBox(
            height: sectionHeight * 0.5,
            child: GridView.count(
              crossAxisCount: 7,
              children: gridList,
            ),
          ),
        ],
      ),
    );
  }
}
