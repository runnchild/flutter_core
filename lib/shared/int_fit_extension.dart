import 'size_fit.dart';

extension IntFit on int? {
  double get pt => SizeFit.setPx(this?.toDouble() ?? 0);

  double get rpx => SizeFit.setRpx(this?.toDouble() ?? 0);

  toBool() => this == 1;

  repeat(Function(int) call) {
    var size = this ?? 0;
    for (var i = 0; i < size; i++) {
      call(i);
    }
  }

  List<R> repeatMap<R>(R Function(int) call) {
    var list = <R>[];
    var size = this ?? 0;
    for (var i = 0; i < size; i++) {
      list.add(call(i));
    }
    return list;
  }
}
