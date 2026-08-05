import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_layout.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_additional_options.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_media_column.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_preview_button.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class CreateEventPhoneBody extends StatelessWidget {
  const CreateEventPhoneBody({
    super.key,
    required this.layout,
    required this.interests,
    required this.onInterestSelected,
    required this.guestPaymentType,
    required this.onGuestPaymentTypeChanged,
    required this.onShowGuestPriceDialog,
    required this.onShowGuestInviteDialog,
    required this.onOpenPaymentSubscriptions,
    required this.detailsColumn,
    required this.onPreview,
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
  final ValueChanged<String> onGuestPaymentTypeChanged;
  final VoidCallback onShowGuestPriceDialog;
  final VoidCallback onShowGuestInviteDialog;
  final VoidCallback onOpenPaymentSubscriptions;
  final Widget detailsColumn;
  final VoidCallback onPreview;
  final int numberOfGuests;
  final bool isCategoriesLoading;
  final String? eventImagePath;
  final bool isPickingEventImage;
  final VoidCallback? onUploadImageTap;
  final VoidCallback? onClearEventImage;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorSet.bg3Color,
      child: SafeArea(
        child: Padding(
          padding: layout.phoneScreenPadding,
          child: Column(
            children: [
              const MobileHeader(label: 'Create event'),
              Gap(layout.sectionGap),
              Expanded(
                child: ListView(
                  padding: layout.phoneListPadding,
                  shrinkWrap: true,
                  children: [
                    CreateEventMediaColumn(
                      layout: layout,
                      interests: interests,
                      onInterestSelected: onInterestSelected,
                      guestPaymentType: guestPaymentType,
                      onGuestPaymentTypeChanged: onGuestPaymentTypeChanged,
                      onShowGuestPriceDialog: onShowGuestPriceDialog,
                      onShowGuestInviteDialog: onShowGuestInviteDialog,
                      onOpenPaymentSubscriptions: onOpenPaymentSubscriptions,
                      numberOfGuests: numberOfGuests,
                      isCategoriesLoading: isCategoriesLoading,
                      eventImagePath: eventImagePath,
                      isPickingEventImage: isPickingEventImage,
                      onUploadImageTap: onUploadImageTap,
                      onClearEventImage: onClearEventImage,
                    ),
                    detailsColumn,
                    Gap(layout.sectionGap),
                    CreateEventAdditionalOptions(
                      guestPaymentType: guestPaymentType,
                      onGuestPaymentTypeChanged: onGuestPaymentTypeChanged,
                      onGuestPriceDialogTap: onShowGuestPriceDialog,
                      onGuestInviteDialogTap: onShowGuestInviteDialog,
                      onOpenPaymentSubscriptionsTap: onOpenPaymentSubscriptions,
                      numberOfGuests: numberOfGuests,
                    ),
                    Gap(layout.sectionGap),
                    CreateEventPreviewButton(
                      onPressed: onPreview,
                      horizontalPadding: layout.previewButtonHorizontalPadding,
                      verticalPadding: layout.previewButtonVerticalPadding,
                    ),
                    Gap(layout.sectionGap),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
