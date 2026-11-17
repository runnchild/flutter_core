import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';

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

/// 防止异步操作重复点击的 Mixin，实例级别，不会与其他页面互相干扰
///
/// 用法：
///   class _MyPageState extends State<MyPage> with SubmitGuardMixin<MyPage> {
///     // 在 CommonButton.enabled 中使用
///     enabled: !isSubmitting && ...,
///     // 在 onTap 中使用
///     onTap: submitGuard(() async { ... }),
///   }
mixin SubmitGuardMixin<T extends StatefulWidget> on State<T> {
  bool _isSubmitting = false;

  /// 当前是否正在提交中
  bool get isSubmitting => _isSubmitting;

  /// 包装一个异步函数，防止重复调用
  /// 自动管理 [_isSubmitting] 状态并刷新 UI
  VoidCallback submitGuard(Future Function() func) {
    return () async {
      if (_isSubmitting) return;
      _isSubmitting = true;
      setState(() {});
      try {
        await func();
      } finally {
        _isSubmitting = false;
        if (mounted) setState(() {});
      }
    };
  }
}