import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/onboarding/bloc/onboarding_bloc.dart';
import 'package:kuemele/features/auth/onboarding/onboarding_config.dart';
import 'package:kuemele/features/auth/onboarding/presentation/widgets/onboarding_username_field.dart';
import 'package:kuemele/features/auth/onboarding/presentation/widgets/onboarding_avatar_picker.dart';
import 'package:kuemele/features/auth/onboarding/presentation/widgets/onboarding_image_picker_sheet.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/onboarding_navigation.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class OnboardingPage extends StatefulWidget implements BasePage {
  const OnboardingPage({
    super.key,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();

  @override
  String get screenName => 'Onboarding';
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(const OnboardingReset());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: _onStateChanged,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MobileHeader(
                      label: AppLocalizations.of(context)!.onboardingPageTitle,
                      showBackButton: false,
                    ),
                    Gap(8.h),
                    Text(
                      AppLocalizations.of(context)!.onboardingPageSubtitle,
                      style: context.textTheme.bodyMedium.copyWith(
                        color: ColorSet.subTextColor,
                      ),
                    ),
                    Gap(24.h),
                    Expanded(child: _buildForm(context, state)),
                    Gap(16.h),
                    _buildContinueButton(context, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, OnboardingState state) async {
    if (state.errorMessage != null) {
      InjectionHelper.snackBar.showError(state.errorMessage!);
    }

    if (state.status == OnboardingStatus.success) {
      InjectionHelper.snackBar
          .showSuccess(AppLocalizations.of(context)!.onboardingSuccessMessage);
      OnboardingNavigation.goAfterOnboarding(context);
    }
  }

  Widget _buildForm(BuildContext context, OnboardingState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: OnboardingAvatarPicker(
              imagePath: state.profileImagePath,
              isLoading: state.isPickingImage,
              onTap: () => _showImagePicker(context),
              onClear: state.hasProfileImage
                  ? () => context
                      .read<OnboardingBloc>()
                      .add(const OnboardingClearImage())
                  : null,
            ),
          ),
          Gap(28.h),
          OnboardingUsernameField(
            controller: _usernameController,
          ),
          Gap(24.h),
          KumeleTextField(
            controller: _phoneController,
            labelText: AppLocalizations.of(context)!.onboardingPhoneLabel,
            hintText: AppLocalizations.of(context)!.onboardingPhoneHint,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          Gap(24.h),
          KumeleTextArea(
            controller: _aboutController,
            labelText: AppLocalizations.of(context)!.onboardingAboutLabel,
            hintText: AppLocalizations.of(context)!.onboardingAboutHint,
            isRequired: true,
            maxLines: 8,
            minLines: 6,
            maxLength: OnboardingConfig.aboutMaxLength,
            showCharacterCount: true,
            labelGap: 6,
            characterCountFormatter: (length) =>
                '$length/${OnboardingConfig.aboutMaxLength} (min ${OnboardingConfig.aboutMinLength})',
            onChanged: (_) => setState(() {}),
          ),
          Gap(24.h),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, OnboardingState state) {
    final responsive = context.responsive;
    final aboutLength = _aboutController.text.trim().length;
    final username = _usernameController.text.trim();
    final canSubmit = state.hasProfileImage &&
        aboutLength >= OnboardingConfig.aboutMinLength &&
        aboutLength <= OnboardingConfig.aboutMaxLength &&
        (username.isEmpty || state.isUsernameAvailable == true);

    return Align(
      alignment: responsive.isTablet ? Alignment.centerRight : Alignment.center,
      child: AppButton.primary(
        label: AppLocalizations.of(context)!.continueLabel,
        isLoading: state.isSubmitting,
        onPressed: canSubmit && !state.isSubmitting ? _onSubmit : null,
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    await OnboardingImagePickerSheet.show(
      context: context,
      onSourceSelected: (source) {
        context.read<OnboardingBloc>().add(OnboardingPickImage(source));
      },
    );
  }

  void _onSubmit() {
    context.read<OnboardingBloc>().add(
          OnboardingSubmit(
            about: _aboutController.text,
            phone: _phoneController.text,
            username: _usernameController.text,
          ),
        );
  }
}
