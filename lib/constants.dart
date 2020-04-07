import 'package:flutter/material.dart';

import 'models/card_model.dart';

const kLabel = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
  letterSpacing: 5.0,
);

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
