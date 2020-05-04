import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/card_tile.dart';
import '../../card_state.dart';
import '../../models/card_model.dart';

import 'right_bar/right_bar.dart';
import 'add_new_card.dart';
import '../../database_helper.dart';
import '../../screens/home/analytics/analytics.dart';

class Home extends StatefulWidget {
  static final id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
//  SharedPref sharedPref = SharedPref();
  List<CardTile> cardTileList = [];
  bool loadingIndicator = true;
  AnimationController addSectionController;
  Animation addSectionAnimation;

  AnimationController loadingIndicatorController;
  Animation loadingIndicatorAnimation;
  AnimationStatus loadingIndicatorStatus = AnimationStatus.dismissed;
  int loadingIndicatorCount = 0;

  @override
  void initState() {
    super.initState();
    getCardListFromDB();

    addSectionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    addSectionAnimation = CurvedAnimation(
      parent: addSectionController,
      curve: Curves.easeOutBack,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {});
      });

    loadingIndicatorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    loadingIndicatorAnimation = CurvedAnimation(
      parent: loadingIndicatorController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {
          loadingIndicatorStatus = status;
        });
      });
    loadingIndicatorController.forward();
  }

  getCardListFromDB() async {
//    List<dynamic> prefCardModelList = await sharedPref.get();
    List<dynamic> cardModelListFromDB = await DB.instance.queryRecords();
    for (int i = 0; i < cardModelListFromDB.length; i++) {
      CardModel.cardModelsX.add(CardModel(
        // todo, just FYI, new additions have today's date
        title: cardModelListFromDB[i]['title'],
        score: cardModelListFromDB[i]['score'],
        goal: cardModelListFromDB[i]['goal'],
        minutes: cardModelListFromDB[i]['minutes'],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    cardTileList = List.generate(cardState.cardModels.length, (index) { // todo pull only for today, not alllll
      return CardTile(cardModel: cardState.cardModels[index]);
    });
    if (loadingIndicator) {
      if (cardTileList.length > 0 && cardTileList[0].cardModel.score >= 0) {
        loadingIndicator = false;
      }
    }
    if (cardState.onAddNewScreen) {
      addSectionController.forward();
    } else {
      addSectionController.reverse();
    }

    if (!loadingIndicatorController.isAnimating && loadingIndicator) {
      if (loadingIndicatorStatus == AnimationStatus.completed) {
        loadingIndicatorController.reverse();
        loadingIndicatorCount++;
        if (loadingIndicatorCount > 10) {
          loadingIndicator = false;
        }
      } else {
        loadingIndicatorController.forward();
        ++loadingIndicatorCount;
      }
    }

    return SafeArea(
      child: Material(
        child: Container(
          color: grey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      left:
                          MediaQuery.of(context).size.width * kGreyAreaMul / 2,
                      bottom: 30,
                      child: Offstage(
                        offstage: CardModel.cardModelsX.length > 1,
                        child: Text(
                          'Swipe Left',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white,
                            fontFamily: 'IndieFlower',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * kGreyAreaMul,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: grey,
//                          gradient: LinearGradient(
//                            colors: [grey2, grey],
//                            stops: [0.7, 1.0],
//                            begin: Alignment.topCenter,
//                            end: Alignment.bottomCenter,
//                          ),
                        ),
                        child: Text(
                          DateTime.now().toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white,
//                            fontFamily: 'IndieFlower',
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.08,
                      child: GestureDetector(
                        onTap: () => cardState.onTapEmptyAreaUnderListView(),
                        onHorizontalDragUpdate: (details) =>
                            cardState.onHorizontalDragUpdateRightBar(details),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.88,
                          width:
                              MediaQuery.of(context).size.width * kGreyAreaMul,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: cardTileList,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Transform.scale(
                        scale: loadingIndicator
                            ? 2 * loadingIndicatorAnimation.value
                            : 0,
                        child: Container(
                          // todo replace with light card or something with an opacity controller maybe
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Transform.translate(
                          offset: Offset(
                              -MediaQuery.of(context).size.width *
                                  (1 - addSectionAnimation.value) *
                                  kAddNewSectionMul,
                              0),
                          child: AddNewCard()),
                    ),
                    Positioned(
                      left: 0,
                      child: Offstage(
                        offstage: !cardState.showAnalytics,
                        child: Analytics(),
                      ),
                    ),
                  ],
                ),
              ),
              RightBar(
                cardTileList: cardTileList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addSectionController.dispose();
    loadingIndicatorController.dispose();
    super.dispose();
  }
}
