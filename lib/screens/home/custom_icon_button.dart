import 'package:flutter/material.dart';

//import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../card_state.dart';

class CustomIconButton extends StatefulWidget {
  final String name;
  final IconData iconData;
  final bool offstage;
  final bool textOffstage;
  final Function func;
  final Color c;

  CustomIconButton({
    @required this.name,
    @required this.iconData,
    this.offstage = false,
    @required this.textOffstage,
    @required this.func,
    this.c = yellow,
  });

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  var someController;

  @override
  void initState() {
    super.initState();
    someController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    someController.forward();
  }

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    if (cardState.homeRightBarOpen)
      someController.forward(from: 0.0);

    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Offstage(
        offstage: widget.offstage,
        child: GestureDetector(
          onTap: () => widget.func(),
          child: Row(
            children: [
              Icon(
                widget.iconData,
                size: 60,
                color: widget.c,
              ),
              SizedBox(width: 8),
              Offstage(
                offstage: widget.textOffstage,
                child: SizeTransition(
                  sizeFactor: someController,
                  axis: Axis.horizontal,
                  axisAlignment: 1,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      color: yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
