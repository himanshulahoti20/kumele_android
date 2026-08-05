import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/radio.dart';

class ReportRadio extends StatefulWidget {
  const ReportRadio({super.key});

  @override
  State<ReportRadio> createState() => _ReportRadioState();
}

class _ReportRadioState extends State<ReportRadio> {
  String selectedReason = 'Racist';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RARadio(
          text: 'Racist',
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = 'Racist';
            });
          },
          groupValue: selectedReason,
        ),
        const Gap(16),
        RARadio(
          text: 'Scam',
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = 'Scam';
            });
          },
          groupValue: selectedReason,
        ),
        const Gap(16),
        RARadio(
          text: 'Other',
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = 'Physical assault';
            });
          },
          groupValue: selectedReason,
        ),
        const Gap(16),
        RARadio(
          text: 'Physical assault',
          onChanged: (value, isSelected) {
            setState(() {
              selectedReason = 'Physical assault';
            });
          },
          groupValue: selectedReason,
        ),
      ],
    );
  }
}
