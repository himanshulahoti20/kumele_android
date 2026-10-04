import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_layout.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_media_column.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class CreateEventTabletBody extends StatelessWidget {
  const CreateEventTabletBody({
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
    required this.detailsColumn,
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
  final Widget detailsColumn;
  final int numberOfGuests;
  final bool isCategoriesLoading;
  final String? eventImagePath;
  final bool isPickingEventImage;
  final VoidCallback? onUploadImageTap;
  final VoidCallback? onClearEventImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: layout.tabletOuterMargin,
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(layout.borderRadius),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: layout.tabletHeaderPadding,
              child: Text(
                AppLocalizations.of(context)!.createEventTitle,
                style: context.textTheme.titleMediumSemiBold.copyWith(
                  fontSize: layout.headerFontSize,
                ),
              ),
            ),
            Container(height: 1, color: ColorSet.border),
            Padding(
              padding: layout.tabletContentPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: layout.columnGap,
                children: [
                  Expanded(
                    child: CreateEventMediaColumn(
                      layout: layout,
                      interests: interests,
                      onInterestSelected: onInterestSelected,
                      guestPaymentType: guestPaymentType,
                      paypalConnected: paypalConnected,
                      stripeConnected: stripeConnected,
                      onGuestPaymentTypeChanged: onGuestPaymentTypeChanged,
                      onShowGuestPriceDialog: onShowGuestPriceDialog,
                      onShowGuestInviteDialog: onShowGuestInviteDialog,
                      numberOfGuests: numberOfGuests,
                      isCategoriesLoading: isCategoriesLoading,
                      eventImagePath: eventImagePath,
                      isPickingEventImage: isPickingEventImage,
                      onUploadImageTap: onUploadImageTap,
                      onClearEventImage: onClearEventImage,
                    ),
                  ),
                  Expanded(child: detailsColumn),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
