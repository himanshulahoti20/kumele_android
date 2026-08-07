import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_bloc.dart';
import 'package:kuemele/shared/components/radio.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class SignupGenderSelector extends StatelessWidget {
  const SignupGenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.selectedGender != current.selectedGender,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.signupGenderLabel,
              style: context.textTheme.heading3.copyWith(fontSize: 19),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGenderRadio(context, state.selectedGender, Gender.male),
                _buildGenderRadio(context, state.selectedGender, Gender.female),
                _buildGenderRadio(
                    context, state.selectedGender, Gender.nonBinary),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenderRadio(
      BuildContext context, Gender groupValue, Gender value) {
    return CommonRadio<Gender>(
      value: value,
      label: value.label,
      textSize: 18,
      onChanged: (e) => context.read<SignupBloc>().add(SignupGenderChanged(e)),
      groupValue: groupValue,
    );
  }
}
