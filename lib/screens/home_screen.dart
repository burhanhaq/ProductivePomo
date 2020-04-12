import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/card_tile.dart';
import '../card_state.dart';
import '../models/card_model.dart';

class Home extends StatefulWidget {
  static final id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool addNewScreen = false;

  List<CardTile> thisList;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    thisList = List.generate(CardModel.cardModelsX.length, (index) {
      return CardTile(cardModel: CardModel.cardModelsX[index]);
    });

    return SafeArea(
      child: Material(
        child: ChangeNotifierProvider(
          create: (context) => CardState()..init(),
          child: Consumer<CardState>(
            builder: (context, cardState, _) => Container(
              color: Theme.of(context).accentColor,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        ListView(
                          physics: BouncingScrollPhysics(),
                          children: thisList,
                        ),
                        Container(
                          height: double.infinity,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: yellow,
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Offstage(
                            offstage: !addNewScreen,
                            child: AddNew(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: red1,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Offstage(
                            offstage:
                                cardState.currentIndex == null ? true : false,
                            child: Column(
                              children: [
                                Text(
                                  // todo: need to update this when we get back from SecondScreen
                                  cardState.firstPageScore == null ? 'x' : cardState.firstPageScore.toString() ,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Container(height: 10, width: 80, color: yellow),
                                Text(
                                  cardState.firstPageGoal == null ? 'y' :cardState.firstPageGoal.toString(),
                                  style: TextStyle(
                                    color: yellow,
                                    fontSize: 50,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          Transform.translate(
//                            offset: Offset(0, 100),
                            offset: Offset(0, 0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (addNewScreen) {
                                      cardState.newTitle = '';
                                      cardState.newScore = '';
                                      cardState.newGoal = '';
                                      cardState.newMinutes = '10';
                                      cardState.newScore = '10';
                                      setState(() {
                                        addNewScreen = !addNewScreen;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 80,
                                    color: yellow,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (addNewScreen) {
                                        if (cardState.newTitle.isNotEmpty) {
                                          CardModel.cardModelsX.add(
                                            CardModel(
                                              index: cardState.length,
                                              title: cardState.newTitle,
                                              score: int.tryParse(
                                                      cardState.newScore) == null ? '-2' : int.tryParse(
                                                  cardState.newScore),
                                              goal: int.tryParse(
                                                      cardState.newGoal) == null ? '-2' : int.tryParse(
                                                  cardState.newGoal),
                                              duration: Duration(minutes: 2),
                                            ),
                                          );
                                          thisList.add(CardTile(
                                              cardModel: cardState
                                                  .at(cardState.length - 1)));
                                          addNewScreen = !addNewScreen;
                                        }
                                      }
                                    });
                                  },
                                  child: Offstage(
                                    offstage: !addNewScreen,
                                    child: Icon(
                                      Icons.check_box,
                                      size: 80,
                                      color: yellow,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  // todo: add new CardModel
                                  onTap: () {
                                    setState(() {
                                      if (!addNewScreen) addNewScreen = true;
                                    });
                                  },
                                  child: Offstage(
                                    offstage: addNewScreen,
                                    child: Icon(
                                      Icons.add_box,
                                      size: 80,
                                      color: yellow,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}

class AddNew extends StatefulWidget {
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  @override
  Widget build(BuildContext context) {
    var cardState = Provider.of<CardState>(context);
    var minutesList = List.generate(
        13,
        (index) => DropdownMenuItem(
            child: Text(
                index == 0 || index == 1 ? '0${index * 5}' : '${index * 5}',
                style: TextStyle(fontSize: 30, color: yellow)),
            value: '${index * 5}'));
    var secondsList = List.generate(
        12,
        (index) => DropdownMenuItem(
            child: Text(
                index == 0 || index == 1 ? '0${index * 5}' : '${index * 5}',
                style: TextStyle(fontSize: 30, color: yellow)),
            value: '${index * 5}'));
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.72,
        color: red1,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 100),
          child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
            children: [
//            Expanded(child: Container()),
              TextField(
                style: TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: yellow),
                  hintText: 'Title',
                  fillColor: blue,
                ),
                onChanged: (value) {
                  setState(() {
                    cardState.newTitle = value;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                style: TextStyle(
                    color: white, fontSize: 30, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: yellow),
                  hintText: 'Score',
                  fillColor: blue,
                ),
                onChanged: (value) {
                  setState(() {
                    cardState.newScore = value;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                style: TextStyle(
                    color: white, fontSize: 30, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: yellow),
                  hintText: 'Goal',
                  fillColor: blue,
                ),
                onChanged: (value) {
                  setState(() {
                    cardState.newGoal = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Duration',
                      style: TextStyle(
                          color: yellow,
                          fontSize: 30,
                          fontWeight: FontWeight.w600)),
//                Expanded(child: Container()),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton(
                            icon: Icon(Icons.arrow_drop_down, size: 0),
                            dropdownColor: red1,
                            onChanged: (inputValue) {
                              setState(() {
                                cardState.newMinutes = inputValue;
                              });
                            },
                            value: cardState.newMinutes.toString(),
                            items: minutesList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(':',
                                style: TextStyle(
                                    color: yellow,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900)),
                          ),
                          DropdownButton(
                            icon: Icon(Icons.arrow_drop_down, size: 0),
                            dropdownColor: red1,
                            onChanged: (inputValue) {
                              setState(() {
                                cardState.newSeconds = inputValue;
                              });
                            },
                            value: cardState.newSeconds.toString(),
                            items: secondsList,
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
