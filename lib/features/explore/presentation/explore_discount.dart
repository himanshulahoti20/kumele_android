import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/flip.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ExploreDiscount extends StatefulWidget {
  const ExploreDiscount({
    super.key,
  });

  @override
  State<ExploreDiscount> createState() => _ExploreDiscountState();
}

class _ExploreDiscountState extends State<ExploreDiscount> {
  final AppinioSwiperController controller = AppinioSwiperController();
  final List<Map<String, String>> eventData = [
    // Your event data here...
  ];

  final ScrollController _controller = ScrollController();
  bool expanded = true;
  bool _isContainerVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollDialog(
      child: mainView(),
      footer: Container(
        color: ColorSet.bgColor,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                InjectionHelper.snackBar.showSuccess('Decline');
              },
              child: Container(
                height: size(50),
                width: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorSet.revertBgColor),
                  color: ColorSet.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('Cancel',
                      style: context.textTheme.bodyLarge
                          .copyWith(color: ColorSet.revertBgColor)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pop();
                EventMatchedFlow.show(context);
              },
              child: Container(
                height: size(50),
                width: 250,
                decoration: BoxDecoration(
                  color: ColorSet.revbg3Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('Install Now',
                      style: context.textTheme.bodyLarge
                          .copyWith(color: ColorSet.bg2Color)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          PNGAsset.spotify_bg,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Gap(20),
        Row(
          children: [
            Text("40% Discount",
                style: context.textTheme.headlineSmallBold
                    .copyWith(fontSize: 26, fontWeight: FontWeight.w700)),
            Spacer(),
            GestureDetector(
              onTap: _toggleContainerVisibility,
              child: Visibility(
                visible: !_isContainerVisible,
                child: Container(
                  height: size(40),
                  width: sizeW(40),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorSet.bgColor,
                    borderRadius: BorderRadius.circular(size(100)),
                  ),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: KumeleAssetWidget(
                        assetPath: SVGAsset.icon_arrow,
                        color: ColorSet.revbg3Color),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size(3)),
        Visibility(
          visible: !_isContainerVisible, // Hide text when container is visible
          child: Text('Get Spotify Premium for just 4.99 USD in 48 hours',
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorSet.textColor)),
        ),
        SizedBox(height: size(20)),
        Visibility(
          visible: _isContainerVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Spotify makes it easy to find the right music or podcast for every moment - on your phone, computer, tablet and other devices.\n You can find millions of songs and episodes on Spotify. Whether you're behind the wheel, working out, going out or just relaxing, you'll find just the right music or podcast in no time.\n\nSimply choose what you want to listen to or let Spotify surprise you.\nYou can also browse the collections of friends, artists and celebrities or create a radio station and just sit back and enjoy. \n\nSpotify – the soundtrack for your life. Get a subscription or listen for free.",
                  style: context.textTheme.bodySmall.copyWith(fontSize: 13),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible),
              SizedBox(height: size(12)),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorSet.homeMainCardColor,
                      borderRadius: BorderRadius.circular(size(10)),
                    ),
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.fromLTRB(15, 40, 15, 21),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "About Spotify: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorSet.textColor,
                              fontSize: size(12),
                            ),
                          ),
                          TextSpan(
                            text:
                                "\n\nSpotify makes it easy to find the right music or podcast for every moment - on your phone,\n computer, tablet and other devices.\n You can find millions of songs and episodes on Spotify. Whether you're behind the wheel\n working out, going out or just relaxing, you'll find just the right music or podcast in no time.\n\n Simply choose what you want to listen to or let Spotify surprise you.\n You can also browse the collections of friends, artists and celebrities or create a radio station\n and just sit back and enjoy.\n Spotify – the soundtrack for your life. Get a subscription or listen for free.\n\n",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: size(13),
                              color: ColorSet.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(PNGAsset.icon_spotify),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget expandButton() {
    return Flip(
      isFlipped: expanded,
      child: GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.bounceOut,
            );
          });
        },
        child: Container(
          height: size(40),
          width: sizeW(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(40)),
            color: ColorSet.homeMainCardArrowBG,
          ),
          child: Image.asset(
            IconSet.expandArrowIcon,
            height: size(20),
            width: sizeW(20),
          ),
        ),
      ),
    );
  }
}
