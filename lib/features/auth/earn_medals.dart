import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:lottie/lottie.dart';

import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class EarnMedals extends StatefulWidget {
  const EarnMedals({super.key});

  @override
  State<EarnMedals> createState() => _EarnMedalsState();
}

class _EarnMedalsState extends State<EarnMedals> {
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isPortrait = responsive.isPortrait;
    final screenWidth = responsive.screenSize.width;
    final screenHeight = responsive.screenSize.height;

    double dialogWidth = isPortrait ? screenWidth * 0.9 : screenWidth * 0.65;
    double dialogHeight = isPortrait ? screenHeight * 0.4 : screenHeight * 0.65;
    double subtitleFontSize = 15;
    double iconSize = isPortrait ? size(15) : size(25);
    double padding = isPortrait ? size(10) : size(30);

    List<MedalsModel> medals = [
      MedalsModel(
        image: IconSet.medalIcon,
        title: AppLocalizations.of(context)!.bronzeStatus,
        subtitle: AppLocalizations.of(context)!.bronzeStatusDescription,
      ),
      MedalsModel(
        image: IconSet.medalIcon,
        title: AppLocalizations.of(context)!.silverStatus,
        subtitle: AppLocalizations.of(context)!.silverStatusDescription,
      ),
      MedalsModel(
        image: IconSet.medalIcon,
        title: AppLocalizations.of(context)!.goldStatusMedal,
        subtitle: AppLocalizations.of(context)!.goldStatusMedalDescription,
      ),
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: ColorSet.bg2Color,
          borderRadius: BorderRadius.circular(isPortrait ? 20 : 10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.earnMedals,
                    style: context.textTheme.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: isPortrait ? 0 : 0,
                    left: isPortrait ? 20 : 0,
                    right: isPortrait ? 40 : 0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: medals.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: isPortrait ? size(20) : size(35)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: isPortrait ? size(15) : size(25)),
                          Lottie.asset(
                            IconSet.jsonPrize,
                            fit: BoxFit.fill,
                            width: isPortrait ? sizeW(14) : sizeW(8),
                            height: iconSize,
                          ),
                          SizedBox(width: isPortrait ? size(8) : size(10)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medals[index].title,
                                  style: context.textTheme.bodyLargeBold,
                                  maxLines: 2,
                                ),
                                SizedBox(height: size(1)),
                                Text(
                                  medals[index].subtitle,
                                  style: context.textTheme.bodyLarge.copyWith(
                                    fontSize: subtitleFontSize,
                                  ),
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.justify,
                                ),
                                SizedBox(
                                    height: isPortrait ? size(0) : size(30)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: size(20),
                left: isPortrait ? 0 : size(600),
                right: isPortrait ? size(20) : 0,
              ),
              child: Align(
                alignment:
                    isPortrait ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    context.pop();
                    context.go(AppRoutes.home);
                  },
                  child: Container(
                    height: isPortrait ? size(20) : size(50),
                    width: isPortrait ? size(70) : 160,
                    decoration: BoxDecoration(
                      color: isDark() ? Colors.white : ColorSet.revertBgColor,
                      borderRadius: BorderRadius.circular(isPortrait ? 6 : 10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.continueLabel,
                      style: context.textTheme.bodyLarge.copyWith(
                        color: ColorSet.bg2Color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedalsModel {
  final String image;
  final String title;
  final String subtitle;

  MedalsModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
