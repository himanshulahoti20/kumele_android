import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/discover/cubit/event_matched_bloc.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/features/discover/presentation/event_matched/widgets/event_matched_dialog_content.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog_layout.dart';

class EventMatchedDialog extends StatelessWidget {
  const EventMatchedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final eventData = context.watch<EventMatchedBloc>().state.eventData;

    return AppDialogLayout(
      widthPercent: responsive.pick(
        mobilePortrait: DiscoverConfig.dialogWidthPercentPhone,
        tabletPortrait: DiscoverConfig.dialogWidthPercentTablet,
      ),
      heightPercent: responsive.pick(
        mobilePortrait: DiscoverConfig.dialogHeightPercentPhone,
        tabletPortrait: DiscoverConfig.dialogHeightPercentTablet,
      ),
      backgroundImagePath: eventData.backgroundImagePath.trim().isEmpty
          ? null
          : eventData.backgroundImagePath,
      child: const EventMatchedDialogContent(),
    );
  }
}
