import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../database_helper.dart';

class BottomDateDial extends StatefulWidget {
  final contentList;
  final Function onSelectedItemChanged;
  final int dateInfo;

  BottomDateDial({@required this.contentList, @required this.onSelectedItemChanged, @required this.dateInfo});

  @override
  _BottomDateDialState createState() => _BottomDateDialState();
}

class _BottomDateDialState extends State<BottomDateDial> {
  var itemIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (itemIndex == 0) {
      itemIndex = widget.dateInfo;
    }
//    CardState cardState = Provider.of<CardState>(context);
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
            onSelectedItemChanged: (index) async {
              widget.onSelectedItemChanged(index);
              setState(() {
                itemIndex = index;
              });
            },
            itemExtent: 150,
            children: List.generate(
              widget.contentList.length,
              (index) => RotatedBox(
                quarterTurns: 1,
                child: Container(
                  child: Text(
                    widget.contentList[index].toString(),
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
