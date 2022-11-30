import 'size_fit.dart';

extension DoubleFit on double {
  double get px => SizeFit.setPx(this);

  double get rpx => SizeFit.setRpx(this);
}

extension StringExtension on String? {
  double toDouble([int def = 0]) => double.parse(this??"$def");
  int toInt([int def = 0]) => int.parse(this??"$def");
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
