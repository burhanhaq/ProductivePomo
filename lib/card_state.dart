import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/shared_pref.dart';

import 'models/card_model.dart';
import 'widgets/card_tile.dart';

class CardState with ChangeNotifier {
  bool devMode = true;
  int _pageScore;
  int _pageGoal;

//  int _currentIndex;
  bool _selected; // todo replace with index
  bool _addNewScreen = false;
  bool _deleteCardScreen = false;

  String _newTitle = '';
  String _newGoal = '1';
  String _newMinutes = '30';
  String _newSeconds = '10';
  String _deleteTitle = '';

  bool _isClearTitleTextEditingController = false;

//  SharedPref sharedPref = SharedPref(); // todo implement this maybe to speed things up
//  bool _onCurrentCardScreen = false;

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

//  int get currentIndex => _currentIndex;

  int get length => _cardModels.length;

  bool get selected {
    return _selected == null ? false : _selected;
  }

  bool get addNewScreen => _addNewScreen;

  bool get deleteCardScreen => _deleteCardScreen;

  String get newTitle => _newTitle;

  String get newGoal {
    if (_newGoal == '') {
      _newGoal = '1';
      notifyListeners();
    }
    return _newGoal;
  }

  String get newMinutes => _newMinutes;

  String get newSeconds => _newSeconds;

  String get deleteTitle => _deleteTitle;

  bool get isClearTitleTextEditingController =>
      _isClearTitleTextEditingController;

//  bool get onCurrentCardScreen => _onCurrentCardScreen;

  List<CardModel> get cardModels => CardModel.cardModelsX;

  clearCardModelsList() {
    cardModels.clear();
    notifyListeners();
  }

  CardModel at(int i) {
    if (i >= _cardModels.length) {
      // todo change this stupid fix
      return CardModel(
        title: 'Dummy Model',
        goal: -11,
        seconds: -11,
        minutes: -11,
//        index: null,
        score: -11,
      );
    }
    return _cardModels[i];
  }

  void subtract(CardModel model) {
    int i = _cardModels.indexOf(model);
    if (_cardModels[i].score > 0) --_cardModels[i].score;
    notifyListeners();
  }

  void add(CardModel model) async {
    int i = _cardModels.indexOf(model);
    ++_cardModels[i].score;
    notifyListeners();
  }

  List<CardModel> _cardModels = CardModel.cardModelsX;

  addToCardModelsList(CardModel model) {
    _cardModels.add(model);
    notifyListeners();
  }

  set select(CardModel model) {
//    _selected = true;
    int i = cardModels.indexOf(model);

    if (model == null) {
      _pageGoal = null;
      _pageScore = null;
      for (int j = 0; j < _cardModels.length; j++) {
        _cardModels[j].selected = false;
      }
    } else {
      _pageGoal = _cardModels[i].goal;
      _pageScore = _cardModels[i].score;
      for (int j = 0; j < _cardModels.length; j++) {
        _cardModels[j].selected = false;
      }
      _cardModels[i].selected = true;
    }
    print(model.toString());
    notifyListeners();
  }

  set addNewScreen(bool val) {
    _addNewScreen = val;
    notifyListeners();
  }

  set deleteCardScreen(bool val) {
    _deleteCardScreen = val;
    notifyListeners();
  }

  set newTitle(String val) {
    _newTitle = val;
    notifyListeners();
  }

  set newGoal(String val) {
    _newGoal = val;
    notifyListeners();
  }

  set newMinutes(String val) {
    _newMinutes = val;
    notifyListeners();
  }

  set newSeconds(String val) {
    _newSeconds = val;
    notifyListeners();
  }

  set deleteTitle(String val) {
    _deleteTitle = val;
    notifyListeners();
  }

  void clearTitleTextEditingControllerSwitch() {
    _isClearTitleTextEditingController = !_isClearTitleTextEditingController;
    notifyListeners();
  }
}
