import 'dart:ui';

import 'package:flutter/cupertino.dart';

class SizeFit {
  static double physicalWidth = 0;
  static double physicalHeight = 0;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double dpr = 0;
  static double statusHeight = 0;

  static double rpx = 0;
  static double px = 0;
  static double ratio = 0;

  static void initialize({BuildContext? context, double standardSize = 750}) {
    FlutterView display;
    if (context == null) {
      display = window;
    } else {
      display = View.of(context);
    }
    physicalWidth = display.physicalSize.width;
    physicalHeight = display.physicalSize.height;

    dpr = display.devicePixelRatio;

    screenWidth = physicalWidth / dpr;
    screenHeight = physicalHeight / dpr;

    statusHeight = display.padding.top / dpr;

    ratio = screenWidth / screenHeight;

    rpx = screenWidth / standardSize;
    px = screenWidth / standardSize * 2;
    debugPrint("SizeFit.initialize(); rpx:$rpx, px:$px, ratio=$ratio");
  }

  static isLongScreen() {
    return ratio < 0.56;
  }

  static double setRpx(double size) {
    return (rpx == 0 ? 1 : rpx) * size;
  }

  static double setPx(double size) {
    return (px == 0 ? 1 : px) * size;
  }
}
