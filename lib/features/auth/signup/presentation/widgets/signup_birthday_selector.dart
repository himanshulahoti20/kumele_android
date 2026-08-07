import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/features/auth/signup/bloc/signup_bloc.dart';
import 'package:kuemele/shared/components/kumele_dropdown.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class SignupBirthdaySelector extends StatelessWidget {
  const SignupBirthdaySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> dates = List.generate(31, (index) => (index + 1));
    final List<int> years = List.generate(20, (index) => (2000 + index));

    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.signupDateOfBirthLabel,
              style: context.textTheme.heading3.copyWith(fontSize: 19),
            ),
            SizedBox(height: size(5)),
            Row(
              spacing: 10,
              children: [
                // Day Dropdown
                Expanded(
                  child: KumeleDropdown(
                    value: state.selectedDay.toString(),
                    items: dates.map((e) => e.toString()).toList(),
                    onSelected: (val, index) {
                      context
                          .read<SignupBloc>()
                          .add(SignupDateOfBirthChanged(day: dates[index]));
                    },
                  ),
                ),

                // Month Dropdown
                Expanded(
                  child: KumeleDropdown(
                    value: AuthConfig.months[state.selectedMonth - 1],
                    items: AuthConfig.months,
                    onSelected: (val, index) {
                      context
                          .read<SignupBloc>()
                          .add(SignupDateOfBirthChanged(month: index + 1));
                    },
                  ),
                ),

                // Year Dropdown
                Expanded(
                  child: KumeleDropdown(
                    value: state.selectedYear.toString(),
                    items: years.map((e) => e.toString()).toList(),
                    onSelected: (val, index) {
                      context
                          .read<SignupBloc>()
                          .add(SignupDateOfBirthChanged(year: years[index]));
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
