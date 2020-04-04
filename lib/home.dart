import 'package:flutter/material.dart';

import 'constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> x = ['Work', 'Flutter', 'Water', 'Food'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: Theme.of(context).accentColor,
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(x.length, (index) {
              return CustomCard(title: x[index]);
            }),
          )
//        child: Wrap(
////          spacing: 10.0,
//          runSpacing: 18.0,
//          direction: Axis.horizontal,
//          alignment: WrapAlignment.spaceEvenly,
////          crossAxisAlignment: WrapCrossAlignment.end,
//          children: <Widget>[
//            Card(),
//            Card(),
//            Card(),
//            Card(),
//            Card(),
//            Card(),
//            Card(),
//          ],
//        ),
          ),
    );
  }
}

class SomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Text('fdsa', style: kLabel),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String title;
  CustomCard({@required this.title});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final boxWidth = MediaQuery.of(context).size.width / 2 - 30;
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        setState(() {
          if (count > 0) count--;
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
//        boxShadow: [
//          BoxShadow(
//            color: Colors.white,
//            blurRadius: 2.0,
//            spreadRadius: 0,
//            offset: Offset(2.0, 2.0),
//          )
//        ],
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
