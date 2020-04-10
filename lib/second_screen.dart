import 'package:flutter/material.dart';

import 'constants.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Container(
          color: blue,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(color: grey),
              Container(
                decoration: BoxDecoration(
                  color: red2,
                  borderRadius: BorderRadius.only(
//                    topRight: Radius.circular(50),
//                    bottomRight: Radius.circular(50),
//                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(100),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Flutter Dev',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          color: red3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40)),
//                          shape: BoxShape.circle,
//                                      color: Colors.white,
                        ),
                        child: Transform.translate(
                          offset: Offset(-5, 5),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Container(height: 10, width: 80, color: Colors.white),
                    Text(
                      '0',
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
      ],
    ));
  }
}
