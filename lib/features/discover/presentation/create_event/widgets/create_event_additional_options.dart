import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_payment_radio.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_ticket_button.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/pickers/kumele_range_limiter.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class CreateEventAdditionalOptions extends StatelessWidget {
  const CreateEventAdditionalOptions({
    super.key,
    required this.guestPaymentType,
    required this.paypalConnected,
    required this.onGuestPaymentTypeChanged,
    required this.onGuestPriceDialogTap,
    required this.onGuestInviteDialogTap,
    required this.numberOfGuests,
    this.showRsvpHeader = false,
  });

  final String guestPaymentType;
  final bool paypalConnected;
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
        KumeleRangeLimiter(
          label: AppLocalizations.of(context)!.createEventAgeRangeLabel,
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.createEventNumberOfGuestsLabel,
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
                AppLocalizations.of(context)!.createEventRsvpGuestPaymentLabel,
                style: context.textTheme.bodySmall.copyWith(fontSize: 12),
              ),
            ),
          ),
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CreateEventPaymentRadio(
                label: AppLocalizations.of(context)!.createEventFreeEventLabel,
                value: 'Free',
                groupValue: guestPaymentType,
                onSelected: onGuestPaymentTypeChanged,
              ),
            ),
            const Gap(24),
            Expanded(
              child: CreateEventPaymentRadio(
                label:
                    AppLocalizations.of(context)!.createEventCardPaymentLabel,
                value: '20\$',
                groupValue: guestPaymentType,
                onSelected: onGuestPaymentTypeChanged,
              ),
            ),
            const Gap(24),
            Expanded(
              child: CreateEventPaymentRadio(
                label:
                    AppLocalizations.of(context)!.createEventCashOnEntryLabel,
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
