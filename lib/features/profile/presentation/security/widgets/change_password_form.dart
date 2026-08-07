import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/profile/presentation/security/bloc/change_password_bloc.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.currentPassword != current.currentPassword ||
          previous.newPassword != current.newPassword ||
          previous.confirmPassword != current.confirmPassword ||
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        final bloc = context.read<ChangePasswordBloc>();
        final l10n = AppLocalizations.of(context)!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BlocSyncedPasswordField(
              value: state.currentPassword,
              labelText: l10n.changePasswordCurrentLabel,
              hintText: l10n.changePasswordCurrentHint,
              textInputAction: TextInputAction.next,
              enabled: !state.isSubmitting,
              onChanged: (value) =>
                  bloc.add(ChangePasswordCurrentChanged(value)),
            ),
            Gap(24.h),
            _BlocSyncedPasswordField(
              value: state.newPassword,
              labelText: l10n.changePasswordNewLabel,
              hintText: l10n.changePasswordNewHint,
              textInputAction: TextInputAction.next,
              enabled: !state.isSubmitting,
              onChanged: (value) => bloc.add(ChangePasswordNewChanged(value)),
            ),
            Gap(24.h),
            _BlocSyncedPasswordField(
              value: state.confirmPassword,
              labelText: l10n.changePasswordConfirmLabel,
              hintText: l10n.changePasswordConfirmHint,
              textInputAction: TextInputAction.done,
              enabled: !state.isSubmitting,
              onChanged: (value) =>
                  bloc.add(ChangePasswordConfirmChanged(value)),
            ),
            Gap(16.h),
          ],
        );
      },
    );
  }
}

class _BlocSyncedPasswordField extends StatefulWidget {
  const _BlocSyncedPasswordField({
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
  State<_BlocSyncedPasswordField> createState() =>
      _BlocSyncedPasswordFieldState();
}

class _BlocSyncedPasswordFieldState extends State<_BlocSyncedPasswordField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_handleChanged);
  }

  @override
  void didUpdateWidget(covariant _BlocSyncedPasswordField oldWidget) {
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
    return KumeleTextField.password(
      controller: _controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
    );
  }
}
