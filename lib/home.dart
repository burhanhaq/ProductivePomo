import 'package:flutter/material.dart';

import 'constants.dart';
import 'countdown_timer.dart';
import 'models/card_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<CardModel> cardModels = [
    CardModel(text: 'Work', type: CardType.Session),
    CardModel(text: 'Flutter', type: CardType.Session),
    CardModel(text: 'Quran', type: CardType.Session),
    CardModel(text: 'Water', type: CardType.Counter),
    CardModel(text: 'Exercise', type: CardType.Counter),
    CardModel(text: 'Food', type: CardType.Counter),
  ];
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    IconData buttonIcon = Icons.play_arrow;
    var buttonText = "Start";

    return SafeArea(
      child: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(cardModels.length, (index) {
                  return CustomCard(title: cardModels[index].text);
                }),
              ),
            ),
            Container(
              color: Color(0xFF141414),
              child: SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0.0, 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Icon(buttonIcon),
                                    SizedBox(width: 8.0),
                                    Text(buttonText,
                                        style: TextStyle(fontSize: 20.0)),
                                  ],
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  print('Button pressed');
                                  setState(() {
                                    if (controller.isAnimating) {
                                      controller.stop();
                                      buttonIcon = Icons.pause;
                                      buttonText = 'Pause';
                                    } else {
                                      controller.reverse(
                                          from: controller.value == 0.0
                                              ? 1.0
                                              : controller.value);
                                      buttonIcon = Icons.play_arrow;
                                      buttonText = 'Play';
                                    }
                                  });
                                },
                              );
                            },
                          ),
//                        Text('Two'),
//                        Text('Two'),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-0, -80),
                      child: Container(
                        height: 150,
                        width: 150,
//                        color: Colors.white,
                        child: CountdownTimer(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String title;
  CustomCard({@required this.title});
  @override
  _CustomCardState createState() => _CustomCardState();
}

enum Position { None, Left, Right }

class _CustomCardState extends State<CustomCard> {
  int count = 0;
  Position pos = Position.None;
  @override
  Widget build(BuildContext context) {
    final boxWidth = MediaQuery.of(context).size.width / 2 - 30;
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.primaryDelta < 0)
          pos = Position.Left;
        else
          pos = Position.Right;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        setState(() {
          if (pos == Position.Left) if (count > 0) count--;
        });
      },
      onTap: () {
        setState(() {
          count++;
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        margin: EdgeInsets.all(10.0),
        width: boxWidth,
        height: boxWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(widget.title, style: kLabel),
            SizedBox(height: 15),
            Text(count.toString(), style: kLabel.copyWith(fontSize: 40)),
            Expanded(
              child: Text(''),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Theme.of(context).primaryColor,
                  child: IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 60,
                      onPressed: () {
                        setState(() {
                          count++;
                        });
                      },
                      color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
