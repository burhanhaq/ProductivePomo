import 'package:flutter/material.dart';

import '../constants.dart';

class CardModel {
  String title;
  String date;
  int score;
  int goal;
  int minutes;
  bool selected;

  CardModel({
    @required this.title,
    @required this.score, // todo remove this later
    @required this.goal,
    @required this.minutes,
  }) {
    this.selected = false;
    this.date =
        '${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
  }

  toString() {
    return '>       date: ${this.date}, score: ${this.score}, goal: ${this.goal}, minutes: ${this.minutes}, title: ${this.title} ${this.selected}';
  }

  operator==(dynamic other) {
    if (other is! CardModel) return false;
    CardModel model = other;
    return (this.title == model.title && this.date == model.date);
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
        minutes = json['minutes'],
        selected = false;

  static List<CardModel> cardModelsX = [];

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + title.hashCode;
    result = 37 * result + date.hashCode;
    return result;
  }
}
