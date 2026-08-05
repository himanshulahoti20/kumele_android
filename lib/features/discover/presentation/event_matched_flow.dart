import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/discover/cubit/event_matched_bloc.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/features/discover/presentation/event_matched.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';

abstract final class EventMatchedFlow {
  EventMatchedFlow._();

  static Future<void> show(
    BuildContext context, {
    DiscoverMatchedEventData? eventData,
    String? eventId,
    int? guests,
    String? title,
    String? eventImagePath,
    String? categoryIconPath,
  }) {
    context.read<EventMatchedBloc>().add(
          EventMatchedStarted(
            eventData ??
                DiscoverConfig.matchedEvent(
                  eventId: eventId,
                  guestCount: guests,
                  title: title,
                  eventImagePath: eventImagePath,
                  categoryIconPath: categoryIconPath,
                ),
          ),
        );

    return AppDialog.show<void>(
      context: context,
      width: AppDialogSize.widthFor(context),
      blurBarrier: true,
      dialog: const EventMatchedDialog(),
    );
  }
}
