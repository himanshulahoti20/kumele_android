import 'package:flutter/material.dart';

import 'package:kuemele/shared/utils/utils.dart';

class CloseKeyboard extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;

  const CloseKeyboard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.closeKeyboard(context);
        onTap?.call();
      },
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
