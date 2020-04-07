import 'package:flutter/cupertino.dart';

import '../constants.dart';

class CardModel {
  String text;
  CardType type;
  int goal;
  double duration;
  CardType cardType;
  CardModel({
    @required this.text,
    this.goal,
    this.duration,
    this.cardType,
    @required this.type,
  });
}
