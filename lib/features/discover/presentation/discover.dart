import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/flip.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:lottie/lottie.dart';

import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/widgets/kumele_rich_text.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final AppinioSwiperController controller = AppinioSwiperController();
  final ScrollController _controller = ScrollController();
  bool expanded = false;
  List<Match> matchesList = [];
  int selectedIndex = 0;
  double backCard2Top = 0, backCard2Width = 0;
  double backCard1Top = 0, backCard1Width = 0, backCard1Height = 0;
  double backCard1Left = 0, backCardMoke1Width = 0;
  Color backCard2Color = Colors.transparent;
  Color backCard1Color = Colors.transparent;
  Color backCardMoke1Color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 1), () {
      double width = FinalSize.width(context);
      double defaultWidth = sizeW(343);
      backCard1Left = (width / 2) - ((defaultWidth * 0.8) / 2);
      backCard2Top = size(195);
      backCard1Top = size(210);
      backCard2Width = sizeW(303);
      backCard1Width = sizeW(263);
      backCard1Height = size(399);
      backCard1Color = ColorSet.home3rdCardColor;
      backCard2Color = ColorSet.home2ndCardColor;
      backCardMoke1Width = sizeW(200);
    });
    // Future.delayed(const Duration(seconds: 4), () {
    //   if (mounted) {
    //     setState(() {
    //       matchesList = matches;
    //       Future.delayed(const Duration(seconds: 1), () {
    //         if (mounted) {
    //           shakeCard();
    //         }
    //       });
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    FocusScopeNode().unfocus();
    double width = FinalSize.width(context);
    double height = FinalSize.height(context);
    // double defaultWidth = width * 0.6;
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: ColorSet.homePageBG,
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              // border: Border.all(color: Colors.transparent),
              ),
          child: switchTile(),
        ),
      ),
    );
  }

  Widget switchTile() {
    switch (matchesList.length) {
      case 0:
        return noMatchesTile();
      default:
        return matchesTile();
    }
  }

  Widget noMatchesTile() {
    double width = FinalSize.width(context);
    // double height = FinalSize.height(context);
    double defaultWidth = width * 0.6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //
        Image.asset(
          IconSet.noMatchesIcon,
          width: sizeW(300),
          height: size(300),
        ),
        //
        SizedBox(height: size(40)),
        //
        SizedBox(
          width: defaultWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text("No more matches currently, until then",
                    style: context.textTheme.bodyLargeBold
                        .copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible),
              ),
            ],
          ),
        ),
        //
        SizedBox(height: size(10)),
        //
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     //
        //     RAClickButton(
        //       onTap: () {
        //         addMatch();
        //       },
        //       child: IconSet.groupIcon,
        //     ),
        //     //
        //     SizedBox(width: sizeW(10)),
        //     //
        //     RAClickButton(
        //       onTap: () {
        //         // addMatch();
        //       },
        //       child: IconSet.selfIcon,
        //       iconSize: 30,
        //     ),
        //     //
        //     SizedBox(width: sizeW(10)),
        //     //
        //     RAClickButton(
        //       onTap: () {
        //         // addMatch();
        //       },
        //       child: IconSet.shareIcon,
        //     ),
        //     //
        //   ],
        // ),
        //
      ],
    );
  }

  addMatch() {
    // // showDialog(
    // //   context: context,
    // //   builder: (context) => CreateEvent(
    // //     onConfirm: (newMatch) {
    // //       if (mounted) {
    // //       //   setState(() {
    // //       //     matchesList = matches;
    // //       //     Match petLoveMatch = Match(
    // //       //       title: newMatch.title,
    // //       //       time: newMatch.time,
    // //       //       guests: newMatch.guests,
    // //       //       startsIn: newMatch.startsIn,
    // //       //       description: newMatch.description,
    // //       //       profile: newMatch.profile,
    // //       //       followers: newMatch.followers,
    // //       //       rating: newMatch.rating,
    // //       //       type: ModelType(
    // //       //           type: newMatch.type.type, image: newMatch.type.image),
    // //       //       medal: Medal(
    // //       //         icon: newMatch.medal.icon,
    // //       //         medalName: newMatch.medal.medalName,
    // //       //         name: newMatch.medal.name,
    // //       //         position: newMatch.medal.position,
    // //       //         command: newMatch.medal.command,
    // //       //         rating: newMatch.medal.rating,
    // //       //       ),
    // //       //     );
    // //       //     Future.delayed(const Duration(seconds: 1), () {
    // //       //       if (mounted) {
    // //       //         matchesList.insert(0, petLoveMatch);
    // //       //         _shakeCard();
    // //       //       }
    // //       //     });
    // //       //   });
    // //       // }
    // //     },
    // //   ),
    // );
  }

  Widget matchesTile() {
    double width = FinalSize.width(context);
    double height = FinalSize.height(context);
    double defaultWidth = sizeW(343);
    // double topAppBarHeight = size(300);
    double cardHeight = size(452);
    return Container(
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.white),
          ),
      child: Stack(
        children: [
          // Search
          Positioned(
            top: size(52),
            left: size(16),
            child: Container(
              height: size(48),
              width: size(48),
              decoration: BoxDecoration(
                color: ColorSet.homeMainCardColor,
                borderRadius: BorderRadius.circular(sizeW(28)),
              ),
              child: Center(
                child: Image.asset(IconSet.searchIcon, fit: BoxFit.fill),
              ),
            ),
          ),
          // Moke back card - 1
          Positioned(
            top: size(210),
            left: (width / 2) - (backCardMoke1Width / 2),
            child: Container(
              // duration: const Duration(seconds: 1),
              height: size(399),
              width: backCardMoke1Width,
              decoration: BoxDecoration(
                color: backCardMoke1Color,
                // gradient: LinearGradient(
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   stops: const [0.2, 0.2],
                //   colors: [
                //     ColorSet.home3rdCardColor,
                //     Colors.transparent,
                //   ],
                // ),
                borderRadius: BorderRadius.circular(size(28)),
              ),
            ),
          ),
          // back card - 1
          Positioned(
            top: backCard1Top,
            left: (width / 2) - (backCard1Width / 2),
            child: Container(
              // duration: const Duration(seconds: 1),
              height: backCard1Height,
              width: backCard1Width,
              decoration: BoxDecoration(
                color: backCard1Color,
                // gradient: LinearGradient(
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   stops: const [0.2, 0.2],
                //   colors: [
                //     ColorSet.home3rdCardColor,
                //     Colors.transparent,
                //   ],
                // ),
                borderRadius: BorderRadius.circular(size(28)),
              ),
            ),
          ),
          // back card - 2
          Positioned(
            top: backCard2Top,
            left: (width / 2) - (backCard2Width / 2),
            child: Container(
              // duration: const Duration(seconds: 1),
              height: size(399),
              width: backCard2Width,
              decoration: BoxDecoration(
                color: backCard2Color,
                // gradient: LinearGradient(
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   stops: const [0.2, 0.2],
                //   colors: [
                //     ColorSet.home2ndCardColor,
                //     Colors.transparent,
                //   ],
                // ),
                borderRadius: BorderRadius.circular(size(28)),
              ),
            ),
          ),
          // Main Card
          Positioned(
            top: size(124),
            left: (width / 2) - (width / 2),
            child: Container(
              width: width,
              height: expanded ? (height - (size(76) + size(85))) : cardHeight,
              decoration: const BoxDecoration(
                  // border: Border.all(color: Colors.white),
                  ),
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //
                    SizedBox(
                      height: cardHeight,
                      width: defaultWidth,
                      child: AppinioSwiper(
                        invertAngleOnBottomDrag: false,
                        backgroundCardCount: 0,
                        swipeOptions: SwipeOptions.only(
                          left: !expanded,
                          right: !expanded,
                          up: false,
                          down: false,
                        ),
                        controller: controller,
                        onCardPositionChanged: onCardPositionChanged,
                        onSwipeCancelled: (v) {
                          setState(() {
                            backCard2Top = size(195);
                            backCard1Top = size(210);
                            backCard2Width = sizeW(303);
                            backCard1Width = sizeW(263);
                          });
                        },
                        onSwipeEnd: _swipeEnd,
                        onEnd: _onEnd,
                        cardCount: matchesList.length,
                        allowUnSwipe: false,
                        allowUnlimitedUnSwipe: false,
                        loop: true,
                        cardBuilder: (BuildContext context, int index) {
                          var image = matchesList[index]
                              .type
                              .image
                              .replaceAll('_dark', '')
                              .replaceAll('.png', '_dark.png');
                          return GestureDetector(
                            onTap: () {
                              selectedIndex = controller.cardIndex!;
                              EventMatchedFlow.show(context);
                            },
                            child: Container(
                              height: expanded ? null : cardHeight,
                              width: defaultWidth,
                              decoration: BoxDecoration(
                                color: ColorSet.homeMainCardColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(size(28)),
                                  topRight: Radius.circular(size(28)),
                                  bottomLeft: expanded
                                      ? Radius.circular(size(0))
                                      : Radius.circular(size(28)),
                                  bottomRight: expanded
                                      ? Radius.circular(size(0))
                                      : Radius.circular(size(28)),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Container(
                                    height: size(280),
                                    width: defaultWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(size(28)),
                                        topRight: Radius.circular(size(28)),
                                      ),
                                      image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            AssetImage('assets/testImage.jpeg'),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: size(24),
                                          right: sizeW(24),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: sizeW(10),
                                              right: sizeW(12),
                                              top: size(6),
                                              bottom: size(6),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size(24)),
                                              color: const Color(0xFF1F1F1F),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  image,
                                                  width: sizeW(25),
                                                  height: size(25),
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(width: sizeW(13)),
                                                Text(
                                                    matchesList[index]
                                                        .type
                                                        .type,
                                                    style: context
                                                        .textTheme.bodyLarge
                                                        .copyWith(
                                                            color: const Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 18)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //
                                  mainView(matchesList[index]),
                                  //
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //
                    expandedView(defaultWidth, matchesList[selectedIndex]),
                    //
                    if (expanded) SizedBox(height: size(56)),
                    //
                  ],
                ),
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  actionButton(IconData icon, Color buttonBG,
      {required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size(80),
        width: sizeW(80),
        decoration: BoxDecoration(
          color: buttonBG,
          borderRadius: BorderRadius.circular(size(40)),
          border: Border.all(
            color: ColorSet.bgColor,
            width: sizeW(8),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: ColorSet.bgColor,
            size: size(50),
          ),
        ),
      ),
    );
  }

  Widget mainView(Match match) {
    var startTime = match.startTime;
    var endTime = match.endTime;
    var currentTime = DateTime.now();
    var hoursUntilStart = startTime.difference(currentTime).inHours;
    return Row(
      children: [
        SizedBox(width: sizeW(16)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size(10)),
              Text(match.title,
                  style: context.textTheme.headlineSmallBold
                      .copyWith(fontSize: 25, fontWeight: FontWeight.w700)),
              SizedBox(height: size(5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    IconSet.dollarCircledIcon,
                    height: size(25),
                    width: sizeW(25),
                    fit: BoxFit.fill,
                  ),
                  Text('${match.escrowPrice <= 0 ? 'Free' : match.escrowPrice}',
                      style: context.textTheme.titleMedium.copyWith(
                          color: ColorSet.specialColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: sizeW(5)),
                  Image.asset(
                    IconSet.clockIcon,
                    height: size(25),
                    width: sizeW(25),
                    fit: BoxFit.fill,
                  ),
                  Text(
                      '${startTime.hour}:${startTime.minute}-${endTime.hour}:${endTime.minute}',
                      style: context.textTheme.titleMedium.copyWith(
                          color: ColorSet.specialColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: sizeW(5)),
                  Image.asset(
                    IconSet.cardGroupIcon,
                    height: size(25),
                    width: sizeW(25),
                    fit: BoxFit.fill,
                  ),
                  Text('${match.guests} guests',
                      style: context.textTheme.titleMedium.copyWith(
                          color: ColorSet.specialColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: size(5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Location:',
                      style: context.textTheme.titleMedium
                          .copyWith(fontSize: 18, fontWeight: FontWeight.w500)),
                  SizedBox(width: sizeW(5)),
                  Text("Indore, Madhya radesh, IN",
                      style: context.textTheme.titleMedium.copyWith(
                          color: ColorSet.specialColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: size(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Starts in',
                      style: context.textTheme.titleMedium
                          .copyWith(fontSize: 18, fontWeight: FontWeight.w500)),
                  Lottie.asset(
                    IconSet.jsonClock,
                    height: sizeW(25),
                    width: sizeW(25),
                    fit: BoxFit.fill,
                  ),
                  Text(
                      '${hoursUntilStart.toString()[1].replaceAll('-', '')} hrs',
                      style: context.textTheme.titleMedium.copyWith(
                          color: ColorSet.specialColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: sizeW(8)),
                  isDark()
                      ? AppButton.outline(
                          label: "Share",
                          iconAsset:
                              'assets/icons/${isDark() ? 'share' : 'share_dark'}.png',
                          iconSize: size(25),
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                        )
                      : AppButton.primary(
                          label: "Share",
                          iconAsset:
                              'assets/icons/${isDark() ? 'share' : 'share_dark'}.png',
                          iconSize: size(25),
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                        ),
                  const Spacer(),
                  expandButton(),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: sizeW(16)),
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
            borderRadius: BorderRadius.circular(size(100)),
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

  Widget expandedView(double defaultWidth, Match match) {
    var startTime = match.startTime;
    var endTime = match.endTime;
    return Visibility(
      visible: expanded,
      child: Container(
        width: defaultWidth,
        padding: EdgeInsets.all(size(15)),
        decoration: BoxDecoration(
          color: ColorSet.homeMainCardColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(size(20)),
            bottomRight: Radius.circular(size(20)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Text(
                '🌟 Invitation to a Transformative Yoga Experience: Kundalini Awakening Gathering',
                style: context.textTheme.bodySmallBold
                    .copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.justify,
                overflow: TextOverflow.visible),
            //
            SizedBox(height: size(20)),
            //
            Text(
                'Embark on a profound journey of self-discovery and inner transformation with our exclusive Kundalini Awakening Yoga event! We invite you to join us for a harmonious gathering where ten individuals will come together to explore the ancient practice of Kundalini yoga. This',
                style: context.textTheme.bodySmall.copyWith(fontSize: 13),
                textAlign: TextAlign.justify,
                overflow: TextOverflow.visible),
            //
            SizedBox(height: size(24)),
            //
            SizedBox(
              height: size(271),
              width: sizeW(311),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: size(56),
                        left: sizeW(18),
                      ),
                      width: sizeW(311),
                      height: size(231),
                      decoration: BoxDecoration(
                        color: ColorSet.hostTileColor,
                        borderRadius: BorderRadius.circular(
                          sizeW(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Host',
                                  style: context.textTheme.bodyLargeBold
                                      .copyWith(fontWeight: FontWeight.w700)),
                              SizedBox(width: sizeW(8)),
                              Lottie.asset(
                                IconSet.jsonPrize,
                                width: sizeW(19.96),
                                height: size(19.96),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: sizeW(0.02)),
                              Text('Gold',
                                  style: context.textTheme.bodySmall
                                      .copyWith(fontSize: 13)),
                            ],
                          ),
                          SizedBox(height: size(8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sizeW(250),
                                child: KumeleTextLink(
                                  leading: 'About Alkesh:',
                                  trailing:
                                      'Engineering Marvel with a Passion for Beats and Serenity',
                                  leadingStyle: context.textTheme.bodySmallBold,
                                  trailingStyle: context.textTheme.bodySmall
                                      .copyWith(fontSize: size(13)),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size(10)),
                          Text(
                              'Welcome to my world of innovation and\nrhythm! I’m Alkesh, an engineer by profession\nand a connoisseur of life’s eclectic\nexperiences.',
                              style: context.textTheme.bodySmall
                                  .copyWith(fontSize: 13),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: size(17),
                    left: sizeW(68),
                    child: Container(
                      width: sizeW(144),
                      height: size(46),
                      decoration: BoxDecoration(
                        color: ColorSet.specialYellowColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(sizeW(7)),
                          topRight: Radius.circular(sizeW(7)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: sizeW(27.51)),
                              Text('${match.followers}',
                                  style: context.textTheme.bodySmall
                                      .copyWith(fontWeight: FontWeight.w800)),
                              Text(' followers',
                                  style: context.textTheme.bodySmallSemiBold
                                      .copyWith(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: sizeW(27.51)),
                              Icon(
                                Icons.star,
                                size: sizeW(10),
                              ),
                              Text('${match.rating} Overall Ratings',
                                  style: context.textTheme.labelSmall.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      width: sizeW(80),
                      height: sizeW(80),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(testImage2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            SizedBox(height: size(24)),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //
                Text('90’s Hip-Hop',
                    style: context.textTheme.bodyLargeBold.copyWith(
                        color: ColorSet.specialColor,
                        fontWeight: FontWeight.w700)),
                //
                SizedBox(width: sizeW(6.77)),
                //
                Container(
                  height: size(28),
                  width: sizeW(124),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sizeW(24)),
                    color: ColorSet.revertBgColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //
                      Image.asset(
                        IconSet.celebrateRevertIcon,
                        height: sizeW(20),
                        width: sizeW(20),
                        fit: BoxFit.fill,
                      ),
                      //
                      SizedBox(width: sizeW(13)),
                      //
                      Text('House Party',
                          style: context.textTheme.bodySmall.copyWith(
                              color: ColorSet.homeMainCardColor, fontSize: 13)),
                      //
                    ],
                  ),
                ),
                //
              ],
            ),
            //
            SizedBox(height: size(16)),
            //
            RARating(
              initialRating: 3.5,
              minRating: 1.0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: size(15.95),
              itemCount: 5,
              itemPadding: EdgeInsets.all(size(4)),
              itemBuilder: (index, isHalf, isFilled) {
                return Icon(
                  isFilled
                      ? Icons.star
                      : (isHalf ? Icons.star_half : Icons.star),
                  size: size(15.95),
                  color: isFilled || isHalf ? ColorSet.textColor : Colors.grey,
                );
              },
              onRatingUpdate: (rating) {
                print("New Rating: $rating");
              },
            ),
            //
            SizedBox(height: size(5.41)),
            //
            Text('3.6 out of 5',
                style: context.textTheme.bodyLarge.copyWith(fontSize: 17)),
            //
            SizedBox(height: size(5.41)),
            //
            Text('6 Guest ratings',
                style: context.textTheme.titleMediumSemiBold
                    .copyWith(fontWeight: FontWeight.w600)),
            //
            SizedBox(height: size(16)),
            //
            RARatingSummary(
              ratingSummaryData: <RatingType, double>{
                RatingType.communication: 4.8,
                RatingType.respect: 4.2,
                RatingType.professional: 5.0,
                RatingType.atmosphere: 5.0,
                RatingType.value: 5.0,
              },
            ),
            //
            SizedBox(height: size(16)),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                SizedBox(
                  width: sizeW(40),
                  height: size(40),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(blogImage2),
                  ),
                ),
                //
                SizedBox(width: sizeW(5.94)),
                //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //
                        Text('Jakob Hoffman',
                            style: context.textTheme.labelSmallBold
                                .copyWith(fontWeight: FontWeight.w700)),
                        //
                        SizedBox(width: sizeW(2.97)),
                        //
                        Text('⬤ 23 August 2023',
                            style: context.textTheme.labelSmallBold.copyWith(
                                color: ColorSet.subTextColor,
                                fontWeight: FontWeight.w700)),
                        //
                      ],
                    ),
                    //
                    RARating(
                      initialRating: 3.5,
                      minRating: 1.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: size(15.95),
                      itemCount: 5,
                      itemPadding: EdgeInsets.all(size(4)),
                      itemBuilder: (index, isHalf, isFilled) {
                        return Icon(
                          isFilled
                              ? Icons.star
                              : (isHalf ? Icons.star_half : Icons.star),
                          size: size(15.95),
                          color: isFilled || isHalf
                              ? ColorSet.textColor
                              : Colors.grey,
                        );
                      },
                      onRatingUpdate: (rating) {},
                    ),
                    //
                    SizedBox(
                      width: sizeW(267),
                      child: Text(
                          'What a display  dsn  cdn zxnc nzc njzcn nzcjcnzjncjcnzjcnzc ncnz cjkznkcnzc kcnznczn cznzxnc  czc znc zncznc z nzcxnjcc ncjcnz nc nzcnnz cc',
                          style: context.textTheme.labelSmall,
                          overflow: TextOverflow.visible),
                    ),
                    //
                  ],
                ),
                //
              ],
            ),
            //
            SizedBox(height: size(4)),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                SizedBox(
                  width: sizeW(40),
                  height: size(40),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(blogImage1),
                  ),
                ),
                //
                SizedBox(width: sizeW(5.94)),
                //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //
                        Text('Jakob Hoffman',
                            style: context.textTheme.labelSmallBold
                                .copyWith(fontWeight: FontWeight.w700)),
                        //
                        SizedBox(width: sizeW(2.97)),
                        //
                        Text('⬤ 23 August 2023',
                            style: context.textTheme.labelSmallBold.copyWith(
                                color: ColorSet.subTextColor,
                                fontWeight: FontWeight.w700)),
                        //
                      ],
                    ),
                    //
                    RARating(
                      initialRating: 3.5,
                      minRating: 1.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: size(15.95),
                      itemCount: 5,
                      itemPadding: EdgeInsets.all(size(4)),
                      itemBuilder: (index, isHalf, isFilled) {
                        return Icon(
                          isFilled
                              ? Icons.star
                              : (isHalf ? Icons.star_half : Icons.star),
                          size: size(15.95),
                          color: isFilled || isHalf
                              ? ColorSet.textColor
                              : Colors.grey,
                        );
                      },
                      onRatingUpdate: (rating) {},
                    ),
                    //
                    SizedBox(
                      width: sizeW(267),
                      child: Text(
                          'What a display  dsn  cdn zxnc nzc njzcn nzcjcnzjncjcnzjcnzc ncnz cjkznkcnzc kcnznczn cznzxnc  czc znc zncznc z nzcxnjcc ncjcnz nc nzcnnz cc',
                          style: context.textTheme.labelSmall,
                          overflow: TextOverflow.visible),
                    ),
                    //
                  ],
                ),
              ],
            ),
            //
            SizedBox(height: size(24)),
            //
            Text('Other Events from Alkesh',
                style: context.textTheme.heading3
                    .copyWith(fontSize: 19, fontWeight: FontWeight.w600)),
            //
            SizedBox(height: size(12)),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                const Spacer(),
                //
                SizedBox(
                  height: size(160),
                  width: sizeW(142),
                  child: Card(
                    color: ColorSet.homeMainCardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Container(
                          height: size(80),
                          width: sizeW(142),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(testImage8),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(sizeW(14)),
                              topRight: Radius.circular(sizeW(14)),
                            ),
                          ),
                        ),
                        //
                        SizedBox(height: size(6)),
                        //
                        Padding(
                          padding: EdgeInsets.only(left: sizeW(8)),
                          child: Text('90’s Hip-Hop',
                              style: context.textTheme.bodySmallBold
                                  .copyWith(fontWeight: FontWeight.w700)),
                        ),
                        //
                        SizedBox(height: size(6)),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: sizeW(8)),
                            Image.asset(
                              IconSet.cardGroupIcon,
                              height: size(13),
                              width: sizeW(13),
                            ),
                            SizedBox(width: sizeW(2.5)),
                            Text('${match.guests} guests',
                                style: context.textTheme.labelSmall.copyWith(
                                    color: ColorSet.specialColor,
                                    fontSize: 10)),
                          ],
                        ),
                        //
                        SizedBox(height: size(6)),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: sizeW(8)),
                            Image.asset(
                              IconSet.dollarCircledIcon,
                              height: size(13),
                              width: sizeW(13),
                            ),
                            SizedBox(width: sizeW(2.5)),
                            Text(
                                '${match.escrowPrice <= 0 ? 'Free' : match.escrowPrice}',
                                style: context.textTheme.labelSmall.copyWith(
                                    color: ColorSet.specialColor,
                                    fontSize: 10)),
                            SizedBox(width: sizeW(8)),
                            Image.asset(
                              IconSet.clockIcon,
                              height: size(13),
                              width: sizeW(13),
                            ),
                            SizedBox(width: sizeW(2.5)),
                            Text(
                                '${startTime.hour}:${startTime.minute}-${endTime.hour}:${endTime.minute}',
                                style: context.textTheme.labelSmall.copyWith(
                                    color: ColorSet.specialColor,
                                    fontSize: 10)),
                          ],
                        )
                        //
                      ],
                    ),
                  ),
                ),
                //
                SizedBox(width: sizeW(14)),
                //
                SizedBox(
                  height: size(160),
                  width: sizeW(142),
                  child: Card(
                    color: ColorSet.homeMainCardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Container(
                          height: size(80),
                          width: sizeW(142),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(testImage9),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(sizeW(14)),
                              topRight: Radius.circular(sizeW(14)),
                            ),
                          ),
                        ),
                        //
                        SizedBox(height: size(6)),
                        //
                        Padding(
                          padding: EdgeInsets.only(left: sizeW(8)),
                          child: Text('90’s Hip-Hop',
                              style: context.textTheme.bodySmallBold
                                  .copyWith(fontWeight: FontWeight.w700)),
                        ),
                        //
                        SizedBox(height: size(6)),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: sizeW(8)),
                            Image.asset(
                              IconSet.cardGroupIcon,
                              height: size(13),
                              width: sizeW(13),
                            ),
                            SizedBox(width: sizeW(2.5)),
                            Text('${match.guests} guests',
                                style: context.textTheme.labelSmall.copyWith(
                                    color: ColorSet.specialColor,
                                    fontSize: 10)),
                          ],
                        ),
                        //
                        SizedBox(height: size(6)),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: sizeW(8)),
                            Image.asset(
                              IconSet.dollarCircledIcon,
                              height: size(13),
                              width: sizeW(13),
                            ),
                            SizedBox(width: sizeW(2.5)),
                            Text(
                                '${match.escrowPrice <= 0 ? 'Free' : match.escrowPrice}',
                                style: context.textTheme.labelSmall.copyWith(
                                    color: ColorSet.specialColor,
                                    fontSize: 10)),
                            SizedBox(width: sizeW(8)),
                            Image.asset(
                              IconSet.clockIcon,
                              height: size(13),
                              width: sizeW(13),
                            ),
                            SizedBox(width: sizeW(2.5)),
                            Text(
                                '${startTime.hour}:${startTime.minute}-${endTime.hour}:${endTime.minute}',
                                style: context.textTheme.labelSmall.copyWith(
                                    color: ColorSet.specialColor,
                                    fontSize: 10)),
                          ],
                        )
                        //
                      ],
                    ),
                  ),
                ),
                //
                const Spacer(),
                //
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onCardPositionChanged(SwiperPosition position) {
    double width = FinalSize.width(context);
    double defaultWidth = sizeW(343);
    setState(() {
      backCard2Top -= 2;
      if (backCard1Top > size(195)) {
        backCard1Top -= 1;
        if (backCard1Top < size(280)) {
          backCard1Color = ColorSet.home2ndCardColor;
          backCardMoke1Color = ColorSet.home3rdCardColor;
        }
      }
      if (backCard1Left > (width / 2) - ((defaultWidth * 0.9) / 2)) {
        backCard1Left -= 0.5;
      }
      if (backCard1Width < sizeW(303)) {
        backCard1Width++;
      }
      if (backCardMoke1Width < sizeW(263)) {
        backCardMoke1Width += 2;
      }
    });
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    switch (activity) {
      case Swipe():
        setState(() {
          double width = FinalSize.width(context);
          double defaultWidth = sizeW(343);
          backCard1Left = (width / 2) - ((defaultWidth * 0.8) / 2);
          backCard2Top = size(195);
          backCard1Top = size(210);
          backCard2Width = sizeW(303);
          backCard1Width = sizeW(263);
          backCard1Height = size(399);
          backCard1Color = ColorSet.home3rdCardColor;
          backCard2Color = ColorSet.home2ndCardColor;
          backCardMoke1Color = ColorSet.home3rdCardColor;
          backCardMoke1Width = sizeW(200);
          //
        });
        break;
      case Unswipe():
        print('A ${activity.direction.name} swipe was undone.');
        print('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        print('A swipe was cancelled');
        break;
      case DrivenActivity():
        print('Driven Activity');
        break;
    }
  }

  void _onEnd() {
    print('end reached!');
  }

  Future<void> shakeCard() async {
    const double distance = 30;
    // We can animate back and forth by chaining different animations.
    await controller.animateTo(
      const Offset(-distance, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await controller.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // We need to animate back to the center because `animateTo` does not center
    // the card for us.
    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

//
}

class Match {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final int minAge;
  final int maxAge;
  final int guestLimit;
  final double escrowPrice;
  final double cashPrice;
  final String paymentType;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String eventCategoryId;
  final String time;
  final int guests;
  final String profile;
  final int followers;
  final double rating;
  final Medal medal;
  final ModelType type;

  Match({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.minAge,
    required this.maxAge,
    required this.guestLimit,
    required this.escrowPrice,
    required this.cashPrice,
    required this.paymentType,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.eventCategoryId,
    required this.time,
    required this.guests,
    required this.profile,
    required this.followers,
    required this.rating,
    required this.medal,
    required this.type,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['image_url'],
      minAge: json['min_age'],
      maxAge: json['max_age'],
      guestLimit: json['Guest_limit'],
      escrowPrice: json['escrow_price'].toDouble(),
      cashPrice: json['cash_price'].toDouble(),
      paymentType: json['payment_type'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
      eventCategoryId: json['eventCategoryId'],
      time: json['time'],
      guests: json['guests'],
      profile: json['profile'],
      followers: json['followers'],
      rating: json['rating'].toDouble(),
      medal: Medal.fromJson(json['medal']),
      type: ModelType.fromJson(json['type']),
    );
  }
}

class Medal {
  final String icon;
  final String medalName;
  final String name;
  final String position;
  final String command;
  final double rating;

  Medal({
    required this.icon,
    required this.medalName,
    required this.name,
    required this.position,
    required this.command,
    required this.rating,
  });

  factory Medal.fromJson(Map<String, dynamic> json) {
    return Medal(
      icon: json['icon'],
      medalName: json['medalName'],
      name: json['name'],
      position: json['position'],
      command: json['command'],
      rating: json['rating'].toDouble(),
    );
  }
}

class ModelType {
  final String type;
  final String image;

  ModelType({
    required this.type,
    required this.image,
  });

  factory ModelType.fromJson(Map<String, dynamic> json) {
    return ModelType(
      type: json['type'],
      image: json['image'],
    );
  }
}

List<Match> matches = [];

// Cm Mt Screen
