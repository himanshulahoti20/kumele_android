import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:lottie/lottie.dart';

enum WhatYouLikeAction { create, inviteFriend, readBlog }

/// Tablet-only, matches iOS PopUpWhatWouldYouLikeView — a rotating 3-step
/// prompt (Create Event / Invite Friends / Read Blog) shown once per app
/// session on first Home load.
class WhatWouldYouLikeDialog extends StatefulWidget {
  const WhatWouldYouLikeDialog({super.key, this.onAction});

  final ValueChanged<WhatYouLikeAction>? onAction;

  @override
  State<WhatWouldYouLikeDialog> createState() =>
      _WhatWouldYouLikeDialogState();
}

class _WhatWouldYouLikeDialogState extends State<WhatWouldYouLikeDialog> {
  static const _actions = WhatYouLikeAction.values;
  static const _desc = [
    'You can now chat and have fun in the event.',
    'Be awesome and invite your friends',
    'Here are some blogs you may like',
  ];
  static const _buttonText = ['Create Event', 'Invite Friends', 'Read Blog'];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _actions.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    final action = _actions[_index];
    Navigator.of(context).pop();
    // Same reasoning as iOS's 0.45s delay: run the navigation only after
    // this popup is actually gone, or the destination's own presentation
    // can race the dismiss and silently drop.
    Future.delayed(const Duration(milliseconds: 450), () {
      widget.onAction?.call(action);
    });
  }

  @override
  Widget build(BuildContext context) {
    // iOS authBgColor/authTextColor invert with theme (black-on-white
    // becomes white-on-black in dark mode).
    final isDark = ColorSet.isDarkMode;
    final buttonBg = isDark ? Colors.white : Colors.black;
    final buttonFg = isDark ? Colors.black : Colors.white;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            // Without an explicit full-width box, the Stack sizes itself to
            // its only non-positioned child (the 75x75 icon), so the
            // "Positioned(right: 0)" close button lands at that icon's own
            // corner instead of the dialog's actual top-right edge.
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(IconSet.jsonSun, width: 75, height: 75),
                Positioned(
                  right: 0,
                  top: 0,
                  child: AppRoundedIconButton(
                    assetPath: IconSet.closeIcon,
                    iconSize: 20,
                    semanticLabel: 'Close',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          Text(
            'What would you like to do today?',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLargeBold.copyWith(
              fontSize: 25,
              color: ColorSet.textColor,
            ),
          ),
          const Gap(15),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _desc[_index],
              key: ValueKey(_index),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge.copyWith(
                fontSize: 17,
                color: ColorSet.textColor,
              ),
            ),
          ),
          const Gap(20),
          GestureDetector(
            onTap: _handleTap,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Container(
                key: ValueKey(_index),
                width: 179,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _buttonText[_index],
                  style: context.textTheme.bodyMedium.copyWith(
                    fontSize: 15,
                    color: buttonFg,
                  ),
                ),
              ),
            ),
          ),
          const Gap(20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _actions.length; i++) ...[
                if (i != 0) const Gap(8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _index
                        ? ColorSet.specialBlueColor
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
