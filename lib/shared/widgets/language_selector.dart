import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/app/cubit/locale_cubit.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  static const _fallbackLanguages = [
    LanguageModel(code: 'en', name: 'English'),
    LanguageModel(code: 'fr', name: 'Français'),
    LanguageModel(code: 'es', name: 'Español'),
    LanguageModel(code: 'de', name: 'Deutsch'),
    LanguageModel(code: 'ar', name: 'العربية'),
    LanguageModel(code: 'zh', name: '中文'),
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = context.responsive.isTablet;
    final chipRadius = isTablet ? 5.0 : 8.0;

    return BlocBuilder<LocaleCubit, LocaleState>(
      bloc: getIt<LocaleCubit>(),
      builder: (context, state) {
        final languages =
            state.languages.isNotEmpty ? state.languages : _fallbackLanguages;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.signInLanguageChoiceLabel,
              style: context.textTheme.bodyLarge
                  .copyWith(color: ColorSet.textColor),
            ),
            const SizedBox(height: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final lang in languages)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _LanguageChip(
                        label: lang.name,
                        selected: lang.code == state.locale.languageCode,
                        radius: chipRadius,
                        onTap: () => getIt<LocaleCubit>().setLocale(lang.code),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.radius,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? ColorSet.specialYellowColor : ColorSet.tileFillColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          label,
          style: (selected
                  ? context.textTheme.bodyMediumBold
                  : context.textTheme.bodyMedium)
              .copyWith(color: selected ? Colors.black : ColorSet.textColor),
        ),
      ),
    );
  }
}
