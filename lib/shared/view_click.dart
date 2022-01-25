import 'dart:async';
import 'dart:ui';

Map<String, Timer> _funcDebounce = {};

VoidCallback? debounce(VoidCallback? func,
    [Duration delay = const Duration(milliseconds: 400)]) {
  if (func == null) {
    return func;
  }
  Timer? timer;
  return () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  };
}

Map<String, bool> _funcThrottle = {};

// Function()? throttle(Future Function()? func) {
//   if (func == null) {
//     return func;
//   }
//   return () {
//     String key = func.hashCode.toString();
//     bool _enable = _funcThrottle[key] ?? true;
//     print(key+":$_enable");
//     if (_enable) {
//       _funcThrottle[key] = false;
//       func().then((_) {
//         _funcThrottle[key] = false;
//       }).whenComplete(() {
//         _funcThrottle.remove(key);
//       });
//     }
//   };
// }

// VoidCallback? throttle(Future Function()? func) {
//   if (func == null) {
//     return func;
//   }
//   bool enable = true;
//   return () {
//     if (enable == true) {
//       enable = false;
//       func().then((value) {
//         enable = true;
//       });
//     }
//   };
// }
const Duration _KDelay = Duration(milliseconds: 500);
var enable = true;

///防止重复点击
///func 要执行的方法
VoidCallback throttle(Function? func, {
  Duration delay = _KDelay
}) {
  return () {
    if (enable) {
      func?.call();
      enable = false;
      Future.delayed(delay, () {
        enable = true;
      });
    }
  };
}

VoidCallback? throttleAsync(Future Function()? func)  {
  return () async {
    if (enable) {
      enable = false;
      await func?.call();
      enable = true;
    }
  };
}