import 'package:flutter/cupertino.dart';

import '../constants.dart';

class CardModel {
  int index;
  String title;
  int score;
  int goal;
  Duration duration;
  bool selected;
  CardModel({
    @required this.index,
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.duration,
    @required this.selected,
  });
}
