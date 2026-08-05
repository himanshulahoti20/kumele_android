import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/controllers/mynavController.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class qr {
  static void qrDialog(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    showDialog(
      barrierColor: ColorSet.bcColor,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorSet.bg2Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size(10)),
          ),
          content: GestureDetector(
            onTap: () {
              // Close the current dialog
              Navigator.of(context).pop();

              // Show another dialog
            },
            child: SizedBox(
                height: size(355),
                width: 400,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: size(isPortrait ? 0 : 15)),
                    Column(
                      children: [
                        SizedBox(height: size(isPortrait ? 0 : 10)),

                        // First Item
                        GestureDetector(
                          onTap: () {
                            // Navigate to index 14
                            MyNavController.to.onItemTapped(14);
                          },
                          child: SizedBox(
                            width: size(isPortrait ? 220 : 400),
                            height: size(isPortrait ? 30 : 50),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: isPortrait ? 80 : 150,
                                ),
                                Text(
                                  "Scan QR",
                                  style: context.textTheme.heading3.copyWith(fontSize: 19),
                                ),
                                SizedBox(
                                  width: 140,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();

                                    // Handle tap event
                                  },
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(IconSet.closeIcon, fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: isPortrait ? 220 : 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size(10)),
                                  Container(
                                    width: 55, // Circle diameter
                                    height: 55, // Circle diameter
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage("assets/blog_image_1.png")),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Group meditation",
                                    style: context.textTheme.heading3,
                                  ),
                                  SizedBox(height: size(10)),
                                  Container(
                                    width: 115,
                                    height: size(isPortrait ? 20 : 25),
                                    padding: EdgeInsets.symmetric(horizontal: sizeW(2)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(size(24)),
                                      color: const Color(0xFF1F1F1F),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: size(20),
                                          width: sizeW(7),
                                          child: Image.asset(
                                            IconSet.spritualityIcon,
                                            color: Colors.white,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(width: sizeW(1)),
                                        Expanded(
                                          child: Text(
                                  "Sprituality",
                                  style: context.textTheme.bodySmall.copyWith(color: const Color(0xFFFFFFFF)),
                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size(10)),
                                  Row(
                                    children: [
                                      Text(
                                        "Hosted by:",
                                        style: context.textTheme.bodyMediumSemiBold.copyWith(fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Ankit Maheswari",
                                        style: context.textTheme.bodyMediumSemiBold.copyWith(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Location:\n",
                                        style: context.textTheme.bodyMediumSemiBold.copyWith(fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Bahawalpur,Pun\n Pakistan",
                                        style: context.textTheme.bodyMediumSemiBold.copyWith(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: size(isPortrait ? 40 : 40)),
                                  Container(
                                    width: 135,
                                    height: size(40),
                                    padding: EdgeInsets.symmetric(horizontal: sizeW(2)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(size(5)),
                                      color: const Color(0xFF1F1F1F),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: size(20),
                                          width: sizeW(7),
                                          child: SvgPicture.asset(
                                            "assets/qr.svg",
                                            width: sizeW(10),
                                            color: Colors.white,
                                            height: size(30),
                                          ),
                                        ),
                                        SizedBox(width: sizeW(1)),
                                        Expanded(
                                          child: Text(
                                        "Scan QR Code",
                                        style: context.textTheme.bodySmall.copyWith(color: const Color(0xFFFFFFFF)),
                                      ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size(20)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size(isPortrait ? 70 : 170),
                                  width: sizeW(50),
                                  child: Image.asset(
                                    IconSet.qrIcon,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: size(2)),
                                Text(
                                  "Host QR",
                                  style: context.textTheme.bodySmall.copyWith(color: ColorSet.textColor),
                                ),
                                SizedBox(height: size(20)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
