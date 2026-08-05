import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/auth/onboarding/onboarding_config.dart';
import 'package:kuemele/features/auth/onboarding/presentation/widgets/onboarding_image_picker_sheet.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/edit_profile_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/edit_profile_avatar_section.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/edit_profile_username_field.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (previous, current) =>
          previous.isInitialized != current.isInitialized ||
          previous.username != current.username ||
          previous.firstName != current.firstName ||
          previous.lastName != current.lastName ||
          previous.bio != current.bio ||
          previous.phone != current.phone ||
          previous.avatarUrl != current.avatarUrl ||
          previous.localImagePath != current.localImagePath ||
          previous.status != current.status ||
          previous.isCheckingUsername != current.isCheckingUsername ||
          previous.isUsernameAvailable != current.isUsernameAvailable ||
          previous.originalUsername != current.originalUsername,
      builder: (context, state) {
        if (!state.isInitialized) {
          return const SizedBox.shrink();
        }

        final bloc = context.read<EditProfileBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: EditProfileAvatarSection(
                displayName: state.displayName,
                avatarUrl: state.avatarUrl,
                localImagePath: state.localImagePath,
                isLoading: state.isPickingImage,
                onTap: () => _showImagePicker(context),
                onClear: state.hasLocalImage
                    ? () => bloc.add(const EditProfileClearImage())
                    : null,
              ),
            ),
            Gap(28.h),
            EditProfileUsernameField(value: state.username),
            Gap(24.h),
            _BlocSyncedTextField(
              value: state.firstName,
              labelText: AppStrings.editProfileFirstNameLabel,
              hintText: AppStrings.editProfileFirstNameHint,
              textInputAction: TextInputAction.next,
              onChanged: (value) =>
                  bloc.add(EditProfileFirstNameChanged(value)),
            ),
            Gap(24.h),
            _BlocSyncedTextField(
              value: state.lastName,
              labelText: AppStrings.editProfileLastNameLabel,
              hintText: AppStrings.editProfileLastNameHint,
              textInputAction: TextInputAction.next,
              onChanged: (value) => bloc.add(EditProfileLastNameChanged(value)),
            ),
            Gap(24.h),
            _BlocSyncedTextField(
              value: state.phone,
              labelText: AppStrings.editProfilePhoneLabel,
              hintText: AppStrings.editProfilePhoneHint,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => bloc.add(EditProfilePhoneChanged(value)),
            ),
            Gap(24.h),
            _BlocSyncedTextArea(
              value: state.bio,
              labelText: AppStrings.editProfileAboutLabel,
              hintText: AppStrings.editProfileAboutHint,
              maxLength: OnboardingConfig.aboutMaxLength,
              characterCountFormatter: (length) =>
                  '$length/${OnboardingConfig.aboutMaxLength} (min ${OnboardingConfig.aboutMinLength})',
              onChanged: (value) => bloc.add(EditProfileBioChanged(value)),
            ),
            Gap(24.h),
          ],
        );
      },
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final bloc = context.read<EditProfileBloc>();
    await OnboardingImagePickerSheet.show(
      context: context,
      onSourceSelected: (source) {
        bloc.add(EditProfilePickImage(source));
      },
    );
  }
}

class _BlocSyncedTextField extends StatefulWidget {
  const _BlocSyncedTextField({
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_BlocSyncedTextField> createState() => _BlocSyncedTextFieldState();
}

class _BlocSyncedTextFieldState extends State<_BlocSyncedTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_handleChanged);
  }

  @override
  void didUpdateWidget(covariant _BlocSyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  void _handleChanged() {
    if (_controller.text != widget.value) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KumeleTextField(
      controller: _controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
    );
  }
}

class _BlocSyncedTextArea extends StatefulWidget {
  const _BlocSyncedTextArea({
    required this.value,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.maxLength,
    required this.characterCountFormatter,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String labelText;
  final String hintText;
  final int maxLength;
  final String Function(int length) characterCountFormatter;

  @override
  State<_BlocSyncedTextArea> createState() => _BlocSyncedTextAreaState();
}

class _BlocSyncedTextAreaState extends State<_BlocSyncedTextArea> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_handleChanged);
  }

  @override
  void didUpdateWidget(covariant _BlocSyncedTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  void _handleChanged() {
    if (_controller.text != widget.value) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KumeleTextArea(
      controller: _controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      isRequired: true,
      maxLines: 8,
      minLines: 6,
      maxLength: widget.maxLength,
      showCharacterCount: true,
      labelGap: 6,
      characterCountFormatter: widget.characterCountFormatter,
    );
  }
}
