import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/contact/bloc/contact_bloc.dart';
import 'package:kuemele/features/profile/presentation/contact/widgets/contact_form.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class ContactPage extends StatefulWidget implements BasePage {
  const ContactPage({super.key, this.routeArgs});

  final ContactRouteArgs? routeArgs;

  @override
  State<ContactPage> createState() => _ContactPageState();

  @override
  String get screenName => 'Contact';
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    final args = widget.routeArgs;
    InjectionHelper.contactBloc.add(
      ContactOpened(
        relatedEntityId: args?.relatedEntityId,
        relatedEntityType: args?.relatedEntityType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      bloc: InjectionHelper.contactBloc,
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: _onStateChanged,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
              child: Column(
                children: [
                  MobileHeader(label: AppStrings.contact),
                  Gap(22.h),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, ContactState state) {
    final errorMessage = state.errorMessage;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      InjectionHelper.snackBar.showError(errorMessage);
    }

    if (state.status == ContactStatus.success) {
      InjectionHelper.snackBar.showSuccess(
        state.successMessage ?? AppStrings.contactSuccessMessage,
      );
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  Widget _buildBody(BuildContext context, ContactState state) {
    return Column(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: ContactForm(),
          ),
        ),
        AppButton.primary(
          label: AppStrings.contactSubmitLabel,
          fullWidth: true,
          isLoading: state.isSubmitting,
          onPressed: state.isSubmitting
              ? null
              : () => InjectionHelper.contactBloc.add(const ContactSubmitted()),
        ),
      ],
    );
  }
}
