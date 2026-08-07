import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/languages/bloc/languages_bloc.dart';
import 'package:kuemele/features/profile/presentation/languages/widgets/languages_list.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class LanguagesPage extends StatefulWidget implements BasePage {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();

  @override
  String get screenName => 'Languages';
}

class _LanguagesPageState extends State<LanguagesPage> {
  @override
  void initState() {
    super.initState();
    context.read<LanguagesBloc>().add(const LanguagesInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguagesBloc, LanguagesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.status != LanguagesStatus.failure,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message != null && message.isNotEmpty) {
          InjectionHelper.snackBar.showError(message);
        }
      },
      builder: (context, state) {
        return WidgetByDevice(
          tablet: AppTitledDialog(
            title: AppLocalizations.of(context)!.languages,
            child: _buildContent(state),
          ),
          phone: Scaffold(
            backgroundColor: ColorSet.bg3Color,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),
                child: Column(
                  children: [
                    MobileHeader(
                        label: AppLocalizations.of(context)!.languages),
                    Gap(22.h),
                    Expanded(
                      child: SingleChildScrollView(child: _buildContent(state)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(LanguagesState state) {
    if (state.status == LanguagesStatus.failure && state.languages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ??
                  AppLocalizations.of(context)!.languagesLoadFailed,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            Gap(16.h),
            AppButton.primary(
              label: AppLocalizations.of(context)!.retry,
              onPressed: () {
                context.read<LanguagesBloc>().add(const LanguagesRetry());
              },
            ),
          ],
        ),
      );
    }

    return LanguagesList(
      languages: state.languages,
      selectedLanguageCode: state.selectedLanguageCode,
      isLoading: state.isLoading,
      isUpdating: state.isUpdating,
    );
  }
}
