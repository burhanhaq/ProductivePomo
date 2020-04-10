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

enum CardType { Counter, Session }

List<CardModel> cardModels = [
  CardModel(text: 'Work', type: CardType.Session),
  CardModel(text: 'Flutter', type: CardType.Session),
  CardModel(text: 'Exercise', type: CardType.Session),
  CardModel(text: 'Empty', type: CardType.Session),
  CardModel(text: 'Flute', type: CardType.Session),
  CardModel(text: 'Sit updslkafjsakljfsdffds', type: CardType.Session),
  CardModel(text: 'Quran', type: CardType.Session),
  CardModel(text: 'Water', type: CardType.Counter),
];
