import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../card_state.dart';

class SecondScreenNavigation extends PageRouteBuilder {
  final Widget widget;

  SecondScreenNavigation({@required this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context, Animation frontAnimation,
                Animation backAnimation, Widget childWidget) {
              frontAnimation = CurvedAnimation(
                  parent: frontAnimation, curve: Curves.easeOutBack);
//              return SlideTransition(
//                position: frontAnimation,
//                child: childWidget,
//              );

              return ScaleTransition(
                alignment: Alignment.topRight,
                scale: frontAnimation,
                child: childWidget,
              );
            },
            pageBuilder: (BuildContext context, Animation frontAnimation,
                Animation backAnimation) {
              return ChangeNotifierProvider(
                create: (context) => CardState(),
                child: widget,
              );
            });
}
