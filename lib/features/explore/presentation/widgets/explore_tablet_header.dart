import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class ExploreTabletHeader extends StatelessWidget {
  const ExploreTabletHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 55),
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        children: [
          Text(
            AppLocalizations.of(context)!.exploreTabletHeaderTitle,
            style: AppTextTheme.heading2.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(height: 50),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: ExploreConfig.headerActionButtons
                  .map(_ExploreActionChip.new)
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreActionChip extends StatelessWidget {
  const _ExploreActionChip(this.item);

  final ExploreActionButtonItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KumeleAssetWidget.square(
            assetPath: item.iconPath,
            size: 20,
          ),
          const Gap(8),
          Text(
            item.label,
            style: AppTextTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
