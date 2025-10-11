import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  TextStyle setColor(Color? color) => copyWith(color: color);

  TextStyle setFontSize(double size) => copyWith(fontSize: size);
}

extension TextExtension on Text {
  Text _copyWith({TextStyle? style, int? maxLines}) {
    return Text(
      data ?? '',
      key: key,
      style: style ?? this.style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  TextStyle get _style => style ?? TextStyle();

  Text fontSize(double size) {
    return _copyWith(style: _style.setFontSize(size));
  }

  Text bold() {
    return _copyWith(style: _style.bold);
  }

  Text w500() {
    return _copyWith(style: _style.w500);
  }

  Text w600() {
    return _copyWith(style: _style.w600);
  }

  Text italic() {
    return _copyWith(style: _style.italic);
  }

  Text underline() {
    return _copyWith(style: _style.underline);
  }

  Text lineThrough() {
    return _copyWith(style: _style.lineThrough);
  }

  Text color(Color? color) {
    return _copyWith(style: _style.setColor(color));
  }

  Text ellipsis() {
    return _copyWith(style: _style.copyWith(overflow: TextOverflow.ellipsis));
  }

  Text maxLines(int maxLines) {
    return _copyWith(maxLines: maxLines);
  }
}
