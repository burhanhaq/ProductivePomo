import 'package:flutter/material.dart';

import 'package:pomodoro_app/constants.dart';

class CardModel {
  String title;
  String date;
  int score;
  int goal;
  int minutes;
  bool selected;

  CardModel({
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.minutes,
  }) {
    this.selected = false;
    this.date =
        '${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}';
//    print(this.date);
  }

  toString() {
    return '> ${this.title} - ${this.score}/${this.goal} ${this.minutes}:00:P ${this.selected} ${this.date}';
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'score': score,
        'goal': goal,
        'minutes': minutes,
      };

  CardModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = json['date'],
        score = json['score'],
        goal = json['goal'],
        minutes = json['minutes'];

  static List<CardModel> cardModelsX = [];
}
