import 'dart:ui';

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

  static void initialize({double standardSize = 750}) {
    physicalWidth = window.physicalSize.width;
    physicalHeight = window.physicalSize.height;

    dpr = window.devicePixelRatio;

    screenWidth = physicalWidth / dpr;
    screenHeight = physicalHeight / dpr;

    statusHeight = window.padding.top / dpr;

    ratio = screenWidth / screenHeight;

    if (isLongScreen()) {
      standardSize = 750;
    } else {
      standardSize = 900;
    }
    rpx = screenWidth / standardSize;
    px = screenWidth / standardSize * 2;
    print("SizeFit.initialize(); rpx:$rpx, px:$px, ratio=$ratio");
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
