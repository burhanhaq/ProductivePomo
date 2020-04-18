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

  int _selectedIndex;
  bool _addNewScreen = false;
  bool _deleteCardScreen = false;

  String _newTitle = '';
  String _newGoal = '1';
  String _newMinutes = '30';
  String _newSeconds = '10';

  bool _isClearTitleTextEditingController = false;

//  SharedPref sharedPref = SharedPref(); // todo implement this maybe to speed things up

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

  int get length => _cardModels.length;

  int get selectedIndex {
    return _selectedIndex; // todo check this
  }

  bool get addNewScreen => _addNewScreen;

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

  bool get isClearTitleTextEditingController =>
      _isClearTitleTextEditingController;


  clearCardModelsList() {
    _cardModels.clear();
    notifyListeners();
  }

  CardModel at(int i) { // todo see if this is needed
    if (i >= _cardModels.length) {
      // todo change this stupid fix
      return CardModel(
        title: 'Dummy Model',
        goal: -11,
        seconds: -11,
        minutes: -11,
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

  List<CardModel> _cardModels = CardModel.cardModelsX; // todo duplicates
  List<CardModel> get cardModels => CardModel.cardModelsX;

  addToCardModelsList(CardModel model) {
    _cardModels.add(model);
    notifyListeners();
  }

  set selectTile(CardModel model) {
    int i = _cardModels.indexOf(model);

    if (model == null) {
      _pageGoal = null;
      _pageScore = null;
      _selectedIndex = null;
      for (int j = 0; j < _cardModels.length; j++) {
        _cardModels[j].selected = false;
      }
    } else {
      _selectedIndex = i;
      _pageGoal = _cardModels[i].goal;
      _pageScore = _cardModels[i].score;
      for (int j = 0; j < _cardModels.length; j++) {
        _cardModels[j].selected = false;
      }
      _cardModels[i].selected = true;
    }
    notifyListeners();
  }

  set addNewScreen(bool val) {
    _addNewScreen = val;
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

  void clearTitleTextEditingControllerSwitch() {
    _isClearTitleTextEditingController = !_isClearTitleTextEditingController;
    notifyListeners();
  }
}
