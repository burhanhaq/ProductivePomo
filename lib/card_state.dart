import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/card_model.dart';


//AnimationController screenChangeController;

class CardState with ChangeNotifier {


  List<CardModel> cardModels = [
    CardModel(
      text: 'Work',
      score: 3,
      goal: 21080,
      duration: Duration(seconds: 1),
    ),
    CardModel(
      text: 'Flutter',
      score: 3,
      goal: 1522,
      duration: Duration(seconds: 2),
    ),
    CardModel(
      text: 'Exercise',
      score: 3,
      goal: 21,
      duration: Duration(minutes: 1000),
    ),
    CardModel(
      text: 'Empty',
      score: 3,
      goal: 251,
      duration: Duration(minutes: 4),
    ),
    CardModel(
      text: 'Flute',
      score: 3,
      goal: 241,
      duration: Duration(minutes: 100),
    ),
    CardModel(
      text: 'Sit updslkafjsakfsdffds',
      score: 3,
      goal: 12,
      duration: Duration(milliseconds: 3000),
    ),
    CardModel(
      text: 'Quran',
      score: 3,
      goal: 12,
      duration: Duration(seconds: 10),
    ),
    CardModel(
      text: 'Water',
      score: 3,
      goal: 12,
      duration: Duration(seconds: 8),
    ),
  ];



}