import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/responsive/responsive_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_image_picker_sheet.dart';
import 'package:kuemele/features/discover/presentation/create_event_page.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_preview_dialog.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/guest_invite_dialog.dart';
import 'package:kuemele/shared/modals/dialog/guest_price_dialog.dart';
import 'package:kuemele/shared/modals/dialog/user_around_dialog.dart';
import 'package:kuemele/l10n/app_localizations.dart';

mixin CreateEventMixin on State<CreateEvent> {
  Future<void> onCheckUserAvailability() async {
    final cubit = context.read<CreateEventCubit>();
    final result = await cubit.checkAvailability();
    if (!mounted || result == null) return;

    if (result.hasConflict) {
      final title = result.firstConflictTitle;
      InjectionHelper.snackBar.showError(
        title == null || title.isEmpty
            ? 'You already have a conflicting event at this time.'
            : 'You already have a conflicting event at this time: $title.',
      );
      return;
    }

    AppDialog.adaptive(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: UserAroundDialog(),
    );
  }

  void onShowGuestPriceDialog() {
    final cubit = context.read<CreateEventCubit>();
    if (context.responsive.isPhone) {
      AppBottomSheet.present(
        context: context,
        child: GuestPriceDialog(plans: cubit.state.eventPlans),
      );
      return;
    }

    AppDialog.show(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: GuestPriceDialog(plans: cubit.state.eventPlans),
    );
  }

  void onShowGuestInviteDialog() {
    final cubit = context.read<CreateEventCubit>();
    if (context.responsive.isPhone) {
      AppBottomSheet.present(
        context: context,
        child: GuestInviteDialog(
          initialValue: cubit.state.numberOfGuests,
          maximumValue: cubit.state.maximumGuests,
          quoteLabel: cubit.state.guestQuoteLabel,
          onChanged: cubit.updateNumberOfGuests,
        ),
      );
      return;
    }

    AppDialog.show(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: GuestInviteDialog(
        initialValue: cubit.state.numberOfGuests,
        maximumValue: cubit.state.maximumGuests,
        quoteLabel: cubit.state.guestQuoteLabel,
        onChanged: cubit.updateNumberOfGuests,
      ),
    );
  }

  void onUploadImageTap(CreateEventCubit cubit) {
    CreateEventImagePickerSheet.show(
      context: context,
      onSourceSelected: (source) => unawaited(cubit.pickEventImage(source)),
    );
  }

  Future<void> onPressedPreview() async {
    final cubit = context.read<CreateEventCubit>();
    if (!cubit.validateForm()) return;
    await cubit.loadAimlEventAdvice();
    if (!mounted) return;

    AppDialog.show(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: CreateEventPreviewDialog(
        createEventState: cubit.state,
        footer: [
          BlocConsumer<CreateEventCubit, CreateEventState>(
            bloc: cubit,
            listenWhen: (prev, curr) =>
                prev.status != curr.status &&
                curr.status == CreateEventStatus.success,
            listener: (ctx, state) {
              ctx.pop();
              final locationState = InjectionHelper.locationCubit.state;
              final radius = InjectionHelper.profileCubit.userData?.locationRadius;
              InjectionHelper.exploreCubit.loadEvents(
                latitude: locationState.coordinates?.latitude,
                longitude: locationState.coordinates?.longitude,
                radius: radius?.toDouble(),
              );
            },
            builder: (ctx, state) {
              final isSubmitting = state.status == CreateEventStatus.submitting;
              return Expanded(
                child: AppButton.primary(
                  fullWidth: true,
                  isLoading: isSubmitting,
                  onPressed: isSubmitting ? null : () => cubit.submitEvent(),
                  label: AppLocalizations.of(context)!.createEventButtonLabel,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
