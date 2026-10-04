import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_layout.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_additional_options.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_interest_category_item.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/labeled_image_row.dart';
import 'package:kuemele/shared/widgets/kumele_image_picker.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateEventMediaColumn extends StatelessWidget {
  const CreateEventMediaColumn({
    super.key,
    required this.layout,
    required this.interests,
    required this.onInterestSelected,
    required this.guestPaymentType,
    required this.paypalConnected,
    required this.stripeConnected,
    required this.onGuestPaymentTypeChanged,
    required this.onShowGuestPriceDialog,
    required this.onShowGuestInviteDialog,
    required this.numberOfGuests,
    this.isCategoriesLoading = false,
    this.eventImagePath,
    this.isPickingEventImage = false,
    this.onUploadImageTap,
    this.onClearEventImage,
  });

  final CreateEventLayout layout;
  final List<InterestsModel> interests;
  final ValueChanged<int> onInterestSelected;
  final String guestPaymentType;
  final bool paypalConnected;
  final bool stripeConnected;
  final ValueChanged<String> onGuestPaymentTypeChanged;
  final VoidCallback onShowGuestPriceDialog;
  final VoidCallback onShowGuestInviteDialog;
  final int numberOfGuests;
  final bool isCategoriesLoading;
  final String? eventImagePath;
  final bool isPickingEventImage;
  final VoidCallback? onUploadImageTap;
  final VoidCallback? onClearEventImage;

  static const _placeholderCount = 6;

  List<InterestsModel> _displayInterests(AppLocalizations l10n) =>
      isCategoriesLoading
          ? List.generate(
              _placeholderCount,
              (_) => InterestsModel(
                title: l10n.createEventCategoryPlaceholder,
                isSelected: false,
              ),
            )
          : interests;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayInterests = _displayInterests(l10n);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.createEventCategoryLabel,
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' *',
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorSet.snackBarErrorBg,
                ),
              ),
            ],
          ),
        ),
        const Gap(5),
        Skeletonizer(
          enabled: isCategoriesLoading,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5,
              children: displayInterests
                  .mapIndexed(
                    (index, e) => GestureDetector(
                      onTap: isCategoriesLoading
                          ? null
                          : () => onInterestSelected(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CreateEventInterestCategoryItem(
                            interest: displayInterests[index],
                          ),
                          const Gap(1),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Gap(28),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.createEventImageLabel,
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' *',
                style: context.textTheme.bodySmallSemiBold.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorSet.snackBarErrorBg,
                ),
              ),
            ],
          ),
        ),
        const Gap(4),
        Text(
          l10n.createEventImageSizeHint,
          style: context.textTheme.labelSmallSemiBold.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        const Gap(9),
        KumeleImagePicker(
          height: layout.imageUploadHeight,
          imagePath: eventImagePath,
          isLoading: isPickingEventImage,
          onTap: onUploadImageTap,
          onClear: onClearEventImage,
        ),
        const Gap(28),
        LabeledImageRow(
          leftImage: Assets.social.paypal.path,
          text: paypalConnected ? 'PayPal connected' : 'Connect PayPal',
          rightImage: paypalConnected
              ? IconSet.paypalConnectedIcon
              : IconSet.paypalNotConnectedIcon,
        ),
        const Gap(8),
        LabeledImageRow(
          leftImage: IconSet.stripeIcon,
          text: stripeConnected ? 'Stripe connected' : 'Connect Stripe',
          rightImage: stripeConnected
              ? IconSet.paypalConnectedIcon
              : IconSet.paypalNotConnectedIcon,
        ),
        const Gap(8),
        WidgetByDevice(
          tablet: CreateEventAdditionalOptions(
            guestPaymentType: guestPaymentType,
            paypalConnected: paypalConnected,
            stripeConnected: stripeConnected,
            onGuestPaymentTypeChanged: onGuestPaymentTypeChanged,
            onGuestPriceDialogTap: onShowGuestPriceDialog,
            onGuestInviteDialogTap: onShowGuestInviteDialog,
            numberOfGuests: numberOfGuests,
            showRsvpHeader: true,
          ),
        ),
      ],
    );
  }
}
