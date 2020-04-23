import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../card_state.dart';


class AddNewCard extends StatefulWidget {
  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  TextEditingController titleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cardState = Provider.of<CardState>(context);
//    if (cardState.isClearTitleTextEditingController) {
//      titleTextController.clear();
//      cardState.clearTitleTextEditingControllerSwitch();
//    }
    var sectionWidth = MediaQuery.of(context).size.width * kGreyAreaMul;
    var sectionHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          cardState.closeHomeRightBar();
        },
        child: Container(
          height: sectionHeight,
          width: sectionWidth,
          color: red1,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            child: Column(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: sectionHeight * 0.2,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text('Name', style: kAddNewSectionTextStyle),
                      ),
                    ),
                    TextField( // todo implement clear on hit
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: cardState.addNewScreen,
                      controller: titleTextController,
                      autofocus: false,
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: yellow),
                        focusColor: blue,
                      ),
                      onChanged: (value) {
                        setState(() {
                          cardState.newTitle = value;
                        });
                      },
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: sectionHeight * 0.6,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 20),child: Text('Duration (min)', style: kAddNewSectionTextStyle)),
                        SliderTheme(
                          data: kSliderThemeData,
                          child: Slider(
                            value: double.tryParse(cardState.newMinutes),
                            onChanged: (value) {
                              if (value != null)
                                cardState.newMinutes = value.round().toInt().toString();
                            },
                            divisions: 59,
                            label: cardState.newMinutes,
                            max: 60,
                            min: 1,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 20),child: Text('Goal', style: kAddNewSectionTextStyle)),
                        SliderTheme(
                          data: kSliderThemeData,
                          child: Slider(
                            value: double.tryParse(cardState.newGoal),
                            onChanged: (value) {
                              if (value != null)
                                cardState.newGoal = value.round().toInt().toString();
                            },
                            divisions: 29,
                            label: cardState.newGoal,
                            max: 30,
                            min: 1,
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
