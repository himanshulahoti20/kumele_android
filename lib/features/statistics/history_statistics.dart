import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/medals.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/money_earned_section.dart';
import 'package:kuemele/shared/widgets/reward_rings_section.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class HistoryAndStatistics extends StatefulWidget implements BasePage {
  HistoryAndStatistics({super.key});

  @override
  _HistoryAndStatisticsState createState() => _HistoryAndStatisticsState();

  @override
  String get screenName => 'HistoryAndStatistics';
}

class _HistoryAndStatisticsState extends State<HistoryAndStatistics> {
  int selectedIndex = -1;
  String selectedMedal = '';
  String? selectedYear;
  final List<String> years =
      List.generate(20, (index) => (2000 + index).toString());
  bool isDropdownOpen = false; // Track dropdown open/close state

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
                  MobileHeader(label: 'History'),
                  Gap(22),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        RewardRingsSection(),
                        SizedBox(height: 40),
                        MoneyEarnedSection(),
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
              'History & Statistics',
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
                        RewardRingsSection(),
                        SizedBox(height: 90),
                        MoneyEarnedSection(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 2, child: RewardRingsSection()),
                        SizedBox(width: 80),
                        Expanded(flex: 3, child: MoneyEarnedSection()),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void showMedalInfo(String medalType) {
    setState(() {
      selectedMedal = medalType;
    });
    Medals.medalDialog(context, medalType);
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
