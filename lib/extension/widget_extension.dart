import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget onTap(VoidCallback? onTap, {
    HitTestBehavior behavior = HitTestBehavior.translucent,
  }) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      child: this,
    );
  }

  Widget size({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  SizedBox width(double width) {
    double? height;
    if (this is SizedBox) {
      height = (this as SizedBox).height;
    }
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  SizedBox height(double height) {
    double? width;
    if (this is SizedBox) {
      width = (this as SizedBox).width;
    }
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget padding({double all = 0,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom}) {
    return Padding(
      padding: EdgeInsets.all(all).copyWith(
        left: horizontal ?? left,
        top: vertical ?? top,
        right: horizontal ?? right,
        bottom: vertical ?? bottom,
      ),
      child: this,
    );
  }

  Widget expanded([double? flex]) {
    return Expanded(
      flex: flex?.toInt() ?? 1,
      child: this,
    );
  }

  Widget positioned({double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height}) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  Widget align([AlignmentGeometry? alignment]) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: this,
    );
  }

  Widget safeArea({bool? top, bool? bottom, bool? left, bool? right}) {
    return SafeArea(
      top: top ?? true,
      bottom: bottom ?? true,
      left: left ?? true,
      right: right ?? true,
      child: this,
    );
  }

  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  Widget radius(double radius,
      {double? topLeft,
        double? topRight,
        double? bottomLeft,
        double? bottomRight}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius).copyWith(
        topLeft: Radius.circular(topLeft ?? radius),
        topRight: Radius.circular(topRight ?? radius),
        bottomLeft: Radius.circular(bottomLeft ?? radius),
        bottomRight: Radius.circular(bottomRight ?? radius),
      ),
      child: this,
    );
  }

  Widget backgroundColor(Color color) {
    return ColoredBox(
      color: color,
      child: this,
    );
  }

  Widget decoration({
    Color? color,
    BorderRadius? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? shadow,
    Gradient? gradient,
    DecorationImage? image,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
        boxShadow: shadow,
        gradient: gradient,
        image: image,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape ?? BoxShape.rectangle,
      ),
      child: this,
    );
  }
}

extension NotifierExt<T> on ValueNotifier<T> {
  Widget builder(Widget Function(T value, Widget? child) builder, {Widget? child}) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) {
        return builder(value, child);
      },
      child: child,
    );
  }
}