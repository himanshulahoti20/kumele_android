import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_form_controllers.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_layout.dart';
import 'package:kuemele/features/discover/presentation/create_event/widgets/create_event_details_column.dart';

class CreateEventDetailsColumnSection extends StatelessWidget {
  const CreateEventDetailsColumnSection({
    super.key,
    required this.layout,
    required this.controllers,
    required this.onCheckUserAvailability,
    required this.onPreview,
    this.showPreviewButton = true,
  });

  final CreateEventLayout layout;
  final CreateEventFormControllers controllers;
  final VoidCallback onCheckUserAvailability;
  final VoidCallback onPreview;
  final bool showPreviewButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        final cubit = context.read<CreateEventCubit>();

        return CreateEventDetailsColumn(
          titleController: controllers.title,
          subtitleController: controllers.subtitle,
          descriptionController: controllers.description,
          startsIn: state.startsIn,
          onStartsInDecrease: cubit.decreaseStartsIn,
          onStartsInIncrease: cubit.increaseStartsIn,
          date: state.dateLabel,
          selectedDate: state.selectedDate,
          eventStartTime: state.eventStartTimeLabel,
          eventEndTime: state.eventEndTimeLabel,
          selectedStartTime: state.selectedStartTime,
          selectedEndTime: state.selectedEndTime,
          onStartTimeSelected: cubit.updateStartTime,
          onEndTimeSelected: cubit.updateEndTime,
          onDateSelected: cubit.updateDate,
          onCheckUserAvailability: onCheckUserAvailability,
          estimatedAvailable: state.audienceEstimate?.estimatedAvailable,
          isLoadingEstimatedAvailable: state.isLoadingAudienceEstimate,
          onPreview: onPreview,
          selectedLocation: state.selectedLocation,
          onLocationSelected: cubit.updateLocation,
          onClearLocation: cubit.clearLocation,
          showValidationErrors: state.showValidationErrors,
          showPreviewButton: showPreviewButton,
          previewHorizontalPadding: layout.previewButtonHorizontalPadding,
          previewVerticalPadding: layout.previewButtonVerticalPadding,
        );
      },
    );
  }
}
