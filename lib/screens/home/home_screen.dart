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
import '../../widgets/loading_indicator.dart';

class Home extends StatefulWidget {
  static final id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

List<CardTile> cardTileList = [];

class _HomeState extends State<Home> with TickerProviderStateMixin {
//  bool loadingIndicator = true;
  AnimationController addSectionController;
  Animation addSectionAnimation;

  @override
  void initState() {
    super.initState();

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
  }

  Future<List<CardModel>> getCardListFromDB() async {
    List<dynamic> cardModelListFromDB =
        await DB.instance.queryModelsToday(timeNow);
    for (int i = 0; i < cardModelListFromDB.length; i++) {
      var newCardModel = CardModel.fromJson(cardModelListFromDB[i]);
      if (!CardModel.cardModelsX.contains(newCardModel))
        CardModel.cardModelsX.add(newCardModel);
    }
    return CardModel.cardModelsX; // todo not an amazing implementation
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
//    if (loadingIndicator) {
//      if (cardTileList.length > 0) {
//        setState(() {
//          loadingIndicator = false;
//        });
//      }
//    }
    if (cardState.onAddNewScreen) {
      addSectionController.forward();
    } else {
      addSectionController.reverse();
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
                        offstage: cardTileList.length > 1,
                        // todo state doesn't update
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
                          child: FutureBuilder(
                              future: getCardListFromDB(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return LoadingIndicator(
                                    showLoadingIndicator: true,
                                    rotationsToDisableAfter: 2,
                                  );
                                }
//                                loadingIndicator = false;
                                cardTileList = List.generate(
                                    snapshot.data.length, (index) {
                                  return CardTile(
                                      cardModel: snapshot.data[index]);
                                });
                                return ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: cardTileList,
                                );
                              }),
                        ),
                      ),
                    ),
//                    Positioned(
//                      top: 150,
//                      left: 0,
//                      right: 0,
//                      child: LoadingIndicator(
//                        // state doesn't update
//                        showLoadingIndicator: loadingIndicator,
//                        rotationsToDisableAfter: 2,
//                      ),
//                    ),
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
    super.dispose();
  }
}
