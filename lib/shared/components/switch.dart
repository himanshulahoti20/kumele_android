import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RASwitch extends StatefulWidget {
  bool value;
  Size size;
  Color? bgColor;
  Color? valueOnColor;
  Color? valueOnThumbColor;
  Color? valueOffColor;
  void Function()? onTap;
  RASwitch({
    super.key,
    required this.value,
    required this.size,
    this.bgColor,
    this.onTap,
    this.valueOnColor,
    this.valueOnThumbColor,
    this.valueOffColor,
  });

  @override
  State<RASwitch> createState() => _RASwitchState();
}

class _RASwitchState extends State<RASwitch> {
  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final sz = MediaQuery.of(context).size;
    double area = sz.width * sz.height;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: isPortrait ? 22 : 18,
        width: isPortrait ? 33 : 27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(area),
          color: widget.value ? (widget.valueOnColor ?? Colors.black) : (widget.valueOffColor ?? Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.value,
              child: const Spacer(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: widget.size.height / 1.5,
                width: widget.size.width / 2,
                decoration: BoxDecoration(
                  color: widget.value
                      ? (widget.valueOnThumbColor ?? widget.valueOnColor ?? Colors.grey)
                      : (widget.valueOffColor ?? Colors.black),
                  borderRadius: BorderRadius.circular(area),
                ),
              ),
            ),
            Visibility(
              visible: !widget.value,
              child: const Spacer(),
            ),
          ],
        ),
      ),
    );
  }
}
