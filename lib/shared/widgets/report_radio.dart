import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/radio.dart';

enum ReportReason {
  racist,
  scam,
  other,
  physicalAssault;

  /// Stable value sent to `POST /events/{id}/reports` — not the translated label.
  String get apiValue => switch (this) {
        racist => 'racist',
        scam => 'scam',
        other => 'other',
        physicalAssault => 'physical_assault',
      };

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      racist => l10n.reportReasonRacist,
      scam => l10n.reportReasonScam,
      other => l10n.reportReasonOther,
      physicalAssault => l10n.reportReasonPhysicalAssault,
    };
  }
}

class ReportRadio extends StatelessWidget {
  const ReportRadio({
    super.key,
    required this.selectedReason,
    required this.onChanged,
  });

  final ReportReason selectedReason;
  final ValueChanged<ReportReason> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final reason in ReportReason.values) ...[
          if (reason != ReportReason.racist) const Gap(16),
          RARadio(
            text: reason.label(context),
            onChanged: (value, isSelected) => onChanged(reason),
            groupValue: selectedReason.label(context),
          ),
        ],
      ],
    );
  }
}
