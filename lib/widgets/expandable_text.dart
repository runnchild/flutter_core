import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? expandedTextStyle;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.textStyle, this.expandedTextStyle, this.maxLines = 3});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  String get text => widget.text;
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final TextSpan textSpan = TextSpan(
          text: text,
          style: widget.textStyle,
        );

        final TextPainter textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.maxLines,
        );
        textPainter.layout(maxWidth: size.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return ValueListenableBuilder<bool>(
            valueListenable: _isExpanded,
            builder: (context, isExpanded, child) => RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: isExpanded
                        ? text
                        : _getTruncatedTextWithEllipsis(text, size.maxWidth),
                    style: widget.textStyle,
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () {
                        _isExpanded.value = !_isExpanded.value;
                      },
                      child: Text(
                        isExpanded ? " 收起" : "展开",
                        style: widget.expandedTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text(text, style: widget.textStyle);
        }
      },
    );
  }

  String _getTruncatedTextWithEllipsis(String text, double maxWidth) {
    // 为"展开"预留空间，大约40像素
    final double availableWidth = maxWidth - 40;

    final TextSpan textSpan = TextSpan(
      text: text,
      style: widget.textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 3,
    );
    textPainter.layout(maxWidth: availableWidth);

    if (textPainter.didExceedMaxLines) {
      // 简单的方法：计算大约能显示的字符数
      const int avgCharWidth = 14; // 估算每个字符的宽度
      final int charsPerLine = (availableWidth / avgCharWidth).round();
      final int totalChars = charsPerLine * 3;

      if (text.length > totalChars) {
        return "${text.substring(0, totalChars - 3)}...";
      }
    }

    return text;
  }
}
