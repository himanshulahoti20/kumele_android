import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/theme/app_radius.dart';
import 'package:kuemele/features/profile/presentation/languages/bloc/languages_bloc.dart';
import 'package:kuemele/features/profile/presentation/languages/domain/entities/translation_language.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LanguagesList extends StatelessWidget {
  const LanguagesList({
    super.key,
    required this.languages,
    required this.selectedLanguageCode,
    required this.isLoading,
    this.isUpdating = false,
  });

  final List<TranslationLanguage> languages;
  final String? selectedLanguageCode;
  final bool isLoading;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final displayLanguages = isLoading ? _placeholderLanguages() : languages;

    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        decoration: BoxDecoration(
          color: ColorSet.profileTileFillColor,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
        ),
        child: Column(
          children: [
            for (var index = 0; index < displayLanguages.length; index++) ...[
              if (index > 0) const AppDivider.horizontal(),
              _LanguageTile(
                language: displayLanguages[index],
                isSelected: !isLoading &&
                    displayLanguages[index].code == selectedLanguageCode,
                isDisabled: isLoading || isUpdating,
                onTap: isLoading
                    ? null
                    : () {
                        context.read<LanguagesBloc>().add(
                              LanguagesLanguageSelected(
                                displayLanguages[index].code,
                              ),
                            );
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<TranslationLanguage> _placeholderLanguages() {
    return List.generate(
      6,
      (index) => TranslationLanguage(
        code: 'placeholder-$index',
        name: 'Language name',
        nativeName: 'Native language',
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  final TranslationLanguage language;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final showSubtitle = language.nativeName.trim().toLowerCase() !=
        language.name.trim().toLowerCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.nativeName,
                      style: context.textTheme.bodyLarge.copyWith(
                        color: ColorSet.profileSubTextColor,
                        fontSize: 18.sp,
                      ),
                    ),
                    if (showSubtitle) ...[
                      SizedBox(height: 4.h),
                      Text(
                        language.name,
                        style: context.textTheme.bodyMedium.copyWith(
                          color: ColorSet.profileSubTextColor.withValues(
                            alpha: 0.7,
                          ),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: ColorSet.specialYellowColor,
                  size: 22.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
