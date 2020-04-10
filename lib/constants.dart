import 'package:flutter/material.dart';

import 'models/card_model.dart';

const kLabel = TextStyle(
  color: Colors.black,
  fontSize: 25,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
  letterSpacing: 5.0,
);

const double kEndSpacing = 30.0;
const Color grey = Color(0xff343437);
const Color yellow = Color(0xffF7CE47);
const Color red1 = Color(0xffA83535);
const Color red2 = Color(0xff610404);
const Color red3 = Color(0xff400303);
const Color blue = Colors.blue;
const Color white = Colors.white;

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
