import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/switch.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

import 'package:kuemele/shared/components/size.dart';

class SoundNotification2Factor extends StatefulWidget {
  const SoundNotification2Factor({super.key});

  @override
  State<SoundNotification2Factor> createState() =>
      _SoundNotification2FactorState();
}

class _SoundNotification2FactorState extends State<SoundNotification2Factor> {
  bool soundNotification = false;
  bool soundNotificationfor2Factor = false;

  @override
  Widget build(BuildContext context) {
    double width = FinalSize.width(context);
    double height = FinalSize.height(context);
    double defaultWidth = width * 0.9;
    return WillPopScope(
      onWillPop: () async => pop(context),
      child: Scaffold(
        backgroundColor: ColorSet.bgColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: height,
              width: width,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                border: Border.all(),
                color: ColorSet.bgColor,
              ),
              child: SizedBox(
                width: defaultWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pop(context);
                            },
                            child: Image.asset(
                              IconSet.arrowBackIcon,
                              width: sizeW(25),
                              height: size(25),
                            ),
                          ),
                          SizedBox(width: sizeW(20)),
                          Text(
                            'Sound notification',
                            style: context.textTheme.headlineSmallBold.copyWith(
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size(20)),
                      ListTile(
                        onTap: () {
                          setState(() {
                            soundNotification = !soundNotification;
                          });
                        },
                        title: Text(
                          'Turn on 2 factor authentications',
                          style: context.textTheme.bodyLarge,
                        ),
                        trailing: RASwitch(
                          value: soundNotification,
                          onTap: () {
                            setState(() {
                              soundNotification = !soundNotification;
                            });
                          },
                          size: Size(size(25), size(15)),
                        ),
                      ),
                      SizedBox(height: size(20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
}
