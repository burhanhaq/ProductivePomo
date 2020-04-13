import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/card_tile.dart';
import '../card_state.dart';
import '../models/card_model.dart';
import '../shared_pref.dart';

class Home extends StatefulWidget {
  static final id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool addNewScreen = false;
  bool deleteCardScreen = false;
  SharedPref sharedPref = SharedPref();

//  List<CardModel> cardModelList = [];
  List<CardTile> cardTileList = [];

  @override
  void initState() {
    super.initState();
    getCardListFromJson();

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

  getCardListFromJson() async { // todo add circular bar for waiting for await
    // List<CardModel>
    print('vv');
    List<dynamic> prefCardModelList = await sharedPref.get();
    for (int i = 0; i < prefCardModelList.length; i++) {
      CardModel.cardModelsX.add(CardModel(
        index: i,
        title: prefCardModelList[i]['title'],
        score: prefCardModelList[i]['score'],
        goal: prefCardModelList[i]['goal'],
        minutes: prefCardModelList[i]['minutes'],
        seconds: prefCardModelList[i]['seconds'],
      ));
      print(CardModel.cardModelsX[i].toString());
    }
    print('^^');
  }

  @override
  Widget build(BuildContext context) {
    cardTileList = List.generate(CardModel.cardModelsX.length, (index) {
      return CardTile(cardModel: CardModel.cardModelsX[index]);
    });

    return SafeArea(
      child: Material(
        child: Scaffold(
          body: ChangeNotifierProvider(
            create: (context) => CardState(),
            child: Consumer<CardState>(
              builder: (context, cardState, _) => Container(
                color: Theme.of(context).accentColor,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              cardState.currentIndex = -1;
                            },
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: cardTileList,
                            ),
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
                              child: AddNewCardSection(),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Offstage(
                              offstage: !deleteCardScreen,
                              child: DeleteCardSection(),
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
                                    cardState.firstPageScore == null
                                        ? 'x'
                                        : cardState.firstPageScore.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Container(
                                      height: 10, width: 80, color: yellow),
                                  Text(
                                    cardState.firstPageGoal == null
                                        ? 'y'
                                        : cardState.firstPageGoal.toString(),
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
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      print('--------------');
//                                      for (int i = 0; i < CardModel.cardModelsX.length; i++) {
//                                      }
                                      print(
                                          'cardModelsX: ${CardModel.cardModelsX.toString()}');

                                      print('--------------');
                                    });
                                  },
                                  child: Icon(
                                    Icons.grain,
                                    size: 80,
                                    color: yellow,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sharedPref.removeAll();
                                      CardModel.cardModelsX.clear();
                                    });
                                  },
                                  child: Icon(
                                    Icons.do_not_disturb_on,
                                    size: 80,
                                    color: yellow,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // todo implement clearing text fields when hit
                                    setState(() {
                                      if (addNewScreen) {
                                        cardState.newTitle = '';
                                        cardState.newGoal = '';
                                        cardState.newMinutes = '10';
                                        cardState.newSeconds = '10';
                                        addNewScreen = !addNewScreen;
                                      } else if (!deleteCardScreen) {
                                        // todo implement delete card mode
//                                        if (!deleteCardScreen)
                                        deleteCardScreen = !deleteCardScreen;
                                      } else if (deleteCardScreen) {
                                        deleteCardScreen = !deleteCardScreen;
                                        sharedPref
                                            .remove(cardState.deleteTitle);
//                                        CardModel.cardModelsX.removeAt(index); // todo need to update index when removed
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 80,
                                    color: yellow,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // todo implement clearing text fields when hit
                                    // todo save to pref when added
                                    // todo add some initial goal value if null, or maybe make it a number drop down
                                    var keys = await sharedPref
                                        .getKeys(); // todo check if this works to avoid duplicate
                                    setState(() {
                                      print('await check ${keys.toString()}');
                                      bool canAddNewScreen = addNewScreen &&
                                          cardState.newTitle.isNotEmpty &&
                                          !keys.contains(cardState.newTitle);
                                      if (canAddNewScreen) {
                                        CardModel.cardModelsX.add(
                                          CardModel(
                                            index: cardState.length,
                                            title: cardState.newTitle,
                                            score: 0,
                                            goal: int.tryParse(
                                                        cardState.newGoal) ==
                                                    null
                                                ? '-2'
                                                : int.tryParse(
                                                    cardState.newGoal),
                                            minutes:
                                                int.parse(cardState.newMinutes),
                                            seconds:
                                                int.parse(cardState.newSeconds),
                                          ),
                                        );
                                        cardTileList.add(CardTile(
                                            cardModel: cardState
                                                .at(cardState.length - 1)));
                                        addNewScreen = !addNewScreen;
                                        print(CardModel.cardModelsX.toString());
                                        sharedPref.save(
                                            cardState.newTitle,
                                            cardState
                                                .at(cardState.length - 1)
                                                .toJson());
                                      } else {
                                        print('Not added');
                                        print(
                                            'Tried to add title ${cardState.newTitle}');
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
      ),
    );
  }
}

class DeleteCardSection extends StatefulWidget {
  @override
  _DeleteCardSectionState createState() => _DeleteCardSectionState();
}

class _DeleteCardSectionState extends State<DeleteCardSection> {
  @override
  Widget build(BuildContext context) {
    var cardState = Provider.of<CardState>(context);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.72,
        color: red1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: TextStyle(
                  color: white, fontSize: 30, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: yellow),
                hintText: 'Name to delete',
                fillColor: blue,
              ),
              onChanged: (value) {
                setState(() {
                  cardState.deleteTitle = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddNewCardSection extends StatefulWidget {
  @override
  _AddNewCardSectionState createState() => _AddNewCardSectionState();
}

class _AddNewCardSectionState extends State<AddNewCardSection> {
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
    //FocusScope.of(context).requestFocus(new FocusNode());
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.72,
        color: red1,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//              Text('Title', style: TextStyle(color: yellow, fontSize: 100)),
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
