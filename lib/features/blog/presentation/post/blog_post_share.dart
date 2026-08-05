import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class BlogPostShare extends StatefulWidget {
  const BlogPostShare({super.key});

  @override
  State<BlogPostShare> createState() => _BlogPostShareState();
}

class _BlogPostShareState extends State<BlogPostShare> {
  @override
  Widget build(BuildContext context) {
    double width = FinalSize.width(context);
    return WillPopScope(
      onWillPop: () async => pop(context),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          height: size(520),
          width: sizeW(170),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Center(
            child: Container(
              width: sizeW(150),
              color: ColorSet.bg2Color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size(20)),
                  Row(
                    children: [
                      SizedBox(
                        width: size(66),
                        height: size(42),
                        child: Image.asset(
                          IconSet.logoImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text('www.kumele.com',
                          style: context.textTheme.titleSmall.copyWith(
                              color: ColorSet.textColor,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: sizeW(85)),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            context.pop();
                          });
                        },
                        child: Container(
                          width: size(30),
                          height: size(30),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(IconSet.closeIcon),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size(10)),
                  Text(
                      'Singleton of Glen Ord 38-year old and the Singleton range.',
                      style: context.textTheme.bodyLargeBold.copyWith(
                          color: ColorSet.textColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: size(10)),
                  Container(
                    height: size(153),
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size(20)),
                        topRight: Radius.circular(size(20)),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(IconSet.eventshare),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: size(14),
                          right: sizeW(4),
                          child: Container(
                            width: 110,
                            height: size(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size(24)),
                              color: const Color(0xFF1F1F1F),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  color: Colors.white,
                                  IconSet.spritualityIcon,
                                  width: sizeW(7),
                                  height: size(18),
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(width: sizeW(3)),
                                Text("Sprituality",
                                    style: context.textTheme.bodySmall.copyWith(
                                        color: const Color(0xFFFFFFFF))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: size(257),
                          height: size(150),
                          decoration: BoxDecoration(
                            color: ColorSet.bgColor,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: size(233),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/testImage2.png"),
                                    radius: size(29),
                                  ),
                                  Row(
                                    children: [
                                      Text(' Author:',
                                          style: context
                                              .textTheme.bodyMediumSemiBold
                                              .copyWith(
                                                  color: ColorSet.textColor,
                                                  fontWeight: FontWeight.w600)),
                                      SizedBox(width: sizeW(1)),
                                      Text('Steve Austin',
                                          style: context.textTheme.bodyMedium
                                              .copyWith(
                                                  color: ColorSet.textColor)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(' Publish Date:',
                                          style: context
                                              .textTheme.bodyMediumSemiBold
                                              .copyWith(
                                                  color: ColorSet.textColor,
                                                  fontWeight: FontWeight.w600)),
                                      SizedBox(width: sizeW(1)),
                                      Text('23 August, 2022',
                                          style: context.textTheme.bodyMedium
                                              .copyWith(
                                                  color: ColorSet.textColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),

                      //2nd
                      Container(
                          width: size(257),
                          height: size(150),
                          decoration: BoxDecoration(
                            color: ColorSet.bgColor,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: size(233),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size(10)),
                                  Text('How it Works',
                                      style: context.textTheme.bodyMediumBold
                                          .copyWith(
                                              color: ColorSet.textColor,
                                              fontWeight: FontWeight.bold)),
                                  SizedBox(height: size(8)),
                                  Text('1.Check Url to open blog',
                                      style: context.textTheme.bodySmall
                                          .copyWith(color: ColorSet.textColor)),
                                  SizedBox(height: size(8)),
                                  Text(
                                      '2.Or Search blog when logged in -t to like',
                                      style: context.textTheme.bodySmall
                                          .copyWith(color: ColorSet.textColor)),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: size(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invite your friends \n and family',
                          style: context.textTheme.bodyLargeBold.copyWith(
                              color: ColorSet.textColor,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: size(60)),
                      SizedBox(
                        width: size(65),
                        height: size(65),
                        child: Image.asset(
                          IconSet.copytoclip,
                          color: ColorSet.textColor,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
