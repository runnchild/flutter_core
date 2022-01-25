import 'dart:async';

const Duration _KDelay = Duration(milliseconds: 500);

class Throttle {
  var enable = true;

  Timer? timer;
  ///防止重复点击
  ///func 要执行的方法
  throttle(Function() func, {Duration delay = _KDelay}) async {
    if (enable) {
      print("playAudio=================$enable, $func");
      func.call();
      enable = false;
      timer?.cancel();
      timer = Timer(delay, () {
        enable = true;
      });
    }
  }
}
