import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'widgets/clock.dart';
import 'card_state.dart';
import 'widgets/card_tile.dart';
import 'shared_pref.dart';
import 'models/card_model.dart';

class SecondScreen extends StatefulWidget {
  static final id = 'SecondScreen';
  final CardTile cardTile;

  SecondScreen({@required this.cardTile});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  SharedPref sharedPref = SharedPref();

//  CardModel prefCardData;
  String prefTitle;
  int prefScore;
  int prefGoal;

  loadSharedPrefs() async {
    try {
      CardModel model = CardModel.fromJson(
          await sharedPref.read(widget.cardTile.cardModel.title));
      setState(() {
        prefTitle = model.title;
        prefScore = model.score;
        prefGoal = model.score;
      });
    } catch (Exception) {
      print('Exception in SecondScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();
    int index = widget.cardTile.cardModel.index;
    Duration duration = widget.cardTile.cardModel.duration;
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => CardState(),
        child: Consumer<CardState>(
          builder: (context, cardState, _) => Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(color: grey),
                      Container(
                        decoration: BoxDecoration(
                          color: grey,
                          border: Border.all(
                            width: 3,
                            color: yellow,
                          ),
                          borderRadius: BorderRadius.only(
//                    topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    prefTitle == null
                                        ? 'null'
                                        : prefTitle.toUpperCase(),
                                    textAlign: TextAlign.end,
                                    maxLines: 2,
                                    style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 35,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.41,
                                height:
                                    MediaQuery.of(context).size.width * 0.41,
                                decoration: BoxDecoration(
                                  color: red1,
                                  shape: BoxShape.circle,
                                ),
                                child: Clock(duration: duration),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 40,
                                    color: yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: grey,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              prefScore == null
                                  ? '-3'
                                  : cardState.at(index).score.toString(),
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 50,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(height: 5, width: 80, color: white),
                            Text(
                              prefGoal == null
                                  ? '-3'
                                  : cardState.at(index).goal.toString(),
                              style: TextStyle(
                                color: white,
                                fontSize: 50,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        Material(
                          child: Container(
                            decoration: BoxDecoration(
                              color: grey,
                              border: Border.all(
                                color: yellow,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  // todo: program it to be disabled if at 0 I guess
                                  icon: Icon(Icons.stop),
                                  iconSize: 60,
                                  color: red1,
                                  onPressed: () {
                                    print('Stop pressed');
                                  },
                                ),
                                IconButton(
                                  // todo: program it to be enabled after clock starts, and then disabled
                                  icon: Icon(Icons.pause),
                                  iconSize: 60,
                                  color: red1,
                                  onPressed: () {
                                    print('Pause pressed');
                                  },
                                ),
                                IconButton(
                                  // todo: program it to start clock and disable itself
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 60,
                                  color: red1,
                                  onPressed: () {
                                    print('Play pressed');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
//                SizedBox(height: 30),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  // todo implement delete
                                  cardState.subtract(index);
                                  sharedPref.save(
                                      widget.cardTile.cardModel.title,
                                      cardState.at(index).toJson());
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 40,
                                  color: yellow,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  // todo: implement add
                                  cardState.add(index);
                                  sharedPref.save(
                                      widget.cardTile.cardModel.title,
                                      cardState.at(index).toJson());
//                                  print('Cur json: ${cardState.at(index).toJson()}');
//                                  var s =  prefs.read('card');
//                                  s == null ? print('s is null') : print(s);

//                                var s = json.decode(cardState.at(0));
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
