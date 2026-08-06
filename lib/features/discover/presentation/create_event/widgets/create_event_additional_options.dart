import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_payment_radio.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_ticket_button.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/pickers/kumele_range_limiter.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class CreateEventAdditionalOptions extends StatelessWidget {
  const CreateEventAdditionalOptions({
    super.key,
    required this.guestPaymentType,
    required this.onGuestPaymentTypeChanged,
    required this.onGuestPriceDialogTap,
    required this.onGuestInviteDialogTap,
    required this.numberOfGuests,
    this.showRsvpHeader = false,
  });

  final String guestPaymentType;
  final ValueChanged<String> onGuestPaymentTypeChanged;
  final VoidCallback onGuestPriceDialogTap;
  final VoidCallback onGuestInviteDialogTap;
  final int numberOfGuests;
  final bool showRsvpHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KumeleRangeLimiter(
          label: 'Age range',
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Number of guests',
              style: context.textTheme.bodySmall.copyWith(fontSize: 14),
            ),
            const Gap(4),
            AppRoundedIconButton(
              assetPath: Assets.icons.info.path,
              iconSize: 20,
              onTap: onGuestPriceDialogTap,
            ),
          ],
        ),
        const Gap(8),
        CreateEventTicketButton(
          numberOfGuests: numberOfGuests,
          onTicketTap: onGuestInviteDialogTap,
        ),
        if (showRsvpHeader)
          WidgetByDevice(
            tablet: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'RSVP Guest Payment',
                style: context.textTheme.bodySmall.copyWith(fontSize: 12),
              ),
            ),
          ),
        const Gap(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CreateEventPaymentRadio(
                label: 'Free Event',
                value: 'Free',
                groupValue: guestPaymentType,
                onSelected: onGuestPaymentTypeChanged,
              ),
            ),
            const Gap(24),
            Expanded(
              child: CreateEventPaymentRadio(
                label: 'Card Payment',
                value: '20\$',
                groupValue: guestPaymentType,
                onSelected: onGuestPaymentTypeChanged,
              ),
            ),
            const Gap(24),
            Expanded(
              child: CreateEventPaymentRadio(
                label: 'Cash On Entry',
                value: '50\$',
                groupValue: guestPaymentType,
                onSelected: onGuestPaymentTypeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
