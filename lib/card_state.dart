import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/shared_pref.dart';

import 'models/card_model.dart';

class CardState with ChangeNotifier {
  resetNewVariables() {
    _newTitle = '';
    _newGoal = '10';
    _newMinutes = '30';
    _newSeconds = '03';
    notifyListeners();
  }

//  SharedPref sharedPrefCS = SharedPref(); // todo implement this maybe to speed things up

  List<CardModel> get cardModels => CardModel.cardModelsX;

  // HOME PAGE 88888888888888888888888888
  int _pageScore;
  int _pageGoal;
  int _selectedIndex;
  bool _addNewScreen = false;
  int _confirmDeleteIndex = -1;
  String _newTitle;
  String _newGoal;
  String _newMinutes;
  String _newSeconds;
  bool _homeRightBarOpen = false;
  bool _tappedEmptyAreaUnderListView = false;

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

  int get selectedIndex => _selectedIndex;

  bool get addNewScreen => _addNewScreen;

  int get confirmDeleteIndex => _confirmDeleteIndex;

  String get newTitle => _newTitle;

  String get newGoal => _newGoal;

  String get newMinutes => _newMinutes;

  String get newSeconds => _newSeconds;

//  bool get isClearTitleTextEditingController =>
//      _isClearTitleTextEditingController;

  bool get homeRightBarOpen => _homeRightBarOpen;

  bool get tappedEmptyAreaUnderListView => _tappedEmptyAreaUnderListView;

  set selectTile(CardModel model) {
    int i = cardModels.indexOf(model);
    _confirmDeleteIndex = -1;

    if (model == null) {
      _pageGoal = null;
      _pageScore = null;
      _selectedIndex = null;
      for (int j = 0; j < cardModels.length; j++) {
        cardModels[j].selected = false;
      }
    } else {
      _selectedIndex = i;
      _pageGoal = cardModels[i].goal;
      _pageScore = cardModels[i].score;
      for (int j = 0; j < cardModels.length; j++) {
        cardModels[j].selected = false;
      }
      cardModels[i].selected = true;
    }
    notifyListeners();
  }

  set addNewScreen(bool val) {
    _addNewScreen = val;
    notifyListeners();
  }

  set confirmDeleteIndex(int val) {
    _confirmDeleteIndex = val;
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

//  void clearTitleTextEditingControllerSwitch() {
//    _isClearTitleTextEditingController = !_isClearTitleTextEditingController;
//    notifyListeners();
//  }

  openHomeRightBar() {
    _homeRightBarOpen = true;
    notifyListeners();
  }

  closeHomeRightBar() {
    _homeRightBarOpen = false;
    notifyListeners();
  }

  set tappedEmptyAreaUnderListView(bool val) {
    _tappedEmptyAreaUnderListView = val;
    // don't add notifyListeners()
  }

  // SECOND PAGE 8888888888888888888888888888888888888888888888888888888888888
  bool _settingsActive = false;

  get settingsActive => _settingsActive;

  set settingsActive(bool val) {
    _settingsActive = val;
    notifyListeners();
  }

  // RANDOM

  clearCardModelsList() {
    cardModels.clear();
    notifyListeners();
  }

  void subtractScore(CardModel model) {
    int i = cardModels.indexOf(model);
    if (cardModels[i].score > 0) --cardModels[i].score;
    notifyListeners();
  }

  void addScore(CardModel model) async {
    int i = cardModels.indexOf(model);
    ++cardModels[i].score;
    notifyListeners();
  }

  addToCardModelsList(CardModel model) {
    cardModels.add(model);
    notifyListeners();
  }
}
