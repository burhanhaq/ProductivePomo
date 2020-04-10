import 'package:flutter/cupertino.dart';

import '../constants.dart';

class CardModel {
  String text;
  int score;
  int goal;
  Duration duration;
  CardModel({
    @required this.text,
    @required this.score,
    @required this.goal,
    @required this.duration,
  });
}
