import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  /// The text to display.
  final String? text;

  /// The rich text to display. If [textSpan] is provided, [text] is ignored.
  final InlineSpan? textSpan;

  /// The maximum number of lines to show when collapsed.
  final int maxLines;

  /// The text to show for the expand button.
  final String expandText;

  /// The text to show for the collapse button.
  final String collapseText;

  /// The style for the main text.
  final TextStyle? style;

  /// The style for the expand/collapse buttons.
  final TextStyle? linkStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether to show the "..." ellipsis before the expand button.
  final bool showEllipsis;

  const ExpandableText({
    super.key,
    this.text,
    this.textSpan,
    this.maxLines = 3,
    this.expandText = '展开',
    this.collapseText = '收起',
    this.style,
    this.linkStyle,
    this.textAlign,
    this.textDirection,
    this.showEllipsis = true,
  }) : assert(text != null || textSpan != null);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final linkStyle = widget.linkStyle ??
        effectiveTextStyle?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        );

    final InlineSpan contentSpan = widget.textSpan ??
        TextSpan(text: widget.text, style: effectiveTextStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // 1. Check if text exceeds maxLines
        final textPainter = TextPainter(
          text: contentSpan,
          textAlign: widget.textAlign ?? TextAlign.start,
          textDirection: widget.textDirection ?? TextDirection.ltr,
          maxLines: widget.maxLines,
        );

        textPainter.layout(maxWidth: maxWidth);

        // For TextSpan with complex children, didExceedMaxLines is the most reliable check.
        final bool didExceed = textPainter.didExceedMaxLines;

        if (!didExceed) {
          return Text.rich(
            contentSpan,
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
          );
        }

        if (_expanded) {
          return Text.rich(
            TextSpan(
              children: [
                contentSpan,
                TextSpan(
                  text: ' ${widget.collapseText}',
                  style: linkStyle,
                  recognizer: _tapGestureRecognizer,
                ),
              ],
            ),
            textAlign: widget.textAlign ?? TextAlign.start,
            textDirection: widget.textDirection ?? TextDirection.ltr,
          );
        } else {
          // 2. Calculate truncation for collapsed state
          // Use non-breaking space \u00A0 to ensure "展开" stays with ellipsis
          final linkText =
              '${widget.showEllipsis ? '...\u00A0' : '\u00A0'}${widget.expandText}';
          final linkPainter = TextPainter(
            text: TextSpan(text: linkText, style: linkStyle),
            textDirection: widget.textDirection ?? TextDirection.ltr,
          )..layout();

          final linkWidth = linkPainter.width;

          // Find the last line's end position
          final lineMetrics = textPainter.computeLineMetrics();
          if (lineMetrics.length < widget.maxLines) {
            // Fallback if line metrics are inconsistent with didExceedMaxLines
            return Text.rich(
              contentSpan,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
            );
          }
          final lastLine = lineMetrics[widget.maxLines - 1];

          // We want to find a point on the last line such that the remaining width
          // is at least linkWidth.
          final lastLineVerticalCenter = lastLine.baseline - lastLine.ascent + (lastLine.height / 2);

          // Use a slightly more conservative X offset to avoid edge cases
          final pos = textPainter.getPositionForOffset(Offset(
            maxWidth - linkWidth - 2.0,
            lastLineVerticalCenter,
          ));

          int endOffset = pos.offset;
          InlineSpan truncatedContent = _truncateSpan(contentSpan, endOffset);

          // Verification loop: if it still exceeds maxLines, back up offset
          bool fits = false;
          while (!fits && endOffset > 0) {
            final checkPainter = TextPainter(
              text: TextSpan(
                children: [
                  truncatedContent,
                  TextSpan(text: linkText, style: linkStyle),
                ],
              ),
              textAlign: widget.textAlign ?? TextAlign.start,
              textDirection: widget.textDirection ?? TextDirection.ltr,
              maxLines: widget.maxLines,
            );
            checkPainter.layout(maxWidth: maxWidth);

            if (checkPainter.didExceedMaxLines) {
              endOffset--;
              truncatedContent = _truncateSpan(contentSpan, endOffset);
            } else {
              fits = true;
            }
          }

          return Text.rich(
            TextSpan(
              children: [
                truncatedContent,
                TextSpan(
                  text: linkText,
                  style: linkStyle,
                  recognizer: _tapGestureRecognizer,
                ),
              ],
            ),
            textAlign: widget.textAlign ?? TextAlign.start,
            textDirection: widget.textDirection ?? TextDirection.ltr,
          );
        }
      },
    );
  }

  /// Helper to truncate InlineSpan at a given character offset.
  InlineSpan _truncateSpan(InlineSpan span, int endOffset) {
    if (endOffset <= 0) return const TextSpan(text: '');

    int currentOffset = 0;
    return _truncateRecursive(span, endOffset, currentOffset).span;
  }

  ({InlineSpan span, int consumed}) _truncateRecursive(
      InlineSpan span, int endOffset, int currentOffset) {
    if (span is TextSpan) {
      final text = span.text;
      final List<InlineSpan> truncatedChildren = [];
      int textConsumed = 0;
      int totalConsumed = 0;

      if (text != null) {
        final int remaining = endOffset - currentOffset;
        if (remaining <= 0) {
          textConsumed = 0;
        } else if (text.length <= remaining) {
          textConsumed = text.length;
        } else {
          // If the text itself needs to be truncated, we don't include any children
          return (
          span: TextSpan(
            text: text.substring(0, remaining),
            style: span.style,
            recognizer: span.recognizer,
          ),
          consumed: remaining
          );
        }
      }

      totalConsumed = textConsumed;

      if (span.children != null) {
        for (final child in span.children!) {
          final result = _truncateRecursive(
              child, endOffset, currentOffset + totalConsumed);
          truncatedChildren.add(result.span);
          totalConsumed += result.consumed;
          if (currentOffset + totalConsumed >= endOffset) {
            break;
          }
        }
      }

      return (
      span: TextSpan(
        text: textConsumed > 0 ? text?.substring(0, textConsumed) : null,
        style: span.style,
        children: truncatedChildren.isEmpty ? null : truncatedChildren,
        recognizer: span.recognizer,
      ),
      consumed: totalConsumed
      );
    } else if (span is WidgetSpan) {
      // WidgetSpan is treated as a single character for offset purposes in many cases,
      // but here we just count it as 1 or skip if it exceeds.
      if (currentOffset + 1 <= endOffset) {
        return (span: span, consumed: 1);
      } else {
        return (span: const TextSpan(text: ''), consumed: 0);
      }
    }
    return (span: span, consumed: 0);
  }
}