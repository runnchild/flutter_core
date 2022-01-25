import 'size_fit.dart';

extension DoubleFit on double {
  double get px => SizeFit.setPx(this);

  double get rpx => SizeFit.setRpx(this);
}

extension StringExtension on String {
  double toDouble() => double.parse(this);
  int toInt() => int.parse(this);
}
