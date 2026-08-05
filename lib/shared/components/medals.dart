import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class Medals {
  static void medalDialog(BuildContext context, String medalType) {
    String title = '';
    String status = '';
    String description = '';

    switch (medalType) {
      case 'gold':
        title = "";
        status = "Gold status";
        description =
            "You created a minimum of 10 events or user\nattended a minimum of 10 events without\nfail in the last 30 days. The user gets 10%\ndiscount of one in-app purchase of\nchoice.";

        break;
      case 'silver':
        title = "";
        status = "Silver Status";
        description =
            "You created a minimum of 5 events or user\nattended a minimum of 5 events without\nfail in the last 30 days. The user gets 7%\ndiscount of one in-app purchase of\nchoice.";
        break;
      default: // bronze
        title = "";
        status = "Bronze Status";
        description =
            "You created a minimum of 3 events or user\nattended a minimum of 3 events without\nfail in the last 30 days. The user gets 4%\ndiscount of one in-app purchase of\nchoice.";
    }

    showDialog(
      context: context,
      barrierColor: ColorSet.bcColor,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorSet.bg3Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size(20)),
          ),
          content: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: size(280),
              width: 350,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 90),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleLargeBold.copyWith(
                              fontSize: 23,
                              color: ColorSet.textColor,
                            ),
                          ),
                          SizedBox(width: 180),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image.asset(IconSet.closeIcon),
                          ),
                        ],
                      ),
                      SizedBox(height: 0),
                      SizedBox(
                        height: size(50),
                        width: size(50),
                        child: Image.asset(IconSet.medalIcon),
                      ),
                      SizedBox(height: 20),
                      Text(
                        status,
                        textAlign: TextAlign.center,
                        style: context.textTheme.heading3.copyWith(
                          color: ColorSet.textColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge.copyWith(
                          fontSize: 15,
                          color: ColorSet.textColor,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
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
