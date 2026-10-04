import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/profile/presentation/languages/bloc/languages_bloc.dart';
import 'package:kuemele/features/profile/presentation/languages/domain/entities/translation_language.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/interested_hobbies_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/interests_grid.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/medals_list.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class InterestedHobbies extends StatefulWidget implements BasePage {
  const InterestedHobbies({
    super.key,
    this.isFromSignUp = false,
  });

  final bool isFromSignUp;

  @override
  State<InterestedHobbies> createState() => _InterestedHobbiesState();

  @override
  String get screenName => 'InterestedHobbies';
}

class _InterestedHobbiesState extends State<InterestedHobbies> {
  static const _maxSelections = 5;

  @override
  void initState() {
    super.initState();
    context.read<InterestedHobbiesBloc>().add(const InterestedHobbiesInit());
    context.read<LanguagesBloc>().add(const LanguagesInit());
  }

  @override
  Widget build(BuildContext context) {
    final session = getIt<AuthBloc>().state.session;
    final needsOnboarding = session?.needsOnboarding ?? false;

    return BlocListener<LanguagesBloc, LanguagesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        InjectionHelper.snackBar.showError(state.errorMessage!);
      },
      child: BlocConsumer<InterestedHobbiesBloc, InterestedHobbiesState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.status == InterestedHobbiesStatus.success) {
            InjectionHelper.snackBar.showSuccess(
              state.successMessage ?? 'Interests saved successfully.',
            );
            if (needsOnboarding || widget.isFromSignUp) {
              context.go(
                AppRoutes.earnMedals,
                extra: const EarnMedalsRouteArgs(isFromSignUp: false),
              );
            } else {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            }
          } else if (state.errorMessage != null &&
              state.status == InterestedHobbiesStatus.loaded &&
              state.interests.isNotEmpty) {
            InjectionHelper.snackBar.showError(state.errorMessage!);
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: !needsOnboarding,
            child: Scaffold(
              backgroundColor: ColorSet.bg3Color,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MobileHeader(
                        label: widget.isFromSignUp || needsOnboarding
                            ? AppLocalizations.of(context)!.chooseInterestsTitle
                            : AppLocalizations.of(context)!
                                .changeInterestsTitle,
                        showBackButton: !needsOnboarding,
                      ),
                      Gap(16.h),
                      Expanded(
                        child: _buildScrollableContent(
                          context,
                          state,
                          needsOnboarding,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScrollableContent(
    BuildContext context,
    InterestedHobbiesState state,
    bool needsOnboarding,
  ) {
    final showProfileExtras = !needsOnboarding && !widget.isFromSignUp;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProfileExtras) ...[
            BlocBuilder<LanguagesBloc, LanguagesState>(
              builder: (context, languageState) {
                return _LanguageChoiceChips(state: languageState);
              },
            ),
            Gap(40.h),
          ],
          Text(
            AppLocalizations.of(context)!
                .chooseUpToInterestsLabel(_maxSelections.toString()),
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          Gap(16.h),
          _buildInterestsContent(context, state),
          Gap(30.h),
          _buildSubmitButton(context, state, needsOnboarding),
          if (showProfileExtras) ...[
            Gap(42.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Text(
                AppLocalizations.of(context)!.earnMedalsAndRewardsTitle,
                style: context.textTheme.titleLargeBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 23.sp,
                ),
              ),
            ),
            Gap(30.h),
            MedalsList(
              medals: ProfileConfig.medals,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterestsContent(
    BuildContext context,
    InterestedHobbiesState state,
  ) {
    if (state.status == InterestedHobbiesStatus.failure &&
        state.interests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ?? 'Failed to load interests.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            Gap(16.h),
            AppButton.primary(
              label: AppLocalizations.of(context)!.retry,
              onPressed: () {
                context
                    .read<InterestedHobbiesBloc>()
                    .add(const InterestedHobbiesInit());
              },
            ),
          ],
        ),
      );
    }

    return InterestsGrid(
      interests: state.interests,
      selectedIds: state.selectedIds,
      isLoading: state.isFetching,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    InterestedHobbiesState state,
    bool needsOnboarding,
  ) {
    final responsive = context.responsive;
    final isSaving = state.status == InterestedHobbiesStatus.saving;

    return Align(
      alignment: responsive.isTablet ? Alignment.centerRight : Alignment.center,
      child: AppButton.primary(
        label: needsOnboarding
            ? AppLocalizations.of(context)!.continueLabel
            : AppLocalizations.of(context)!.save,
        fullWidth: !responsive.isTablet,
        width: responsive.isTablet ? 200.w : null,
        isLoading: isSaving,
        onPressed: state.isFetching || state.selectedCount == 0
            ? null
            : () {
                context
                    .read<InterestedHobbiesBloc>()
                    .add(const InterestedHobbiesSave());
              },
      ),
    );
  }
}

class _LanguageChoiceChips extends StatelessWidget {
  const _LanguageChoiceChips({required this.state});

  final LanguagesState state;

  @override
  Widget build(BuildContext context) {
    final languages = state.isLoading ? _placeholderLanguages : state.languages;

    if (state.status == LanguagesStatus.failure && languages.isEmpty) {
      return AppButton.secondary(
        label: AppLocalizations.of(context)!.retry,
        fullWidth: false,
        onPressed: () {
          context.read<LanguagesBloc>().add(const LanguagesRetry());
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.signInLanguageChoiceLabel}:',
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(4.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final language in languages)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: _LanguageChip(
                    language: language,
                    isSelected: !state.isLoading &&
                        language.code == state.selectedLanguageCode,
                    isDisabled: state.isLoading || state.isUpdating,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static final _placeholderLanguages = List.generate(
    3,
    (index) => TranslationLanguage(
      code: 'placeholder-$index',
      name: ['English', 'French', 'Spanish'][index],
      nativeName: ['English', 'French', 'Spanish'][index],
    ),
  );
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.language,
    required this.isSelected,
    required this.isDisabled,
  });

  final TranslationLanguage language;
  final bool isSelected;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final label =
        language.name.isNotEmpty ? language.name : language.nativeName;
    final bgColor =
        isSelected ? ColorSet.specialYellowColor : ColorSet.tileFillColor;
    final textColor = isSelected ? Colors.black : ColorSet.tileFontColor;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: isDisabled
            ? null
            : () {
                context.read<LanguagesBloc>().add(
                      LanguagesLanguageSelected(language.code),
                    );
              },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (isSelected
                    ? context.textTheme.bodyMediumBold
                    : context.textTheme.bodyMedium)
                .copyWith(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
