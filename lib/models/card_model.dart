import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CardModel {
  int index;
  String title;
  int score;
  int goal;
  int minutes;
  int seconds;
  bool selected; // todo change to int selected

  CardModel({
    @required this.index,
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.minutes,
    @required this.seconds,
    this.selected = false,
  });

  toString() {
    return '> ${this.title} - ${this.score}/${this.goal} ${this.minutes}:${this.seconds}';
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'score': score,
        'goal': goal,
        'minutes': minutes,
        'seconds': seconds,
      };

  CardModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        score = json['score'],
        goal = json['goal'],
        minutes = json['minutes'],
        seconds = json['seconds'];

  static List<CardModel> cardModelsX = [
//    CardModel(
//      index: 0,
//      title: 'Work',
//      score: 0,
//      goal: 1,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 1,
//      title: 'Flutter',
//      score: 1,
//      goal: 200,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 2,
//      title: 'Exercise',
//      score: 2,
//      goal: 3,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 3,
//      title: 'Empty',
//      score: 3,
//      goal: 4,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 4,
//      title: 'Flute',
//      score: 4,
//      goal: 5,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 5,
//      title: 'Sit updslkafjsakfsdffds',
//      score: 5,
//      goal: 6,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 6,
//      title: 'Quran',
//      score: 6,
//      goal: 7,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
//    CardModel(
//      index: 7,
//      title: 'Water',
//      score: 7,
//      goal: 8,
//      minutes: 0,
//      seconds: 45,
//      selected: false,
//    ),
  ];
}
