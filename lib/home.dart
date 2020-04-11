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
//                      ListView(
//                        children: cardState.cardModels,
//                      ),
                      ListView(
                        physics: BouncingScrollPhysics(),
                        children: List.generate(cardState.length, (index) {
                          return CustomCard(
                            index: index,
                            title: cardState.at(index).text,
                            score: cardState.at(index).score,
                            goal: cardState.at(index).goal,
                            duration: cardState.at(index).duration,
                            selected: cardState.at(index).selected,
                          );
                        }),
                      ),
                      Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.03,
                        color: yellow,
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
                        Column(
                          children: [
                            Text(
                              cardState.firstPageScore.toString() ?? 'x',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(height: 10, width: 80, color: yellow),
                            Text(
                              cardState.firstPageGoal.toString() ?? 'y',
                              style: TextStyle(
                                color: yellow,
                                fontSize: 50,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () { //TODO: Implement adding new CardModel
                            print('Need to implement adding new CardModel');
                          },
                          child: Icon(
                            Icons.add_box,
                            size: 80,
                            color: yellow,
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
    );
  }
}
