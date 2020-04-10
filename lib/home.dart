import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_bar.dart';
import 'constants.dart';
import 'custom_card.dart';
import 'second_screen.dart';

class Home extends StatefulWidget {
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
      child: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    children: List.generate(cardModels.length, (index) {
                      return CustomCard(
                        title: cardModels[index].text,
                        otherController: controller,
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Transform.translate(
                      offset: Offset(
                          MediaQuery.of(context).size.width * 0.75 * 0, 0.0),
                      child: SecondScreen(),
                    ),
                  ),
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
