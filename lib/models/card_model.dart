import 'package:flutter/cupertino.dart';

import '../constants.dart';

class CardModel {
  String text;
  CardType type;
  int goal;
  CardModel({
    @required this.text,
    this.goal,
    @required this.type,
  });
}
