import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/features/chat/presentation/chat_event_actions_page.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';

class EventCancelDialog {
  void showGuestInviteDialog(BuildContext context) {
    final List<int> guestOptions = [2, 6, 1, 1, 5, 0, 0, 4, 0];
    int? selectedOption;
    int totalGuests = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guest Invite',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '1-5 Free',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Checkbox Selector Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                      children: guestOptions.map((option) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = option;
                              totalGuests =
                                  option * 25; // Adjust multiplier as needed
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedOption == option
                                    ? Colors.blue
                                    : Colors.grey.withOpacity(0.3),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: selectedOption == option
                                  ? Colors.blue.withOpacity(0.05)
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (selectedOption == option)
                                    const Icon(Icons.check,
                                        color: Colors.blue, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$option',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: selectedOption == option
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Total Guests
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Guests',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$totalGuests',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Disclaimer Text
                    const Text(
                      '* Max 150 Guests. Disclaimer: we cannot guarantee 100% matches due to certain factors beyond our control.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(context, selectedOption);
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void eventCancelDialog(BuildContext context) {
    showDialog(
      barrierColor: ColorSet.bcColor,
      context: context,
      builder: (BuildContext context) {
        return OrientationBuilder(builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          double dialogWidth =
              isPortrait ? MediaQuery.of(context).size.width * 0.9 : 350;
          double dialogHeight = isPortrait ? size(450) : size(385);
          double fontSize = 23;
          double smallFontSize = 13;

          return AlertDialog(
            backgroundColor: ColorSet.bg2Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size(20)),
            ),
            content: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                height: dialogHeight,
                width: dialogWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: isPortrait ? dialogWidth - 40 : 320, top: 10),
                        child: Image.asset(IconSet.closeIcon),
                      ),
                    ),
                    SizedBox(height: isPortrait ? 15 : 20),
                    Image.asset(PNGAsset.speaker, color: ColorSet.textColor),
                    SizedBox(height: isPortrait ? 15 : 20),
                    Text(
                      'Event Canceled',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmallBold.copyWith(
                        fontSize: fontSize,
                        color: ColorSet.textColor,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 8 : 10),
                    Text(
                      'The host unfortunately cancelled the event. We\n apologize for the inconvenience. Incase of\n prepayments please contact PayPal immediately\n for a refund.',
                      textAlign: TextAlign.left,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: smallFontSize,
                        color: ColorSet.textColor,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 15 : 20),
                    Text(
                      'Premium in-app purchase include',
                      textAlign: TextAlign.left,
                      style: context.textTheme.bodySmallSemiBold.copyWith(
                        fontSize: smallFontSize,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '• Location Change',
                      textAlign: TextAlign.left,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: smallFontSize,
                        color: ColorSet.textColor,
                      ),
                    ),
                    Text(
                      '• House Party(Max guests 10)',
                      textAlign: TextAlign.left,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: smallFontSize,
                        color: ColorSet.textColor,
                      ),
                    ),
                    Text(
                      '• No Ads',
                      textAlign: TextAlign.left,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: smallFontSize,
                        color: ColorSet.textColor,
                      ),
                    ),
                    Text(
                      '• 7 days pre event Advertising',
                      textAlign: TextAlign.left,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: smallFontSize,
                        color: ColorSet.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class chatMore {
  static void chatMoreDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: ColorSet.bcColor,
      builder: (BuildContext context) {
        return OrientationBuilder(builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          double dialogWidth =
              isPortrait ? MediaQuery.of(context).size.width * 0.45 : 320;
          double dialogHeight = isPortrait ? size(240) : size(260);
          double fontSize = 23;
          double iconSize = 30;

          return AlertDialog(
            backgroundColor: ColorSet.bg2Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size(20)),
            ),
            content: SizedBox(
              height: dialogHeight,
              width: dialogWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: isPortrait ? size(20) : size(50)),
                  Column(
                    children: [
                      SizedBox(height: isPortrait ? size(20) : size(30)),
                      _buildMenuItem(
                        context,
                        "assets/star.svg",
                        "Rate event",
                        iconSize,
                        fontSize,
                        () {
                          final router = GoRouter.of(context);
                          context.pop();
                          router.push(
                            AppRoutes.rating,
                            extra: const ChatEventActionsRouteArgs(
                              initialTab: ChatEventActionTab.ratings,
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        "assets/report.svg",
                        "Report event",
                        iconSize,
                        22,
                        () {
                          final router = GoRouter.of(context);
                          context.pop();
                          router.push(
                            AppRoutes.report,
                            extra: const ChatEventActionsRouteArgs(
                              initialTab: ChatEventActionTab.report,
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        "assets/qr.svg",
                        "Guest Scan",
                        iconSize,
                        fontSize,
                        () {
                          final router = GoRouter.of(context);
                          context.pop();
                          router.push(
                            AppRoutes.guestScan,
                            extra: const ChatEventActionsRouteArgs(
                              initialTab: ChatEventActionTab.guestScan,
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        "assets/follow.svg",
                        "Follow Host",
                        iconSize,
                        fontSize,
                        () {
                          context.pop();
                          AppDialog.confirm(
                            context: context,
                            title: 'Follow Host',
                            width: AppDialogSize.widthFor(context),
                            content: Text(
                              'Do you want to follow host?',
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyLarge,
                            ),
                            confirmText: 'Follow',
                            onConfirm: () {},
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: isPortrait ? size(0) : size(35)),
                  SizedBox(
                    width: size(20),
                    height: size(25),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child:
                            Image.asset(IconSet.closeIcon, fit: BoxFit.cover),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Widget _buildMenuItem(
    BuildContext context,
    String iconPath,
    String text,
    double iconSize,
    double fontSize,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size(180),
        height: size(50),
        child: Row(
          children: [
            AppSvgImage(
              assetName: iconPath,
              color: ColorSet.revbg3Color,
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(width: size(10)),
            Text(
              text,
              style: context.textTheme.bodySmall.copyWith(fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionDialogs {
  static void showNotificationPermission(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: ColorSet.bcColor,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrientationBuilder(builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          double dialogWidth =
              isPortrait ? MediaQuery.of(context).size.width * 0.7 : 400;
          double fontSize = 22;
          double smallFontSize = 14;
          double iconSize = 25;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: isPortrait ? 400 : 350,
              width: dialogWidth,
              decoration: BoxDecoration(
                color: ColorSet.bg2Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(isPortrait ? 15 : 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          IconSet.notfication,
                          height: iconSize,
                          width: iconSize,
                        ),
                        SizedBox(width: size(15)),
                        Expanded(
                          child: Text(
                            '"kuemele" Would Like to\nSend You Push\nNotifications',
                            style: context.textTheme.bodySmallBold
                                .copyWith(fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: size(10)),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Image.asset(
                            IconSet.closeIcon,
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPortrait ? 15 : 10),
                    child: Text(
                      'Notification may include alerts, sounds and icon \nbadge. These can be configured in Settings',
                      style: context.textTheme.bodySmall
                          .copyWith(fontSize: smallFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isPortrait ? 15 : 20),
                  Column(
                    children: [
                      _buildButton(
                        context,
                        "Don't Allow",
                        () => context.pop(),
                        isPortrait,
                      ),
                      SizedBox(height: isPortrait ? 8 : 10),
                      _buildButton(
                        context,
                        "OK",
                        () {
                          context.pop();
                          showPhotoPermission(context);
                        },
                        isPortrait,
                      ),
                    ],
                  ),
                  SizedBox(height: isPortrait ? 15 : 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Widget _buildButton(
      BuildContext context, String text, VoidCallback onTap, bool isPortrait) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isPortrait ? MediaQuery.of(context).size.width * 0.35 : 200,
        height: isPortrait ? size(45) : size(50),
        decoration: BoxDecoration(
          color: ColorSet.revertBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: ColorSet.bg3Color,
              fontSize: isPortrait ? size(13) : 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  static void showPhotoPermission(BuildContext context) {
    showDialog(
      barrierColor: ColorSet.bcColor,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrientationBuilder(builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          double dialogWidth =
              isPortrait ? MediaQuery.of(context).size.width * 0.7 : 400;
          double fontSize = 22;
          double smallFontSize = 14;
          double iconSize = 25;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: isPortrait ? 450 : 370,
              width: dialogWidth,
              decoration: BoxDecoration(
                color: ColorSet.bg2Color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(isPortrait ? 15 : 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          IconSet.photographyIcon,
                          height: iconSize,
                          width: iconSize,
                        ),
                        SizedBox(width: size(15)),
                        Expanded(
                          child: Text(
                            '"kuemele" Would Like to\nAccess Your Photos',
                            style: context.textTheme.bodySmallBold
                                .copyWith(fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Image.asset(
                            IconSet.closeIcon,
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPortrait ? 15 : 20),
                    child: Text(
                      'Allow "kuemele" to access your photos to send\nimages and videos',
                      style: context.textTheme.bodySmall
                          .copyWith(fontSize: smallFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isPortrait ? 15 : 20),
                  Column(
                    children: [
                      _buildButton(
                        context,
                        "Select Photos",
                        () {
                          context.pop();
                          showLocationPermission(context);
                        },
                        isPortrait,
                      ),
                      SizedBox(height: isPortrait ? 8 : 10),
                      _buildButton(
                        context,
                        "Allow Access to All Photos",
                        () {
                          context.pop();
                          showLocationPermission(context);
                        },
                        isPortrait,
                      ),
                      SizedBox(height: isPortrait ? 8 : 10),
                      _buildButton(
                        context,
                        "Don't Allow",
                        () {
                          context.pop();
                          showLocationPermission(context);
                        },
                        isPortrait,
                      ),
                    ],
                  ),
                  SizedBox(height: isPortrait ? 15 : 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static void showLocationPermission(BuildContext context) {
    showDialog(
      barrierColor: ColorSet.bcColor,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrientationBuilder(builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          double dialogWidth =
              isPortrait ? MediaQuery.of(context).size.width * 0.7 : 400;
          double fontSize = 22;
          double smallFontSize = 14;
          double iconSize = 25;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: isPortrait ? 450 : 370,
              width: dialogWidth,
              decoration: BoxDecoration(
                color: ColorSet.bg2Color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(isPortrait ? 15 : 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          IconSet.location,
                          height: iconSize,
                          width: iconSize,
                        ),
                        SizedBox(width: size(15)),
                        Expanded(
                          child: Text(
                            '"kuemele" Want to\nAccess Your Location?',
                            style: context.textTheme.bodySmallBold
                                .copyWith(fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Image.asset(
                            IconSet.closeIcon,
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isPortrait ? 15 : 20),
                    child: Text(
                      'This helps the app provid advanced \nfunctionality',
                      style: context.textTheme.bodySmall
                          .copyWith(fontSize: smallFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isPortrait ? 15 : 20),
                  Column(
                    children: [
                      _buildButton(
                        context,
                        "Allow While Using App",
                        () {
                          context.pop();
                          chooseUserName(context);
                        },
                        isPortrait,
                      ),
                      SizedBox(height: isPortrait ? 8 : 10),
                      _buildButton(
                        context,
                        "Allow Once",
                        () {
                          context.pop();
                          chooseUserName(context);
                        },
                        isPortrait,
                      ),
                      SizedBox(height: isPortrait ? 8 : 10),
                      _buildButton(
                        context,
                        "Don't Allow",
                        () {
                          context.pop();
                          chooseUserName(context);
                        },
                        isPortrait,
                      ),
                    ],
                  ),
                  SizedBox(height: isPortrait ? 15 : 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static void chooseUserName(BuildContext context) {
    final TextEditingController usernameCTR = TextEditingController();

    showDialog(
      barrierColor: ColorSet.bcColor,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrientationBuilder(builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          double dialogWidth =
              isPortrait ? MediaQuery.of(context).size.width * 0.7 : 400;
          double fontSize = 22;
          double smallFontSize = 14;
          double iconSize = 25;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: isPortrait ? 400 : 370,
                  width: dialogWidth,
                  decoration: BoxDecoration(
                    color: ColorSet.bg2Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(isPortrait ? 15 : 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              IconSet.pictureIcon,
                              height: iconSize,
                              width: iconSize,
                            ),
                            SizedBox(width: size(15)),
                            Expanded(
                              child: Text(
                                'Choose your username',
                                style: context.textTheme.bodySmallBold
                                    .copyWith(fontSize: fontSize),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Image.asset(
                                IconSet.closeIcon,
                                width: iconSize,
                                height: iconSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: isPortrait ? 15 : 20,
                          top: 0,
                          bottom: isPortrait ? 15 : 20,
                        ),
                        child: Text(
                          'User name can only be changes every 3 months',
                          style: context.textTheme.labelSmall.copyWith(
                              fontSize: smallFontSize, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: isPortrait ? 315 : 300),
                        child: Text(
                          'User Name',
                          style: context.textTheme.bodySmall
                              .copyWith(fontSize: smallFontSize),
                        ),
                      ),
                      SizedBox(height: size(2)),
                      KumeleTextField(
                        controller: usernameCTR,
                        hintText: "Enter username",
                      ),
                      SizedBox(height: isPortrait ? 15 : 20),
                      Column(
                        children: [
                          SizedBox(height: isPortrait ? 8 : 10),
                          _buildButton(
                            context,
                            "Skip",
                            () => context.pop(),
                            isPortrait,
                          ),
                          SizedBox(height: isPortrait ? 8 : 10),
                          _buildButton(
                            context,
                            "Save",
                            () {
                              usernameCTR.dispose();
                              context.pop();
                            },
                            isPortrait,
                          ),
                        ],
                      ),
                      SizedBox(height: isPortrait ? 15 : 20),
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }
}
