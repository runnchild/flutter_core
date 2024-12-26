import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';


extension SizeBoxKt on num {
  Widget get width => SizedBox(width: toInt().pt);

  Widget get height => SizedBox(height: toInt().pt);

  Widget vertical({Color? color, EdgeInsets? padding, double? thickness}) =>
      Container(
        height: toInt().pt,
        width: thickness ?? 1,
        color: color,
        margin: padding,
      );

  Widget horizontal({Color? color, EdgeInsets? padding, double? thickness}) =>
      Container(
        width: toInt().pt,
        height: thickness ?? 1,
        color: color,
        margin: padding,
      );
}
