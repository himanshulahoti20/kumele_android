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
import 'package:kuemele/features/profile/presentation/card/payment_subscriptions.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/guest_invite_dialog.dart';
import 'package:kuemele/shared/modals/dialog/guest_price_dialog.dart';
import 'package:kuemele/shared/modals/dialog/user_around_dialog.dart';

mixin CreateEventMixin on State<CreateEvent> {
  void onCheckUserAvailability() {
    AppDialog.adaptive(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: UserAroundDialog(),
    );
  }

  void onShowGuestPriceDialog() {
    if (context.responsive.isPhone) {
      AppBottomSheet.present(
        context: context,
        child: const GuestPriceDialog(),
      );
      return;
    }

    AppDialog.show(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: const GuestPriceDialog(),
    );
  }

  void onShowGuestInviteDialog() {
    final cubit = context.read<CreateEventCubit>();
    if (context.responsive.isPhone) {
      AppBottomSheet.present(
        context: context,
        child: GuestInviteDialog(
          initialValue: cubit.state.numberOfGuests,
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

  void onPressedPreview() {
    final cubit = context.read<CreateEventCubit>();
    if (!cubit.validateForm()) return;

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
              InjectionHelper.exploreCubit.loadEvents();
            },
            builder: (ctx, state) {
              final isSubmitting = state.status == CreateEventStatus.submitting;
              return Expanded(
                child: AppButton.primary(
                  fullWidth: true,
                  isLoading: isSubmitting,
                  onPressed: isSubmitting ? null : () => cubit.submitEvent(),
                  label: 'Create Event',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onOpenPaymentSubscriptions() {
    if (context.responsive.isTablet) {
      AppDialog.show(
        context: context,
        width: AppDialogSize.widthFor(context),
        dialog: const PaymentSubscriptionsDialog(),
      );
      return;
    }

    context.push(AppRoutes.paymentSubscriptions);
  }
}
