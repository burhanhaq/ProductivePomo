import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'clock.dart';
import 'constants.dart';
import 'custom_card.dart';
import 'second_screen.dart';
import 'card_state.dart';

class Home extends StatefulWidget {
  static final id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

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
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => CardState(),
        child: Consumer<CardState>(
          builder: (context, cardState, _) =>
          Container(
            color: Theme.of(context).accentColor,
        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.03,
                      color: Theme.of(context).primaryColor),
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: List.generate(cardState.cardModels.length, (index) {
                      return CustomCard(
//                        index: index,
                        index: cardState.cardModels[index].index,
                        title: cardState.cardModels[index].text,
                        score: cardState.cardModels[index].score,
                        goal: cardState.cardModels[index].goal,
                        duration: cardState.cardModels[index].duration,
//                        otherController: controller,
                      );
                    }),
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
                          '0'.toString(),
//                          score.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Container(height: 10, width: 80, color: Colors.white),
                        Text(
                          '10'.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
//                Expanded(child: Container()),
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: grey,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.stop),
                              iconSize: 60,
                              color: red1,
                              onPressed: () {
                                print('Stop pressed');
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.pause),
                              iconSize: 60,
                              color: red1,
                              onPressed: () {
                                print('Pause pressed');
                              },
                            ),
                            IconButton(
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
                          child: Icon(
                            Icons.remove,
                            size: 40,
                            color: white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
//            Container(
//              height: MediaQuery.of(context).size.height,
//              width: MediaQuery.of(context).size.width * 0.2,
//              color: grey,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  Icon(Icons.remove),
//                  Icon(Icons.add),
//                ],
//              ),
//            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
