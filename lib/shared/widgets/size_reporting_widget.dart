import 'dart:developer';

import 'package:flutter/material.dart';

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  // @override
  // void didUpdateWidget(covariant SizeReportingWidget oldWidget) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return widget.child;
      },
    );
  }

  void _notifySize() {
    if (!mounted) {
      return;
    }
    try {
      final size = context.size;
      if (_oldSize != size && size != null) {
        _oldSize = size;
        widget.onSizeChange(size);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
