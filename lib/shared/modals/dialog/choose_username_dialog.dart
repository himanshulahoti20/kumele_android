import 'package:kuemele/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class ChooseUsernameDialog extends StatefulWidget {
  const ChooseUsernameDialog({super.key});

  @override
  State<ChooseUsernameDialog> createState() => _ChooseUsernameDialogState();
}

class _ChooseUsernameDialogState extends State<ChooseUsernameDialog> {
  final usernameCtrl = TextEditingController();

  @override
  void dispose() {
    usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: AppTitledDialog(
        titleWidget: buildHeader(),
        child: buildContent(context),
      ),
      phone: AppBottomSheet(
        titleWidget: buildHeader(),
        showCloseButton: false,
        child: buildContent(context),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      spacing: 10,
      children: [
        AppSvgImage(
            assetName: SVGAsset.icon_profile,
            color: ColorSet.textColor,
            width: 30,
            height: 30),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.chooseUsernameTitle,
            style: context.textTheme.heading3,
            textAlign: TextAlign.center,
          ),
        ),
        AppSvgImage(
            assetName: SVGAsset.icon_close,
            color: ColorSet.textColor,
            width: 30,
            height: 30),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        Text(
          AppLocalizations.of(context)!.chooseUsernameDescription,
          style: context.textTheme.bodyLarge
              .copyWith(fontSize: 15, color: '#BCBCBC'.toColor()),
        ),
        KumeleTextField.password(
          controller: usernameCtrl,
          labelText: AppLocalizations.of(context)!.onboardingUsernameLabel,
          hintText: AppLocalizations.of(context)!.chooseUsernameHint,
        ),
        AppButton.primary(
          label: AppLocalizations.of(context)!.chooseUsernameSkip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.home);
            }
          },
        ),
        AppButton.primary(
          label: AppLocalizations.of(context)!.save,
          onPressed: () {},
        ),
      ],
    );
  }
}
