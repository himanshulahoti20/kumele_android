import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class RARadio extends StatefulWidget {
  final String? text;
  final double? textSize;
  final FontWeight? textWeight;
  final double? radioSize;
  final double? spaceBetween;
  final Function(String, bool) onChanged;
  final String groupValue;
  final String? value;

  const RARadio({
    super.key,
    this.text,
    this.textSize,
    this.textWeight = FontWeight.w400,
    this.radioSize,
    this.spaceBetween,
    required this.onChanged,
    required this.groupValue,
    this.value,
  });

  @override
  _RARadioState createState() => _RARadioState();
}

class _RARadioState extends State<RARadio> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = (widget.value ?? widget.text) == widget.groupValue;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          widget.onChanged(widget.text ?? '', !isSelected);
        }
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: widget.radioSize ?? size(20),
            height: widget.radioSize ?? size(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _RadioConstants.borderColor,
                width: 2.0,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: (widget.radioSize ?? size(20)) * 0.6,
                height: (widget.radioSize ?? size(20)) * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? _RadioConstants.activeFillColor
                      : Colors.transparent,
                ),
              ),
            ),
          ),
          SizedBox(width: widget.spaceBetween ?? size(5)),
          Text(
            widget.text ?? '',
            style: context.textTheme.bodyLarge.copyWith(
              fontSize: 15,
              fontWeight: widget.textWeight ?? FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioConstants {
  static const Color borderColor = Color(0xFFBCBCBC);
  static const Color activeFillColor = Color(0xFF004DFF);
}

class CommonRadio<T> extends StatelessWidget {
  final String label;
  final double? textSize;
  final FontWeight? textWeight;
  final double? radioSize;
  final double? spaceBetween;
  final void Function(T) onChanged;
  final T groupValue;
  final T value;

  const CommonRadio({
    super.key,
    required this.label,
    this.textSize,
    this.textWeight = FontWeight.w400,
    this.radioSize,
    this.spaceBetween,
    required this.onChanged,
    required this.groupValue,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          onChanged(value);
        }
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: radioSize ?? size(20),
            height: radioSize ?? size(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _RadioConstants.borderColor,
                width: 2.0,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: (radioSize ?? size(20)) * 0.6,
                height: (radioSize ?? size(20)) * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? _RadioConstants.activeFillColor
                      : Colors.transparent,
                ),
              ),
            ),
          ),
          SizedBox(width: spaceBetween ?? size(5)),
          Text(
            label,
            style: context.textTheme.bodyLarge.copyWith(
              fontSize: 15,
              fontWeight: textWeight ?? FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
