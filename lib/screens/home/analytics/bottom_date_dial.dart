import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../database_helper.dart';

class BottomDateDial extends StatefulWidget {
  final Function onSelectedItemChanged;
  final BottomDateDialType bottomDataDialType;

  BottomDateDial({
    @required this.onSelectedItemChanged,
    @required this.bottomDataDialType,
  });

  @override
  _BottomDateDialState createState() => _BottomDateDialState();
}

class _BottomDateDialState extends State<BottomDateDial> {
  var itemIndex = 0;
  var contentList = [];
  bool starting = true;
  var scrollController;

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    if (starting && itemIndex == 0) {
      switch (widget.bottomDataDialType) {
        case BottomDateDialType.Day:
          itemIndex = cardState.day - 1;
          contentList = dayList;
          scrollController =
              FixedExtentScrollController(initialItem: itemIndex);
          break;
        case BottomDateDialType.Month:
          itemIndex = cardState.month - 1;
          contentList = monthList;
          scrollController =
              FixedExtentScrollController(initialItem: itemIndex);
          break;
        case BottomDateDialType.Year:
          itemIndex = cardState.year;
          contentList = yearList;
          scrollController =
              FixedExtentScrollController(initialItem: itemIndex);
          break;
      }
      starting = false;
    }
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: sectionWidth,
        height: sectionHeight * 0.09,
        child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView(
            controller: scrollController,
            physics: FixedExtentScrollPhysics(),
            diameterRatio: 1.5,
            offAxisFraction: 1.2,
            onSelectedItemChanged: (index) {
              widget.onSelectedItemChanged(index);
              setState(() {
                itemIndex = index;
              });
            },
            itemExtent: 150,
            children: List.generate(
              contentList.length,
              (index) => RotatedBox(
                quarterTurns: 1,
                child: Container(
                  child: Text(
                    contentList[index].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: index == itemIndex ? yellow : grey2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
