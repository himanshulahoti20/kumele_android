import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_form_controllers.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_layout.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_mixin.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_details_column_section.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_phone_body.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_tablet_body.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class CreateEvent extends StatefulWidget implements BasePage {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();

  @override
  String get screenName => 'CreateEvent';
}

class _CreateEventState extends State<CreateEvent> with CreateEventMixin {
  CreateEventFormControllers? _controllers;

  @override
  void initState() {
    super.initState();
    final cubit = InjectionHelper.createEventCubit;
    unawaited(cubit.initializeForm());
    _controllers = CreateEventFormControllers.bind(cubit);
  }

  @override
  void dispose() {
    _controllers?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = InjectionHelper.createEventCubit;
    final layout = CreateEventLayout(context.responsive);
    final controllers = _controllers!;
    final detailsColumn = CreateEventDetailsColumnSection(
      layout: layout,
      controllers: controllers,
      onCheckUserAvailability: () => unawaited(onCheckUserAvailability()),
      onPreview: () => unawaited(onPressedPreview()),
    );

    return BlocConsumer<CreateEventCubit, CreateEventState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CreateEventStatus.success,
      listener: (context, state) {
        if (context.canPop()) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isCategoriesLoading = state.status == CreateEventStatus.loading;

        return Scaffold(
          backgroundColor: ColorSet.bgColor,
          body: WidgetByDevice(
            tablet: CreateEventTabletBody(
              layout: layout,
              interests: state.interests,
              onInterestSelected: cubit.selectInterest,
              guestPaymentType: state.guestPaymentType,
              paypalConnected: state.paypalConnected,
              onGuestPaymentTypeChanged: cubit.updateGuestPaymentType,
              onShowGuestPriceDialog: onShowGuestPriceDialog,
              onShowGuestInviteDialog: onShowGuestInviteDialog,
              detailsColumn: detailsColumn,
              numberOfGuests: state.numberOfGuests,
              isCategoriesLoading: isCategoriesLoading,
              eventImagePath: state.eventImagePath,
              isPickingEventImage: state.isPickingEventImage,
              onUploadImageTap: () => onUploadImageTap(cubit),
              onClearEventImage: cubit.clearEventImage,
            ),
            phone: CreateEventPhoneBody(
              layout: layout,
              interests: state.interests,
              onInterestSelected: cubit.selectInterest,
              guestPaymentType: state.guestPaymentType,
              paypalConnected: state.paypalConnected,
              onGuestPaymentTypeChanged: cubit.updateGuestPaymentType,
              onShowGuestPriceDialog: onShowGuestPriceDialog,
              onShowGuestInviteDialog: onShowGuestInviteDialog,
              detailsColumn: detailsColumn,
              onPreview: () => unawaited(onPressedPreview()),
              numberOfGuests: state.numberOfGuests,
              isCategoriesLoading: isCategoriesLoading,
              eventImagePath: state.eventImagePath,
              isPickingEventImage: state.isPickingEventImage,
              onUploadImageTap: () => onUploadImageTap(cubit),
              onClearEventImage: cubit.clearEventImage,
            ),
          ),
        );
      },
    );
  }
}
