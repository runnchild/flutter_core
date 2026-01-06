import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final TextStyle? expandedTextStyle;
  final int maxLines;

  const ExpandableText(
      {super.key, required this.text, required this.textStyle, this.expandedTextStyle, this.maxLines = 3});

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
            builder: (context, isExpanded, child) =>
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isExpanded
                            ? text
                            : _getTruncatedTextWithEllipsis(
                            text, size.maxWidth),
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
    // 1. 定义样式
    final TextStyle style = widget.textStyle!;
    // 为"展开"预留的空间
    const double reservedWidth = 40.0;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: widget.maxLines,
    );

    // 使用总宽度进行布局
    textPainter.layout(maxWidth: maxWidth);

    // 如果超过了最大行数
    if (textPainter.didExceedMaxLines) {
      // 关键：获取在“总宽度 - 预留宽度”位置的字符索引
      // textPainter.height - 1 是为了确保坐标在最后一行内
      final position = textPainter.getPositionForOffset(
        Offset(maxWidth - reservedWidth, textPainter.height - 1),
      );

      final int endOffset = position.offset;

      // 根据索引截断
      if (endOffset > 0 && endOffset < text.length) {
        return "${text.substring(0, endOffset)}...";
      }
    }

    return text;
  }
}
