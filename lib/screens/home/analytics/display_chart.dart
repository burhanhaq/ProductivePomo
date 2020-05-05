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

  Future<dynamic> getDBInfo(String date) async {
    dataFromDB = await DB.instance.queryModelsWithDate(date);
//    x = await DB.instance.queryDatesWithModel('Flutter'); // works
    dataFromDBtoCardModelList.clear(); // todo: not super efficient perhaps
    for (int i = 0; i < dataFromDB.length; i++) {
      setState(() {
        dataFromDBtoCardModelList.add(CardModel.fromJson(dataFromDB[i]));
      });
    }
    return dataFromDBtoCardModelList;
  }

  var showLoadingIndicator = true;

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    showLoadingIndicator = dataFromDBtoCardModelList.length == 0 ? true : false;
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
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
                child: FutureBuilder(
                    future: getDBInfo(cardState.getDate()),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Center();
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
        ),
        LoadingIndicator(
          showLoadingIndicator: showLoadingIndicator,
          rotationsToDisableAfter: 2,
        ),
        Positioned(
          bottom: 50,
          child: Offstage(
            // todo make it show after indicator fades away
            offstage: dataFromDBtoCardModelList.length != 0,
            child: Text(
              'No data to display',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontFamily: 'IndieFlower', color: red12),
            ),
          ),
        ),
      ],
    );
  }
}
