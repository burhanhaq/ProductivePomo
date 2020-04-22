import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/card_tile.dart';
import '../../card_state.dart';
import '../../models/card_model.dart';
import '../../shared_pref.dart';

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

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
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
