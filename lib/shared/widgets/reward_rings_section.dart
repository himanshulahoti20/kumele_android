import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/medals.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class RewardRingsSection extends StatelessWidget {
  const RewardRingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double chartSize = FormFactor.isTablet ? 200 : 200;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reward Rings',
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
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: const Color(0xFFCD7F32),
                      title: '',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: 35,
                      color: const Color(0xFFC4C4C4),
                      title: '',
                      radius: 90,
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: const Color(0xFFDEB70F),
                      title: '',
                      radius: 90,
                    ),
                  ],
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
                    'Achieved 22 medals',
                    const Color(0xFFDEB70F),
                    () => Medals.medalDialog(context, 'gold'),
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    'Silver',
                    'Achieved 1 medal',
                    const Color(0xFFC4C4C4),
                    () => Medals.medalDialog(context, 'silver'),
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    'Bronze',
                    'Achieved 1 medal',
                    const Color(0xFFCD7F32),
                    () => Medals.medalDialog(context, 'bronze'),
                  ),
                ],
              ),
            ),
          ],
        ),
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
