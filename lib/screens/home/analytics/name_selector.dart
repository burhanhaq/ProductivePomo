import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../database_helper.dart';
import '../../../widgets/loading_indicator.dart';

class NameSelectorWidget extends StatefulWidget {
  @override
  _NameSelectorWidgetState createState() => _NameSelectorWidgetState();
}

class _NameSelectorWidgetState extends State<NameSelectorWidget> {
  List<bool> selectedList = [];

  Future<List<Map<String, dynamic>>> getModelNames() async {
    List<Map<String, dynamic>> namesMap = await DB.instance.queryModelNames();
    if (selectedList.length == 0) {
      selectedList = List.generate(namesMap.length, (index) => false);
    }
    return namesMap;
  }

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: getModelNames(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator(
            showLoadingIndicator: true,
            rotationsToDisableAfter: 2,
          );
        }
        List<String> namesList = [];
        snapshot.data.forEach((element) {
          namesList.add(element['title']);
        });
        return SizedBox(
          height: sectionHeight * 0.3,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              RotatedBox(
                quarterTurns: 1,
                child: ToggleButtons(
                  isSelected: selectedList,
                  onPressed: (index) {
                    cardState.nameX = namesList[index];
                    for (int k = 0; k < selectedList.length; k++) {
                      selectedList[k] = k == index ? true : false;
                    }
                  },
                  renderBorder: false,
                  fillColor: trans,
                  splashColor: trans,
                  children: List.generate(
                    namesList.length,
                    (index) => RotatedBox(
                        quarterTurns: -1,
                        child: Container(
                          width: sectionWidth,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: selectedList[index]
                                ? grey2.withOpacity(0.5)
                                : trans,
                          ),
                          child: Text(namesList[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: selectedList[index] ? yellow : white,
                              )),
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
