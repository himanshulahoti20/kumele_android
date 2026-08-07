import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/models/history_statistics_models.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class MoneyEarnedSection extends StatefulWidget {
  const MoneyEarnedSection({
    super.key,
    required this.stats,
    required this.selectedYear,
    required this.years,
    required this.onYearChanged,
  });

  final MonthlyStats? stats;
  final int selectedYear;
  final List<int> years;
  final ValueChanged<int> onYearChanged;

  @override
  State<MoneyEarnedSection> createState() => _MoneyEarnedSectionState();
}

class _MoneyEarnedSectionState extends State<MoneyEarnedSection> {
  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  int? selectedBarIndex;

  List<MonthlyStatMonth> get _months {
    final source = widget.stats?.months ?? const [];
    return List.generate(12, (index) {
      final label = months[index];
      return source.firstWhere(
        (month) => month.label.toLowerCase().startsWith(label.toLowerCase()),
        orElse: () => MonthlyStatMonth(label: label, value: 0),
      );
    });
  }

  bool showingTooltip(int barIndex) {
    return selectedBarIndex != null && selectedBarIndex == barIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 800,
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.moneyEarnedTitle,
                      style: context.textTheme.bodyLarge.copyWith(
                        color: ColorSet.revbg3Color,
                        fontSize: 18.94,
                      ),
                    ),
                    SizedBox(width: 4.97),
                    Text(
                      '€${(widget.stats?.totalMoneyEarned ?? 0).toStringAsFixed(0)}',
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: ColorSet.revbg3Color,
                        fontSize: 18.94,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                buildDropdownButton(),
                // Gap(70),
              ],
            ),
          ),
          const SizedBox(height: 40),
          buildChart(),
        ],
      ),
    );
  }

  Widget buildChart() {
    return SizedBox(
      width: 800,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            ...buildTooltip(),
            Container(
              height: 250,
              width: 800,
              margin: const EdgeInsets.only(top: 40),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _maxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchTooltipData: null,
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() {
                          selectedBarIndex =
                              response.spot!.touchedBarGroupIndex;
                        });
                      } else if (event is FlTapDownEvent) {
                        setState(() {
                          selectedBarIndex = null;
                        });
                      }
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: AppTextTheme.bodyLarge.copyWith(
                                color: ColorSet.textColor,
                                fontSize: 15.23,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    for (var i = 0; i < _months.length; i++)
                      _createBarGroup(i, _months[i].value.toDouble()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildTooltip() {
    if (selectedBarIndex == null) return [];
    final selectedMonth = _months[selectedBarIndex!];
    final events = selectedMonth.events;
    const spacing = (800 - (40 * 12)) / 12;
    final lineLeftPos =
        ((spacing / 2) + (selectedBarIndex!) * (40 + spacing)) + (40 / 2) - 3;
    final tooltipLeftPos = selectedBarIndex! > 9
        ? null
        : selectedBarIndex! < 2
            ? 0.0
            : ((spacing / 2) + (selectedBarIndex!) * (40 + spacing)) +
                (40 / 2) -
                (234 / 2);

    return [
      Positioned(
        left: tooltipLeftPos,
        right: tooltipLeftPos == null ? 0 : null,
        child: Container(
          width: 234,
          height: 47,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: ShapeDecoration(
            color: '#F4F4F4'.toColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.01),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              if (events.isEmpty)
                buildTooltipItem(
                  selectedMonth.label,
                  'Total',
                  'assets/svg/icon_dollar.svg',
                  selectedMonth.value,
                )
              else
                for (var i = 0; i < events.length; i++) ...[
                  if (i > 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.5),
                      child: VerticalDivider(
                          color: Color(0xFFD4D4D4), width: 1, thickness: 1),
                    ),
                  buildTooltipItem(
                    events[i].title,
                    events[i].category,
                    events[i].icon ?? 'assets/svg/icon_dollar.svg',
                    events[i].value,
                  ),
                ],
            ],
          ),
        ),
      ),
      Positioned(
        top: 45,
        left: lineLeftPos,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.50,
          children: List.filled(30, 1).map((e) => buildDot()).toList(),
        ),
      ),
    ];
  }

  Widget buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration:
          const ShapeDecoration(color: Color(0xFFEEEBEB), shape: OvalBorder()),
    );
  }

  double get _maxY {
    final max = _months.fold<num>(0, (value, month) {
      return month.value > value ? month.value : value;
    });
    return max <= 0 ? 100 : max.toDouble();
  }

  Widget buildTooltipItem(
      String title, String subtitle, String icon, num value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          title,
          style: AppTextTheme.bodySmallBold.copyWith(
            color: Colors.black,
            fontSize: 13.76,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 3.94,
          children: [
            Text(
              '€${value.toStringAsFixed(0)}',
              style: AppTextTheme.labelSmallBold.copyWith(
                color: '#5E5E5E'.toColor(),
                fontSize: 10.48,
              ),
            ),
            KumeleAssetWidget(
                assetPath: icon,
                width: 13.48,
                height: 13.48,
                color: '#000000'.toColor()),
            Text(
              subtitle,
              style: AppTextTheme.labelSmall.copyWith(
                color: '#000000'.toColor(),
                fontSize: 10.48,
              ),
            ),
          ],
        ),
      ],
    );
  }

  BarChartGroupData _createBarGroup(int x, double y) {
    final isSelected = selectedBarIndex == x;
    return BarChartGroupData(
      x: x,
      // showingTooltipIndicators: showingTooltip(x) ? [0] : [],
      // barsSpace: 18,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isSelected ? const Color(0xFFFFC533) : const Color(0xFF004DFF),
          width: 40,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7.03),
            topRight: Radius.circular(7.03),
          ),
        ),
      ],
    );
  }

  void _attachA(BuildContext context) {
    SmartDialog.showAttach(
      targetContext: context,
      alignment: Alignment.bottomCenter,
      maskColor: ColorSet.bcColor,
      builder: (_) => _listDialog(),
    );
  }

  Widget _listDialog() {
    return Container(
      width: 93.14,
      padding: const EdgeInsets.symmetric(vertical: 6.84),
      decoration: ShapeDecoration(
        color: ColorSet.bg2Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.29),
        ),
      ),
      child: Column(
        spacing: 12.44,
        children: widget.years.map((year) {
          return GestureDetector(
            onTap: () {
              SmartDialog.dismiss();
              widget.onYearChanged(year);
            },
            child: Text(
              year.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorSet.textColor,
                fontSize: 12.59,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDropdownButton() {
    return Builder(
      builder: (c) {
        return GestureDetector(
          onTap: () => _attachA(c),
          child: Container(
            width: 93.14,
            height: 35.31,
            padding: const EdgeInsets.only(
              top: 5.37,
              left: 10.75,
              right: 5.37,
              bottom: 5.37,
            ),
            decoration: ShapeDecoration(
              color: ColorSet.bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.37),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5.37,
              children: [
                Text(
                  widget.selectedYear.toString(),
                  textAlign: TextAlign.right,
                  style: context.textTheme.bodyLarge.copyWith(
                    color: ColorSet.revbg3Color,
                    fontSize: 17.47,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: KumeleAssetWidget(
                      assetPath: SVGAsset.icon_arrow,
                      color: ColorSet.revbg3Color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
