import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CardModel {
  String title;
  int score;
  int goal;
  int minutes;
  int seconds;
  bool selected;

  CardModel({
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.minutes,
    @required this.seconds,
    this.selected = false,
  });

  toString() {
    return '> ${this.title} - ${this.score}/${this.goal} ${this.minutes}:${this.seconds} ${this.selected}';
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

  static List<CardModel> cardModelsX = [];
}
