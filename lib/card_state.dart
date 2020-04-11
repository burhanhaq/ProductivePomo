import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/card_model.dart';

//AnimationController screenChangeController;

class CardState with ChangeNotifier {
  int _pageScore;
  int _pageGoal;
  int _currentIndex;
  bool _selected;

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

  int get currentIndex => _currentIndex;

  int get length => _cardModels.length;

  bool get selected => _selected;

  void init() {
    _pageScore = _cardModels[0].score;
    _pageGoal = _cardModels[0].goal;
    _currentIndex = _cardModels[0].index;
    notifyListeners();
  }

  set currentIndex(int i) {
    _pageGoal = _cardModels[i].goal;
    _pageScore = _cardModels[i].score;
    _currentIndex = i;
    for (int j = 0; j < _cardModels.length; j++) {
      _cardModels[j].selected = false;
    }
    _cardModels[i].selected = true;
    notifyListeners();
  }

  CardModel at(int i) {
    return _cardModels[i];
  }

  void subtract(int i) {
    if (_cardModels[i].score > 0) --_cardModels[i].score;
    notifyListeners();
  }

  void add(int i) {
    ++_cardModels[i].score;
    notifyListeners();
  }

  List<CardModel> _cardModels = [
    CardModel(
      index: 0,
      text: 'Work',
      score: 100,
      goal: 1,
      duration: Duration(seconds: 1),
      selected: false,
    ),
    CardModel(
      index: 1,
      text: 'Flutter',
      score: 1,
      goal: 200,
      duration: Duration(seconds: 2),
      selected: false,
    ),
    CardModel(
      index: 2,
      text: 'Exercise',
      score: 2,
      goal: 3,
      duration: Duration(minutes: 1000),
      selected: false,
    ),
    CardModel(
      index: 3,
      text: 'Empty',
      score: 3,
      goal: 4,
      duration: Duration(minutes: 4),
      selected: false,
    ),
    CardModel(
      index: 4,
      text: 'Flute',
      score: 4,
      goal: 5,
      duration: Duration(minutes: 100),
      selected: false,
    ),
    CardModel(
      index: 5,
      text: 'Sit updslkafjsakfsdffds',
      score: 5,
      goal: 6,
      duration: Duration(milliseconds: 3000),
      selected: false,
    ),
    CardModel(
      index: 6,
      text: 'Quran',
      score: 6,
      goal: 7,
      duration: Duration(seconds: 10),
      selected: false,
    ),
    CardModel(
      index: 7,
      text: 'Water',
      score: 7,
      goal: 8,
      duration: Duration(seconds: 8),
      selected: false,
    ),
  ];
}
