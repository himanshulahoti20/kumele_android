import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/auth/onboarding/presentation/widgets/onboarding_image_picker_sheet.dart';
import 'package:kuemele/features/profile/presentation/contact/bloc/contact_bloc.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_dropdown.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/widgets/kumele_image_picker.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      buildWhen: (previous, current) =>
          previous.subject != current.subject ||
          previous.description != current.description ||
          previous.category != current.category ||
          previous.priority != current.priority ||
          previous.attachmentPath != current.attachmentPath ||
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        final bloc = context.read<ContactBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.contactPageSubtitle,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.subTextColor,
              ),
            ),
            Gap(24.h),
            _BlocSyncedTextField(
              value: state.subject,
              labelText: AppStrings.contactSubjectLabel,
              hintText: AppStrings.contactSubjectHint,
              textInputAction: TextInputAction.next,
              enabled: !state.isSubmitting,
              onChanged: (value) => bloc.add(ContactSubjectChanged(value)),
            ),
            Gap(24.h),
            _FieldLabel(label: AppStrings.contactCategoryLabel),
            Gap(8.h),
            KumeleDropdown(
              value: state.category.label,
              items: SupportTicketCategory.values
                  .map((category) => category.label)
                  .toList(),
              onSelected: (_, index) => bloc.add(
                ContactCategoryChanged(SupportTicketCategory.values[index]),
              ),
            ),
            Gap(24.h),
            _FieldLabel(label: AppStrings.contactPriorityLabel),
            Gap(8.h),
            KumeleDropdown(
              value: state.priority.label,
              items: SupportTicketPriority.values
                  .map((priority) => priority.label)
                  .toList(),
              onSelected: (_, index) => bloc.add(
                ContactPriorityChanged(SupportTicketPriority.values[index]),
              ),
            ),
            Gap(24.h),
            _BlocSyncedTextArea(
              value: state.description,
              labelText: AppStrings.contactDescriptionLabel,
              hintText: AppStrings.contactDescriptionHint,
              enabled: !state.isSubmitting,
              onChanged: (value) => bloc.add(ContactDescriptionChanged(value)),
            ),
            Gap(24.h),
            _FieldLabel(label: AppStrings.contactAttachmentLabel),
            Gap(8.h),
            KumeleImagePicker(
              height: 140.h,
              imagePath: state.attachmentPath,
              isLoading: state.isSubmitting,
              placeholderText: AppStrings.contactAttachmentHint,
              onTap: () => _pickAttachment(context, bloc),
              onClear: state.hasAttachment && !state.isSubmitting
                  ? () => bloc.add(const ContactAttachmentCleared())
                  : null,
            ),
            Gap(16.h),
          ],
        );
      },
    );
  }

  Future<void> _pickAttachment(BuildContext context, ContactBloc bloc) async {
    await OnboardingImagePickerSheet.show(
      context: context,
      onSourceSelected: (source) =>
          bloc.add(ContactAttachmentSourceSelected(source)),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.bodyMedium.copyWith(
        color: ColorSet.textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BlocSyncedTextField extends StatefulWidget {
  const _BlocSyncedTextField({
    required this.value,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.textInputAction,
    this.enabled = true,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String labelText;
  final String hintText;
  final TextInputAction? textInputAction;
  final bool enabled;

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
      enabled: widget.enabled,
    );
  }
}

class _BlocSyncedTextArea extends StatefulWidget {
  const _BlocSyncedTextArea({
    required this.value,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.enabled = true,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String labelText;
  final String hintText;
  final bool enabled;

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
      maxLines: 8,
      labelText: widget.labelText,
      hintText: widget.hintText,
      labelGap: 6,
      enabled: widget.enabled,
    );
  }
}
