import 'package:flutter/material.dart';

import 'bottom_bar.dart';
import 'constants.dart';
import 'custom_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  IconData playIcon = Icons.play_arrow;
//  String buttonText = 'Play';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: PageView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      Container(
                          height: double.infinity,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: Theme.of(context).primaryColor),
                      ListView(
                        children: List.generate(cardModels.length, (index) {
//                  return (Container(
//                      height: 20, width: 300, color: Colors.orange));
                          return CustomCard(title: cardModels[index].text);
                        }),
                      ),
                    ],
                  ),
//                  Container(color: Theme.of(context).accentColor),
                ],
              ),
            ),
//            BottomBar(),
          ],
        ),
      ),
    );
  }
}
