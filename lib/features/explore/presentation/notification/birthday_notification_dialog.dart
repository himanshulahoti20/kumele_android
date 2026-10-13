import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog_layout.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:lottie/lottie.dart';

/// Matches iOS's NotificationBirthdayView exactly — this is the one "compact
/// alert" popup where iPad does NOT share the phone's small card. Phone stays
/// Family A (320pt cap, image+close overlaid, 19/15/12pt text). Tablet jumps
/// to Family D, the wide detail card (620x512pt cap, image above a plain
/// close row, 26/20/30pt text) — see NotificationBirthdayView_iPad.swift.
class BirthdayNotificationDialog extends StatelessWidget {
  const BirthdayNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FormFactor.isTablet ? _buildTablet(context) : _buildPhone(context);
  }

  /// Pixel spec (318pt card): 24 padding, 270x125 banner (radius 4), 24x24 white
  /// close tile in the banner's top-right corner, title 19 bold, body 15,
  /// footer signature 12 bold + gift, card radius 20.
  Widget _buildPhone(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 318),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ColorSet.bg2Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 125,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(IconSet.birthdaybanner, fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const _BirthdayCloseTile(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.birthdayNotificationTitle,
              style: context.textTheme.labelSmallBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.birthdayNotificationMessage,
              style: context.textTheme.labelSmall.copyWith(
                color: ColorSet.textColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .birthdayNotificationSignature
                      .trim(),
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: ColorSet.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Lottie.asset(IconSet.jsonGift, width: 25, height: 25),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: AppDialogSize.compactAlertMaxHeightFor(context),
      ),
      child: Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppRoundedIconButton(
                  assetPath: IconSet.closeIcon,
                  iconSize: 40,
                  padding: 0,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 540 / 222,
                child: Image.asset(
                  IconSet.birthdaybanner,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.birthdayNotificationTitle,
              style: context.textTheme.labelSmallBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.birthdayNotificationMessage,
              style: context.textTheme.labelSmall.copyWith(
                color: ColorSet.textColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.birthdayNotificationSignature,
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: ColorSet.textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Lottie.asset(IconSet.jsonGift, width: 28, height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// White 24x24 tile with the two-tone close glyph (grey X, black lower-right stroke).
class _BirthdayCloseTile extends StatelessWidget {
  const _BirthdayCloseTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomPaint(painter: _CloseGlyphPainter()),
    );
  }
}

class _CloseGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final c = size.center(Offset.zero);
    const r = 7.0;
    paint.color = const Color(0xFFA8A8A8);
    canvas.drawLine(c + const Offset(-r, -r), c, paint);
    canvas.drawLine(c + const Offset(r, -r), c + const Offset(-r, r), paint);
    paint.color = Colors.black;
    canvas.drawLine(c, c + const Offset(r, r), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
