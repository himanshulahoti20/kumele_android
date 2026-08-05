import 'package:flutter/material.dart';

class KumeleTextLink extends StatelessWidget {
  const KumeleTextLink({
    super.key,
    required this.leading,
    required this.trailing,
    required this.leadingStyle,
    required this.trailingStyle,
    this.onTap,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  final String leading;
  final String trailing;
  final TextStyle leadingStyle;
  final TextStyle trailingStyle;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          text: leading,
          style: leadingStyle,
          children: [
            TextSpan(text: trailing, style: trailingStyle),
          ],
        ),
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}

class KumeleReplyTag extends StatelessWidget {
  const KumeleReplyTag({
    super.key,
    required this.label,
    required this.action,
    required this.labelStyle,
    required this.actionStyle,
    required this.dotStyle,
    this.onTap,
    this.underline = false,
  });

  final String label;
  final String action;
  final TextStyle labelStyle;
  final TextStyle actionStyle;
  final TextStyle dotStyle;
  final VoidCallback? onTap;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    final actionTextStyle = underline
        ? actionStyle.copyWith(decoration: TextDecoration.underline)
        : actionStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('⬤ ', style: dotStyle),
        Text(label, style: labelStyle),
        Text(' ⬤ ', style: dotStyle),
        GestureDetector(
          onTap: onTap,
          child: Text(action, style: actionTextStyle),
        ),
      ],
    );
  }
}
