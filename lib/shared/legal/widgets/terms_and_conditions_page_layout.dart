import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/legal/terms_of_use_data.dart';
import 'package:kuemele/shared/legal/widgets/legal_document_body.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class TermsAndConditionsPageLayout extends StatelessWidget {
  const TermsAndConditionsPageLayout({
    super.key,
    this.title,
    this.content,
    this.onTabletBack,
    this.onWillPop,
  });

  final String? title;
  final String? content;
  final VoidCallback? onTabletBack;
  final Future<bool> Function()? onWillPop;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: WidgetByDevice(
        tablet: _buildTablet(context),
        phone: Container(
          color: ColorSet.bg3Color,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  MobileHeader(label: AppLocalizations.of(context)!.termsAndConditions),
                  Gap(22),
                  Expanded(
                    child: SingleChildScrollView(
                      child: buildContent(context, title, content),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (onWillPop == null) {
      return scaffold;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await onWillPop!();
        if (shouldPop && context.mounted) context.pop();
      },
      child: scaffold,
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorSet.bg3Color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onTabletBack ?? () => context.pop(),
                    child: Image.asset(
                      IconSet.arrowleft,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gap(40),
                  Text(
                    AppLocalizations.of(context)!.termsAndConditions,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5, color: Colors.grey[200]),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: buildContent(context, title, content),
              ),
            ),
            Gap(20),
          ],
        ),
      ),
    );
  }

  static Widget buildContent(
    BuildContext context, [
    String? title,
    String? content,
  ]) {
    final body = content?.trim();
    if (body != null && body.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Text(
            title?.trim().isNotEmpty == true
                ? title!.trim()
                : 'Kumele Terms of use',
            style: context.textTheme.bodyLarge,
          ),
          Gap(20),
          Text(
            body,
            style: context.textTheme.bodySmall.copyWith(fontSize: 13),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.justify,
          ),
        ],
      );
    }

    // Fall back to the native Terms of Use content (mirrors the iOS
    // `TermsOfUseNativeView`) when no document is available from the API.
    return LegalDocumentBody(blocks: TermsOfUseData.blocks);
  }
}
