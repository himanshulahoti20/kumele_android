import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/size.dart';

class RADottedBorderContainer extends StatefulWidget {
  final Widget? child;
  final Radius? radius;
  const RADottedBorderContainer({super.key, this.child, this.radius});

  @override
  State<RADottedBorderContainer> createState() => _RADottedBorderContainerState();
}

class _RADottedBorderContainerState extends State<RADottedBorderContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: const Color.fromARGB(255, 164, 163, 163),
        strokeWidth: 0.5,
        radius: widget.radius ?? Radius.circular(size(10.4)),
        dashPattern: const [3, 3],
      ),
      child: widget.child ?? Container(),
    );
  }
}
