import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/radio.dart';

class ReportRadio extends StatefulWidget {
  const ReportRadio({super.key});

  @override
  State<ReportRadio> createState() => _ReportRadioState();
}

class _ReportRadioState extends State<ReportRadio> {
  late String selectedReason;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedReason = AppLocalizations.of(context)!.reportReasonRacist;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RARadio(
          text: l10n.reportReasonRacist,
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = l10n.reportReasonRacist;
            });
          },
          groupValue: selectedReason,
        ),
        const Gap(16),
        RARadio(
          text: l10n.reportReasonScam,
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = l10n.reportReasonScam;
            });
          },
          groupValue: selectedReason,
        ),
        const Gap(16),
        RARadio(
          text: l10n.reportReasonOther,
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = l10n.reportReasonOther;
            });
          },
          groupValue: selectedReason,
        ),
        const Gap(16),
        RARadio(
          text: l10n.reportReasonPhysicalAssault,
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = l10n.reportReasonPhysicalAssault;
            });
          },
          groupValue: selectedReason,
        ),
      ],
    );
  }
}
