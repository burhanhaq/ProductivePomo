import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../models/card_model.dart';
import '../../../database_helper.dart';
import 'display_chart_item.dart';
import '../../../widgets/loading_indicator.dart';

class DisplayChart extends StatefulWidget {
  final title;
  final DisplayChartItemType displayChartType;

  DisplayChart({@required this.title, @required this.displayChartType});

  @override
  _DisplayChartState createState() => _DisplayChartState();
}

class _DisplayChartState extends State<DisplayChart>
    with SingleTickerProviderStateMixin {
  var dataFromDB = [];
  List<CardModel> dataFromDBtoCardModelList = [];

  Future<dynamic> getDBInfo(DisplayChartItemType displayChartItemType,
      String name, String date) async {
    switch (displayChartItemType) {
      case DisplayChartItemType.MaxScore:
      case DisplayChartItemType.ScoreOverGoal:
        dataFromDB = await DB.instance.queryModelsWithDate(date);
        break;
      case DisplayChartItemType.ByName:
      case DisplayChartItemType.ByName2:
        dataFromDB = await DB.instance.queryDatesWithModel(name); // works
        break;
    }
    dataFromDBtoCardModelList.clear(); // todo: not super efficient perhaps
    for (int i = 0; i < dataFromDB.length; i++) {
      setState(() {
        dataFromDBtoCardModelList.add(CardModel.fromJson(dataFromDB[i]));
      });
    }
    return dataFromDBtoCardModelList;
  }

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
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
          Text(widget.title, style: kMonthsTextStyle),
          SizedBox(
            height: sectionHeight * 0.5,
            child: FutureBuilder(
                future: getDBInfo(widget.displayChartType,
                    cardState.getNameFromX(), cardState.getDateFromDial()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return DisplayLoadingWidget();
                  }
                  if (snapshot.data.length == 0) {
                    return DisplayLoadingWidget();
                  }
                  var displayChartItemList = List.generate(
                    snapshot.data.length,
                    (index) => DisplayChartItem(
                      cardModel: snapshot.data[index],
                      chartItemType: widget.displayChartType,
                    ),
                  );
                  return ListView(
                    children: displayChartItemList,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class DisplayLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 200),
        LoadingIndicator(
          rotationsToDisableAfter: 2,
        ),
        Spacer(),
        Text(
          'No data to display', // todo animate
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontFamily: 'IndieFlower',
              color: red12),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
