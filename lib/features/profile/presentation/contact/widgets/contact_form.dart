import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/contact/bloc/contact_bloc.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_config.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      buildWhen: (previous, current) =>
          previous.reason != current.reason ||
          previous.description != current.description ||
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        final bloc = context.read<ContactBloc>();
        final textStyle = context.textTheme.bodyLarge.copyWith(
          color: ColorSet.textColor,
          fontSize: 16.sp,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.reportEventChooseReasonLabel,
              style: textStyle,
            ),
            Gap(14.h),
            for (final reason in ContactReason.values) ...[
              _ContactRadio(
                label: reason.label,
                selected: state.reason == reason,
                enabled: !state.isSubmitting,
                onTap: () => bloc.add(ContactReasonChanged(reason)),
              ),
              if (reason != ContactReason.values.last) Gap(10.h),
            ],
            Gap(20.h),
            Text(AppLocalizations.of(context)!.comment, style: textStyle),
            Gap(12.h),
            _CommentField(
              value: state.description,
              enabled: !state.isSubmitting,
              onChanged: (value) => bloc.add(ContactDescriptionChanged(value)),
            ),
          ],
        );
      },
    );
  }
}

class _ContactRadio extends StatelessWidget {
  const _ContactRadio({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: selected,
      enabled: enabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? ColorSet.specialBlueColor
                      : const Color(0xFFBCBCBC),
                  width: 2.r,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 12.r,
                  height: 12.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? ColorSet.specialBlueColor
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
            Gap(9.w),
            Text(
              label,
              style: context.textTheme.bodyLarge.copyWith(
                color: ColorSet.textColor,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentField extends StatefulWidget {
  const _CommentField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  State<_CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<_CommentField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _CommentField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hint = AppLocalizations.of(context)!.addYourComment;

    return SizedBox(
      height: 136.h,
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        expands: true,
        maxLines: null,
        minLines: null,
        onChanged: widget.onChanged,
        textAlignVertical: TextAlignVertical.top,
        style: context.textTheme.bodyLarge.copyWith(
          color: ColorSet.textColor,
          fontSize: 15.sp,
        ),
        decoration: InputDecoration(
          hintText: hint.replaceFirst(RegExp(r'\.{3}$'), ''),
          hintStyle: context.textTheme.bodyLarge.copyWith(
            color: ColorSet.subTextColor,
            fontSize: 15.sp,
          ),
          filled: true,
          fillColor: ColorSet.textBoxBgColor,
          contentPadding: EdgeInsets.all(16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.r),
            borderSide: BorderSide(color: ColorSet.textColor, width: 1.5.w),
          ),
        ),
      ),
    );
  }
}
