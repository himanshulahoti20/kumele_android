import 'package:flutter/material.dart';

class Flip extends StatefulWidget {
  final bool isFlipped;
  final Widget child;

  const Flip({super.key, required this.child, required this.isFlipped});

  @override
  _FlipState createState() => _FlipState();
}

class _FlipState extends State<Flip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFlipped) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse(from: 1);
    }

    return RotationTransition(
      turns: _animation,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationX(widget.isFlipped ? 3.14 : 0),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
