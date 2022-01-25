import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  isActiveOr(Function(bool) block) {
    try {
      // 页面已经被退出，context.widget为空
      widget;
      block(true);
    } catch (e) {
      block(false);
    }
  }

  isActive(Function block) {
    try {
      // 页面已经被退出，context.widget为空
      widget;
      block();
    } catch (e) {
      //
    }
  }
}
