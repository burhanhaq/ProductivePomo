import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/shared_pref.dart';
import 'package:provider/provider.dart';

import 'models/card_model.dart';
import 'widgets/card_tile.dart';
import 'screens/second_screen.dart';
import 'screen_navigation/second_screen_navigation.dart';
import 'database_helper.dart';

class CardState with ChangeNotifier {
  resetNewVariables() {
    _newTitle = '';
    _newGoal = '10';
    _newMinutes = '30';
    _newSeconds = '03';
    notifyListeners();
  }

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
  bool _tappedEmptyAreaUnderListView = false;

//  bool _isClearTitleTextEditingController = false;

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

  int get selectedIndex => _selectedIndex;

  bool get onAddNewScreen => _addNewScreen;

  int get confirmDeleteIndex => _confirmDeleteIndex;

  String get newTitle => _newTitle;

  String get newGoal => _newGoal;

  String get newMinutes => _newMinutes;

  String get newSeconds => _newSeconds;

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

  set onAddNewScreen(bool val) {
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

  set tappedEmptyAreaUnderListView(bool val) {
    _tappedEmptyAreaUnderListView = val;
    // don't add notifyListeners()
  }

  void onTapEmptyAreaUnderListView() {
    selectTile = null;
    closeHomeRightBar();
    tappedEmptyAreaUnderListView = true;
  }

  // RIGHT BAR 8888888888888888888888888888888888888888888888888888888888888
  bool _homeRightBarOpen = false;

  bool get homeRightBarOpen => _homeRightBarOpen;

  openHomeRightBar() {
    _homeRightBarOpen = true;
    notifyListeners();
  }

  closeHomeRightBar() {
    _homeRightBarOpen = false;
    notifyListeners();
  }

  onTapAddItemRightBar(
      var addNewIconController, var cancelIconScaleController) {
    if (!onAddNewScreen) {
      cancelIconScaleController.forward();
      onAddNewScreen = true;
      closeHomeRightBar();
      selectTile = null;
      addNewIconController.forward();
    }
  }

  onTapCancelRightBar(var addNewIconController, var cancelIconScaleController) {
    addNewIconController.reverse();
    cancelIconScaleController.reverse();
    if (onAddNewScreen) {
      resetNewVariables();
      onAddNewScreen = !onAddNewScreen;
    }
  }

  onTapDeleteItemRightBar() async {
    if (confirmDeleteIndex == selectedIndex) {
      // second tap
      CardModel modelToDelete = cardModels[selectedIndex];
//      if (modelToDelete.score == _maxScore) {
//        _maxScore = 0;
//        cardModels.forEach((element) {
//          if (element.score > maxScore) _maxScore = element.score;
//        });
//      }
      CardModel.cardModelsX.removeAt(selectedIndex);
      await DB.instance.deleteRecord(modelToDelete.title, modelToDelete.date);
      selectTile = null;
    } else {
      // first tap for confirmation
      confirmDeleteIndex = selectedIndex;
    }
  }

  onTapDeleteAllRightBar() async {
//    sharedPref.removeAll();
//    await DB.instance.recreateTable();
    clearCardModelsList();
  }

  bool canAddItem() {
    var keys = [];
    CardModel.cardModelsX.forEach((element) {
      keys.add(element.title.toLowerCase());
    });
    return onAddNewScreen &&
        newTitle.isNotEmpty &&
        !keys.contains(newTitle.toLowerCase());
  }

  onTapCheckBoxRightBar(var cardTileList, var addNewIconController,
      var cancelIconScaleController) async {
    bool canAddNewItem = canAddItem();
    if (canAddNewItem) {
      addNewIconController.reverse();
      cancelIconScaleController.reverse();
      var newItem = CardModel(
        title: newTitle,
        score: 0,
        goal: int.tryParse(newGoal) == null ? '777' : int.tryParse(newGoal),
        minutes: int.parse(newMinutes),
      );
      addToCardModelsList(newItem);
      cardTileList.add(CardTile(cardModel: newItem));
      onAddNewScreen = false;
      var added = await DB.instance.insertOrUpdateRecord(newItem.toJson());
      print('DB INSERT -- $added');
      resetNewVariables();
    } else {
      // todo play cant add animation maybe
      print('can not add');
    }
  }

  void onTapRightBar() {
    if (homeRightBarOpen) {
      closeHomeRightBar();
    } else {
      openHomeRightBar();
    }
  }

  void onHorizontalDragUpdateRightBar(var details) {
    if (details.delta.dx < 0) {
      openHomeRightBar();
    } else {
      closeHomeRightBar();
    }
  }

  // CARD TILE 8888888888888888888888888888888888888888888888888888888888888888

  void onTapCardTile(CardModel cardModel, var context) {
    closeHomeRightBar();
    if (cardModel.selected) {
      // tapped second time
      Navigator.push(
        context,
        SecondScreenNavigation(
          widget: SecondScreen(cardModel: cardModel),
        ),
      );
    }
    selectTile = cardModel;
  }

  void onHorizontalDragUpdateCardTile(
      var details, CardModel cardModel, var context, var cardScreenController) {
    if (details.primaryDelta < 0) {
      selectTile = cardModel;
      closeHomeRightBar();
      cardScreenController.forward(from: 0.0);
      Navigator.push(
        context,
        SecondScreenNavigation(
          widget: SecondScreen(cardModel: cardModel),
        ),
      );
    }
  }

  void onTapAddScore(CardModel cardModel) async {
    addScore(cardModel);
    await DB.instance.insertOrUpdateRecord(cardModel.toJson());
    _pageScore = cardModel.score;
//    if (cardModel.score > _maxScore) _maxScore = cardModel.score;
//    _maxScore = cardModel.score > _maxScore ? cardModel.score : maxScore;
    notifyListeners();
  }

  void onTapSubtractScore(CardModel cardModel) async {
//    _maxScore = cardModel.score == _maxScore ? --_maxScore : maxScore;
    subtractScore(cardModel);
    var scoreUpdate =
        await DB.instance.insertOrUpdateRecord(cardModel.toJson());
    print('DB UPDATE SUB SCORE -- $scoreUpdate');
    _pageScore = cardModel.score;
    notifyListeners();
  }

  // ANALYTICS 88888888888888888888888888888888888888888888888888888888888888888

  bool _showAnalytics = true;

  get showAnalytics => _showAnalytics;

  set showAnalytics(bool val) {
    _showAnalytics = val;
    notifyListeners();
  }

//  int _maxScore = 0;
//
//  get maxScore => _maxScore;
//
//  set maxScore(int val) {
//    _maxScore = val;
//    notifyListeners();
//  }

  // SECOND SCREEN 8888888888888888888888888888888888888888888888888888888888888
  void onTapReplaySecond(var timerDurationController,
      var playPauseIconController, var replayIconRotationController) {
    timerDurationController.value = 0.0;
    playPauseIconController.reverse();
    replayIconRotationController.reverse(from: 1.0);
  }

  void onTapPlaySecond(
      var playPauseIconController, var timerDurationController) {
    if (playPauseIconController.status == AnimationStatus.dismissed) {
      // play pressed
      timerDurationController.forward();
      playPauseIconController.forward();
    } else {
      // pause pressed
      timerDurationController.stop();
      playPauseIconController.reverse();
    }
  }

  // RANDOM

  clearCardModelsList() {
    cardModels.clear();
    notifyListeners();
  }

  void subtractScore(CardModel model) {
    int i = cardModels.indexOf(model);
    if (cardModels[i].score > 0) --cardModels[i].score;
  }

  void addScore(CardModel model) async {
    int i = cardModels.indexOf(model);
    ++cardModels[i].score;
  }

  addToCardModelsList(CardModel model) {
    cardModels.add(model);
    notifyListeners();
  }
}
