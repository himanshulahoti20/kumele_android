import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/discover/data/models/audience_estimate_result.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class UserAroundDialog extends StatelessWidget {
  const UserAroundDialog({super.key, this.estimate});

  /// Real audience-estimate result (`POST /events/audience-estimate`) for
  /// the event's currently-selected location + guest count. Falls back to
  /// the generic static message when null (e.g. the call failed).
  final AudienceEstimateResult? estimate;

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        titleWidget: buildTitle(context),
        child: buildContent(context),
      ),
      phone: AppBottomSheet(
        titleWidget: buildTitle(context),
        child: buildContent(context),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(IconSet.jsonAnimMarshmallows,
            width: 80, height: 80, fit: BoxFit.fill),
        Text(
          AppLocalizations.of(context)!.userAroundTitle,
          style: context.textTheme.titleLargeBold,
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    final message = estimate?.message;
    return Text(
      message != null && message.isNotEmpty
          ? message
          : AppLocalizations.of(context)!.userAroundMessage,
      style: context.textTheme.bodyMedium,
    );
  }
}
