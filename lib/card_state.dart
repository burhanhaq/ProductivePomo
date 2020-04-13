import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/card_model.dart';

class CardState with ChangeNotifier {
  int _pageScore;
  int _pageGoal;
  int _currentIndex;
  bool _selected;
  String _newTitle = '';
  String _newGoal = '0';
  String _newMinutes = '10';
  String _newSeconds = '10';

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

  int get currentIndex => _currentIndex;

  int get length => _cardModels.length;

  bool get selected => _selected;

  String get newTitle => _newTitle;
  String get newGoal => _newGoal;
  String get newMinutes => _newMinutes;
  String get newSeconds => _newSeconds;

//  List<Widget> get cardModels => _cardModels;

  void init() {
//    _pageScore = _cardModels[0].score;
//    _pageGoal = _cardModels[0].goal;
//    _currentIndex = _cardModels[0].index;
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

  List<CardModel> _cardModels = CardModel.cardModelsX;

  set newTitle(String val) {
    _newTitle = val;
  }
  set newGoal(String val) {
    _newGoal = val;
  }
  set newMinutes(String val) {
    _newMinutes = val;
  }
  set newSeconds(String val) {
    _newSeconds = val;
  }



}
