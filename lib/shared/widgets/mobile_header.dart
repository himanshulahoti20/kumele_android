import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class MobileHeader extends StatelessWidget {
  final String label;
  final List<Widget> actions;
  final bool showBackButton;

  const MobileHeader({
    super.key,
    required this.label,
    this.actions = const [],
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 12),
            child: ClickWidget(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  InjectionHelper.homePageCubit
                      .onTapTab(context, HomeTabType.home);
                }
              },
              child: RotatedBox(
                quarterTurns: 2,
                child: KumeleAssetWidget(
                  assetPath: SVGAsset.icon_arrow,
                  color: ColorSet.revbg3Color,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.titleLargeBold.copyWith(fontSize: 23),
          ),
        ),
        ...actions,
      ],
    );
  }
}
