import 'package:flutter/material.dart';
import 'dart:core';

String timeNow =
    '${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

const kLabel = TextStyle(
  color: Colors.black,
  fontSize: 25,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
  letterSpacing: 1.0,
);

const kScore = TextStyle(
  color: Colors.black,
  fontSize: 30,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
  letterSpacing: 1.0,
);

const kOnboardingStyle = TextStyle(
  color: yellow,
  fontSize: 60,
  fontWeight: FontWeight.w100,
  decoration: TextDecoration.none,
);

// not a constant
var kSliderThemeData = SliderThemeData(
  valueIndicatorTextStyle:
      TextStyle(fontSize: 22, color: red1, fontWeight: FontWeight.w500),
  inactiveTrackColor: red12,
  activeTrackColor: yellow,
  activeTickMarkColor: yellow,
  inactiveTickMarkColor: yellow,
  thumbColor: yellow,
  valueIndicatorColor: yellow,
  overlayColor: yellow.withOpacity(0.1),
);

const kAddNewSectionTextStyle = TextStyle(
  color: yellow,
  fontSize: 50,
  fontWeight: FontWeight.w100,
);

const kLong = 60.0;
const kShort = 15.0;
const kRotOffset = kShort / 2;

const kBoxDim = 30.0;
const kBoxColor = white;

const double kEndSpacing = 30.0;
const Color grey = Color(0xff343437);
const Color grey2 = Color(0xff1F1F21);
const Color yellow = Color(0xffF7CE47);
const Color yellow2 = Color(0xffE2BD42);
const Color red1 = Color(0xffA83535);
const Color red12 = Color(0xff872929);
const Color red2 = Color(0xff610404);
const Color red3 = Color(0xff400303);
const Color blue = Colors.blue;
const Color white = Colors.white;
const Color trans = Colors.transparent;
const Color pink = Color(0xff85203b);
const Color orange = Color(0xffff9f68);

// Home Screen Screen Size Multiplier Constants
const kHomeRightBarClosedMul = 0.2;
const kHomeRightBarOpenMul = 0.48;
const kHomeYellowDividerMul = 0.02;
const kGreyAreaMul = 0.78;
const kAddNewSectionMul = 0.73;

// Analytics Section
const kMonthsTextStyle = TextStyle(fontSize: 40, color: white);
var kBlueBorder = BoxDecoration(
  // not constant
  border: Border.all(
    color: blue,
    width: 1,
  ),
);

var dayList = List.generate(31, (index) => index + 1);
var monthList = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
var yearList = [2019, 2020, 2021, 2022];

enum DisplayChartItemType { ScoreOverGoal, MaxScore }

// Second Screen Constants
const kMainRadius = 40.0;
const kSecondaryRadius = 15.0;
