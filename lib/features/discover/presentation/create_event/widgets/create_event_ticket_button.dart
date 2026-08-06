import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class CreateEventTicketButton extends StatelessWidget {
  const CreateEventTicketButton({
    super.key,
    required this.numberOfGuests,
    required this.onTicketTap,
  });

  final int numberOfGuests;
  final VoidCallback onTicketTap;

  @override
  Widget build(BuildContext context) {
    final digits = numberOfGuests.toString().padLeft(3, ' ');
    final firstDigit = digits[0];
    final secondDigit = digits[1];
    final thirdDigit = digits[2];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTicketTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ColorSet.tileFillColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                KumeleAssetWidget.square(
                  assetPath: Assets.icons.tickets.path,
                  size: 20,
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDigitBox(
                      context,
                      firstDigit,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    _buildDigitBox(
                      context,
                      secondDigit,
                    ),
                    _buildDigitBox(
                      context,
                      thirdDigit,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDigitBox(BuildContext context, String digit,
      {BorderRadiusGeometry? borderRadius}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: ColorSet.bg4Color),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          digit.trim(),
          style: context.textTheme.bodySmall.copyWith(
            fontSize: 12,
            color: ColorSet.textColor,
          ),
        ),
      ),
    );
  }
}
