import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class Medals {
  /// Single source of truth for tier status/description copy — shared by
  /// the History & Statistics info popup and the reward-tier notification
  /// popup so the two never drift.
  static ({String title, String status, String description}) contentFor(
    String medalType,
  ) {
    switch (medalType.toLowerCase()) {
      case 'gold':
        return (
          title: "",
          status: "Gold status",
          description:
              "You created a minimum of 10 events or user\nattended a minimum of 10 events without\nfail in the last 30 days. The user gets 10%\ndiscount of one in-app purchase of\nchoice.",
        );
      case 'silver':
        return (
          title: "",
          status: "Silver Status",
          description:
              "You created a minimum of 5 events or user\nattended a minimum of 5 events without\nfail in the last 30 days. The user gets 7%\ndiscount of one in-app purchase of\nchoice.",
        );
      default: // bronze
        return (
          title: "",
          status: "Bronze Status",
          description:
              "You created a minimum of 3 events or user\nattended a minimum of 3 events without\nfail in the last 30 days. The user gets 4%\ndiscount of one in-app purchase of\nchoice.",
        );
    }
  }

  static void medalDialog(BuildContext context, String medalType) {
    final content = contentFor(medalType);
    final title = content.title;
    final status = content.status;
    final description = content.description;

    showDialog(
      context: context,
      barrierColor: ColorSet.bcColor,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorSet.bg3Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size(20)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset(
                        IconSet.closeIcon,
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size(50),
                    width: size(50),
                    child: Image.asset(IconSet.medalIcon),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLargeBold.copyWith(
                      fontSize: 23,
                      color: ColorSet.textColor,
                    ),
                  ),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: context.textTheme.heading3.copyWith(
                      color: ColorSet.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description.replaceAll('\n', ' '),
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge.copyWith(
                      fontSize: 15,
                      color: ColorSet.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
