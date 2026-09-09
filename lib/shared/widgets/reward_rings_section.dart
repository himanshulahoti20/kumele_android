import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/medals.dart';
import 'package:kuemele/shared/models/aiml_models.dart';
import 'package:kuemele/shared/models/history_statistics_models.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class RewardRingsSection extends StatelessWidget {
  const RewardRingsSection({
    super.key,
    this.rewardStatus,
    this.rewardSuggestion,
  });

  final RewardStatus? rewardStatus;
  final AimlRewardsSuggestion? rewardSuggestion;

  @override
  Widget build(BuildContext context) {
    final double chartSize = FormFactor.isTablet ? 200 : 200;
    final gold = rewardStatus?.gold ?? 0;
    final silver = rewardStatus?.silver ?? 0;
    final bronze = rewardStatus?.bronze ?? 0;
    final hasRewards = gold + silver + bronze > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.rewardRingsTitle,
              style: context.textTheme.titleLarge.copyWith(
                color: ColorSet.revbg3Color,
                fontSize: 21.50,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
                height: 40, width: 40, child: Image.asset(IconSet.medalIcon)),
          ],
        ),
        Gap(FormFactor.isTablet ? 31 : 24),
        Row(
          children: [
            SizedBox(
              height: chartSize,
              width: chartSize,
              child: hasRewards
                  ? PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: [
                          PieChartSectionData(
                            value: bronze.toDouble(),
                            color: const Color(0xFFCD7F32),
                            title: '',
                            radius: 90,
                          ),
                          PieChartSectionData(
                            value: silver.toDouble(),
                            color: const Color(0xFFC4C4C4),
                            title: '',
                            radius: 90,
                          ),
                          PieChartSectionData(
                            value: gold.toDouble(),
                            color: const Color(0xFFDEB70F),
                            title: '',
                            radius: 90,
                          ),
                        ],
                      ),
                    )
                  // No medals yet — empty ring instead of a fake equal-split
                  // pie (previous behavior rendered a solid-looking circle
                  // even with zero medals).
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorSet.border, width: 2),
                      ),
                    ),
            ),
            SizedBox(width: FormFactor.isTablet ? 38 : 16),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(
                    'Gold',
                    'Achieved $gold ${gold == 1 ? 'medal' : 'medals'}',
                    const Color(0xFFDEB70F),
                    () => Medals.medalDialog(context, 'gold'),
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    'Silver',
                    'Achieved $silver ${silver == 1 ? 'medal' : 'medals'}',
                    const Color(0xFFC4C4C4),
                    () => Medals.medalDialog(context, 'silver'),
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    'Bronze',
                    'Achieved $bronze ${bronze == 1 ? 'medal' : 'medals'}',
                    const Color(0xFFCD7F32),
                    () => Medals.medalDialog(context, 'bronze'),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (rewardSuggestion?.label.isNotEmpty ?? false) ...[
          const Gap(16),
          Text(
            rewardSuggestion!.label,
            style: AppTextTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
              fontSize: FormFactor.isTablet ? 17.4750 : 14,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLegendItem(
      String title, String subtitle, Color color, VoidCallback onPressed) {
    final double circleSize = FormFactor.isTablet ? 27 : 20;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: AppTextTheme.titleLarge.copyWith(
                      color: ColorSet.revbg3Color,
                      fontSize: FormFactor.isTablet ? 21.50 : 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClickWidget(
                    onPressed: onPressed,
                    child: KumeleAssetWidget(
                      assetPath: SVGAsset.icon_info,
                      color: ColorSet.revbg3Color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextTheme.bodyLarge.copyWith(
                  color: ColorSet.textColor,
                  fontSize: FormFactor.isTablet ? 17.4750 : 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
