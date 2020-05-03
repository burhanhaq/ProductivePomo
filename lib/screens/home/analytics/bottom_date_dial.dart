import 'package:flutter/material.dart';

import '../../../constants.dart';

class BottomDateDial extends StatelessWidget {
  final contentList;

  BottomDateDial({@required this.contentList});

  @override
  Widget build(BuildContext context) {
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kSecondaryRadius),
          topRight: Radius.circular(kSecondaryRadius),
          bottomLeft: Radius.circular(kSecondaryRadius),
          bottomRight: Radius.circular(kSecondaryRadius),
        ),
      ),
      child: SizedBox(
        width: sectionWidth,
        height: sectionHeight * 0.1,
        child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView(
            onSelectedItemChanged: (index) {
              print(contentList[index]);
            },
            itemExtent: 150,
            children: List.generate(
              contentList.length,
                  (index) => RotatedBox(
                quarterTurns: 1,
                child: Text(
                  contentList[index].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
