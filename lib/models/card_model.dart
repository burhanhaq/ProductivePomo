import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
    this.selected = false,
  });

  Map<String, dynamic> toJson() => {
        'index': index,
        'title': title,
        'score': score,
        'goal': goal,
      };

  CardModel.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        title = json['title'],
        score = json['score'],
        goal = json['goal'];

  static List<CardModel> cardModelsX = [
    CardModel(
      index: 0,
      title: 'Work',
      score: 0,
      goal: 1,
      duration: Duration(seconds: 1),
      selected: false,
    ),
    CardModel(
      index: 1,
      title: 'Flutter',
      score: 1,
      goal: 200,
      duration: Duration(seconds: 2),
      selected: false,
    ),
    CardModel(
      index: 2,
      title: 'Exercise',
      score: 2,
      goal: 3,
      duration: Duration(minutes: 21),
      selected: false,
    ),
    CardModel(
      index: 3,
      title: 'Empty',
      score: 3,
      goal: 4,
      duration: Duration(minutes: 4),
      selected: false,
    ),
    CardModel(
      index: 4,
      title: 'Flute',
      score: 4,
      goal: 5,
      duration: Duration(minutes: 30),
      selected: false,
    ),
    CardModel(
      index: 5,
      title: 'Sit updslkafjsakfsdffds',
      score: 5,
      goal: 6,
      duration: Duration(milliseconds: 3000),
      selected: false,
    ),
    CardModel(
      index: 6,
      title: 'Quran',
      score: 6,
      goal: 7,
      duration: Duration(seconds: 10),
      selected: false,
    ),
    CardModel(
      index: 7,
      title: 'Water',
      score: 7,
      goal: 8,
      duration: Duration(seconds: 8),
      selected: false,
    ),
  ];
}
