import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/models/history_statistics_models.dart';
import 'package:kuemele/shared/services/api_service/statistics/statistics_repo.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/money_earned_section.dart';
import 'package:kuemele/shared/widgets/reward_rings_section.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class HistoryAndStatistics extends StatefulWidget implements BasePage {
  const HistoryAndStatistics({super.key});

  @override
  State<HistoryAndStatistics> createState() => _HistoryAndStatisticsState();

  @override
  String get screenName => 'HistoryAndStatistics';
}

class _HistoryAndStatisticsState extends State<HistoryAndStatistics> {
  late final List<int> _years;
  late int _selectedYear;
  MonthlyStats? _stats;
  RewardStatus? _rewardStatus;
  // rewardSuggestion is omitted: no backend endpoint exists yet.
  // Per George's rule, frontend must not call AI/ML directly.

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    _selectedYear = currentYear;
    _years = List.generate(20, (index) => currentYear - index);
    _loadStats(currentYear);
    _loadRewardStatus();
  }

  Future<void> _loadStats(int year) async {
    setState(() => _selectedYear = year);
    try {
      final stats = await StatisticsRepo.getMonthlyStats(year: year);
      if (!mounted || year != _selectedYear) return;
      setState(() => _stats = stats);
    } catch (_) {
      if (!mounted || year != _selectedYear) return;
      setState(() => _stats = MonthlyStats(year: year, months: const []));
    }
  }

  Future<void> _loadRewardStatus() async {
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) return;
    try {
      final status = await StatisticsRepo.getRewardStatus(userId);
      if (!mounted) return;
      setState(() => _rewardStatus = status);
    } catch (_) {
      if (!mounted) return;
      setState(() => _rewardStatus = const RewardStatus(
            gold: 0,
            silver: 0,
            bronze: 0,
          ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: WidgetByDevice(
        tablet: buildTablet(),
        phone: ColoredBox(
          color: ColorSet.bg3Color,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  MobileHeader(label: AppLocalizations.of(context)!.historyTitle),
                  Gap(22),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        RewardRingsSection(
                          rewardStatus: _rewardStatus,
                          rewardSuggestion: null,
                        ),
                        SizedBox(height: 40),
                        _buildMoneyEarnedSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildTablet() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: ColorSet.bg3Color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.46),
                topRight: Radius.circular(7.46),
              ),
              border: Border(
                bottom: BorderSide(width: 0.37, color: Color(0xFFCECECE)),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.historyStatisticsTitle,
              textAlign: TextAlign.center,
              style: AppTextTheme.heading3.copyWith(
                color: ColorSet.revbg3Color,
                fontSize: 19.90,
                letterSpacing: -0.19,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: ShapeDecoration(
                color: ColorSet.bg3Color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7.46),
                    bottomRight: Radius.circular(7.46),
                  ),
                ),
              ),
              child: Utils.isPortrait
                  ? Column(
                      children: [
                        RewardRingsSection(
                          rewardStatus: _rewardStatus,
                          rewardSuggestion: null,
                        ),
                        SizedBox(height: 90),
                        _buildMoneyEarnedSection(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: RewardRingsSection(
                            rewardStatus: _rewardStatus,
                            rewardSuggestion: null,
                          ),
                        ),
                        SizedBox(width: 80),
                        Expanded(flex: 3, child: _buildMoneyEarnedSection()),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMoneyEarnedSection() {
    return MoneyEarnedSection(
      stats: _stats,
      selectedYear: _selectedYear,
      years: _years,
      onYearChanged: _loadStats,
    );
  }
}

// Custom Painter for Circle Chart

class CircleChartPainter extends CustomPainter {
  final String selectedMedal;

  CircleChartPainter({required this.selectedMedal});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintYellow = Paint()..color = Color(0xffCD7F32);
    Paint paintOrange = Paint()..color = Color(0xffADA997);
    Paint paintGrey = Paint()..color = Color(0xffDEB70F);

    if (selectedMedal == 'gold') {
      paintYellow = Paint()..color = Color(0xffDEB70F);
      paintOrange = Paint()..color = Color(0xffDEB70F);
      paintGrey = Paint()..color = Color(0xffDEB70F);
    } else if (selectedMedal == 'silver') {
      paintYellow = Paint()..color = Color(0xffADA997);
      paintOrange = Paint()..color = Color(0xffADA997);
      paintGrey = Paint()..color = Color(0xffADA997);
    } else if (selectedMedal == 'bronze') {
      paintYellow = Paint()..color = Color(0xffCD7F32);
      paintOrange = Paint()..color = Color(0xffCD7F32);
      paintGrey = Paint()..color = Color(0xffCD7F32);
    }

    double radius = size.width / 1 * 0.8;

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: radius),
      0,
      2 * 3.14 / 3,
      true,
      paintYellow,
    );
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: radius),
      2 * 3.14 / 3,
      2 * 3.14 / 3,
      true,
      paintOrange,
    );
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: radius),
      4 * 3.14 / 3,
      2 * 3.14 / 3,
      true,
      paintGrey,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
