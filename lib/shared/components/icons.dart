import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/navigation/app_routes.dart';

goto(BuildContext context, String routeName, {Object? arguments}) {
  try {
    final location = switch (routeName) {
      'home' => AppRoutes.home,
      'chat/list' => AppRoutes.chatList,
      _ => '/$routeName',
    };
    context.go(location, extra: arguments);
  } catch (e) {
    //
  }
}

pop(context) {
  context.pop();
}

// class IconSet {
//   static String appbarTopImage = 'assets/appBar/top.png';
//   static String logoImage = 'assets/logo/kumele_logo.png';
//   static String captchaIcon = 'assets/icons/captcha.png';
//   static String sportsIcon = 'assets/icons/basket_ball.png';
//   static String pybsbarsIcon = 'assets/icons/beer.png';
//   static String activismIcon = 'assets/icons/billboard.png';
//   static String eroticIcon = 'assets/icons/bottom.png';
//   static String cannabisIcon = 'assets/icons/cannabis.png';
//   static String familyActivitiesIcon = 'assets/icons/carousel.png';
//   static String techIcon = 'assets/icons/code.png';
//   static String clubbingIcon = 'assets/icons/disco_ball.png';
//   static String outdoorsIcon = 'assets/icons/forest.png';
//   static String videoGamesIcon = 'assets/icons/game_controller.png';
//   static String volunteerIcon = 'assets/icons/gift.png';
//   static String boardGamesIcon = 'assets/icons/knight.png';
//   static String moviesIcon = 'assets/icons/movie_projector.png';
//   static String psychedelicIcon = 'assets/icons/mushroom.png';
//   static String festivalIcon = 'assets/icons/pickup_point.png';
//   static String petLoveIcon = 'assets/icons/shiba.png';
//   static String costumeIcon = 'assets/icons/sombrero.png';
//   static String diyIcon = 'assets/icons/tool_storage_box.png';
//   static String liveShowIcons = 'assets/icons/us_music.png';
//   static String spritualityIcon = 'assets/icons/yin_yang.png';
//   static String vanLifeIcon = 'assets/icons/van.png';
//   static String path = 'assets/icons/';
//   static String get emailIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}email_dark.png' : '${path}email.png';
//   }
//   static String get accountIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}account_dark.png' : '${path}account.png';
//   }
//   static String get eyeIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}eye_dark.png' : '${path}eye.png';
//   }
//   static String get lockIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}lock_dark.png' : '${path}lock.png';
//   }
//   static String get keyIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}key_dark.png' : '${path}key.png';
//   }
//   static String get dropDownIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}drop_down_dark.png' : '${path}drop_down.png';
//   }
//   static String get arrowBackIcon {
//     Brightness platformBrightness = ui.window.platformBrightness;
//     bool isDarkMode = platformBrightness == Brightness.dark;
//     return isDarkMode ? '${path}arrow_back_dark.png' : '${path}arrow_back.png';
//   }
// }

String testImage2 = 'assets/testImage2.png';
String testImage3 = 'assets/testImage3.png';
String testImage4 = 'assets/testImage4.png';
String testImage5 = 'assets/testImage5.gif';
String testImage6 = 'assets/testImage6.png';
String testImage7 = 'assets/testImage7.png';
String testImage8 = 'assets/testImage8.png';
String testImage9 = 'assets/testImage9.png';
String blogImage1 = 'assets/blog_image_1.png';
String blogImage2 = 'assets/blog_image_2.png';
String blogImage3 = 'assets/blog_image_3.png';
String chatImage1 = 'assets/chat_image_1.png';

class IconSet {
  static String path = 'assets/icons/';
  static String path2 = 'assets/appBar/';
  static String path3 = 'assets/logo/';

  static bool get isDarkMode => InjectionHelper.profileCubit.isDark;

  static String getIcon(String iconName, {String format = 'png'}) {
    switch (iconName) {
      case 'top':
        return isDarkMode
            ? '$path2$iconName.$format'
            : '$path2$iconName.$format';
      case 'kumele_logo':
        return isDarkMode
            ? '$path3$iconName.$format'
            : '$path3$iconName.$format';
      case 'card_logo':
        return isDarkMode
            ? '$path3$iconName.$format'
            : '$path3$iconName.$format';
      case 'blogImage':
        return isDarkMode
            ? '$path3$iconName.$format'
            : '$path3$iconName.$format';
      case 'no_matches':
        return isDarkMode
            ? '$path3$iconName.$format'
            : '$path3$iconName.$format';
      case 'captcha':
        return isDarkMode ? '$path$iconName.$format' : '$path$iconName.$format';
      case 'success':
        return isDarkMode ? '$path$iconName.$format' : '$path$iconName.$format';
      default:
        return isDarkMode
            ? '$path${iconName}_dark.$format'
            : '$path$iconName.$format';
    }
  }

  static String getRevertIcon(String iconName, {String format = 'png'}) {
    return isDarkMode
        ? '$path$iconName.$format'
        : '$path${iconName}_dark.$format';
  }

  static String getSocialIcon(String iconName) {
    String patha = 'assets/social/';
    return isDarkMode ? '$patha${iconName}_dark.png' : '$patha$iconName.png';
  }

  static String getJsonIcon(String iconName) {
    String jsonIcon = 'assets/icons_json/';
    return isDarkMode
        ? '$jsonIcon${iconName}_dark.json'
        : '$jsonIcon$iconName.json';
  }

  static String getSvgIcon(String iconName) {
    String jsonIcon = 'assets/svg/';
    return isDarkMode
        ? '$jsonIcon${iconName}_dark.svg'
        : '$jsonIcon$iconName.svg';
  }

  static String get appbarTopImage => getIcon('top');
  static String get logoImage => getIcon('kumele_logo');
  static String get person => getIcon('person');
  static String get multiperson => getIcon('multiperson');

  static String get captchaIcon => getIcon('captcha');
  static String get sportsIcon => getIcon('basket_ball');
  static String get pybsbarsIcon => getIcon('beer');
  static String get activismIcon => getIcon('billboard');
  static String get eroticIcon => getIcon('bottom');
  static String get bookshelf => getIcon('bookshelf');
  static String get kuemele => getIcon('kuemele');

  static String get cannabisIcon => getIcon('cannabis');
  static String get ytblog => getIcon('youtubeblog');

  static String get familyActivitiesIcon => getIcon('carousel');
  static String get techIcon => getIcon('code');
  static String get clubbingIcon => getIcon('disco_ball');
  static String get outdoorsIcon => getIcon('forest');
  static String get videoGamesIcon => getIcon('game_controller');
  static String get volunteerIcon => getIcon('gift');
  static String get boardGamesIcon => getIcon('knight');
  static String get eventshare => getIcon('eventshare');
  static String get copytoclip => getIcon('copytoclip');
  static String get googleicon => getIcon('googleicon');

  static String get moviesIcon => getIcon('movie_projector');
  static String get psychedelicIcon => getIcon('mushroom');
  static String get atmcard => getIcon('atmcard');
  static String get crypto => getIcon('crypto');
  static String get doublestar => getIcon('doublestar');
  static String get spotifyicon => getIcon('spotifyicon');
  static String get rec => getIcon('rec');
  static String get itsgo => getIcon('itsgo');
  static String get marshmellow => getIcon('marshmellow');

  static String get tik => getIcon('tik');
  static String get notfication => getIcon('notfication');
  static String get speaker => getIcon('speaker');
  static String get birthdaybanner => getIcon('birthdaybanner');
  static String get gift => getIcon('gift');
  static String get welcomebanner => getIcon('welcomebanner');

  static String get report => getIcon('report');
  static String get person1 => getIcon('person1');
  static String get festivalIcon => getIcon('pickup_point');
  static String get petLoveIcon => getIcon('shiba');
  static String get costumeIcon => getIcon('sombrero');
  static String get diyIcon => getIcon('tool_storage_box');
  static String get celebratelight => getIcon('celebratelight');
  static String get buy => getIcon('buy');

  static String get liveShowIcons => getIcon('us_music');
  static String get spritualityIcon => getIcon('yin_yang');
  static String get vanLifeIcon => getIcon('van');
  static String get emailIcon => getIcon('email');
  static String get accountIcon => getIcon('account');
  static String get eyeIcon => getIcon('eye');
  static String get botharrow => getIcon('botharrow');
  static String get location => getIcon('location');
  static String get tickSelected => getIcon('tick_selected');
  static String get tickUnselected => getIcon('tick_unselected');
  static String get switchSelected => getIcon('switch_selected');
  static String get switchUnselected => getIcon('switch_unselected');
  static String get backcircle => getIcon('backcircle');
  static String get rightcircle => getIcon('backcircle');
  static String get arrowleft => getIcon('arrowleft');
  static String get threedot => getIcon('threedot');

  static String get lockIcon => getIcon('lock');
  static String get create1 => getIcon('create1');
  static String get create2 => getIcon('create2');
  static String get create3 => getIcon('create3');
  static String get create4 => getIcon('create4');
  static String get create5 => getIcon('create5');
  static String get create6 => getIcon('create6');
  static String get create7 => getIcon('create7');
  static String get create8 => getIcon('create8');
  static String get create9 => getIcon('create1');

  static String get keyIcon => getIcon('key');
  static String get dropDownIcon => getIcon('drop_down');
  static String get arrowBackIcon => getIcon('arrow_back');
  static String get medalIcon => getIcon('medal');
  static String get noMatchesIcon => getIcon('no_matches');
  static String get groupIcon => getIcon('group');
  static String get selfIcon => getIcon('self');
  static String get shareIcon => getIcon('share');
  static String get tapHomeIcon => getIcon('tap_home');
  static String get basketIcon => getIcon('basket');
  static String get diversityIcon => getIcon('diversity');
  static String get expandArrowIcon => getIcon('expand_arrow');
  static String get cardGroupIcon => getIcon('group_card');
  static String get clockIcon => getIcon('clock');
  static String get dollarCircledIcon => getIcon('dollar_circled');
  static String get timerIcon => getIcon('timer');
  static String get starIcon => getIcon('star');
  static String get moreIcon => getIcon('menu');
  static String get qrIcon => getIcon('qr');
  static String get sendIcon => getIcon('sendBTN');
  static String get faceid => getIcon('faceid');
  static String get thumbid => getIcon('touchid');
  static String get addIcon => getIcon('add');
  static String get editIcon => getIcon('edit');
  static String get soundIcon => getIcon('sound');
  static String get atmIcon => getIcon('atm_card');
  static String get etherum => getIcon('etherum');
  static String get doge => getIcon('doge');
  static String get usdcoin => getIcon('usdcoin');
  static String get speakerone => getIcon('speakerone');
  static String get redok => getIcon('redok');
  static String get paypal => getIcon('paypal');
  static String get ok => getIcon('ok');

  static String get arrowRightIcon => getIcon('arrow_right');
  static String get headSetIcon => getIcon('headset');
  static String get guideLineIcon => getIcon('guideline');
  static String get iIcon => getIcon('i');
  static String get nightModeIcon => getIcon('night_mode');
  static String get warningIcon => getIcon('warning');
  static String get signOutIcon => getIcon('signout');
  static String get cardLogoIcon => getIcon('card_logo');
  static String get celebrateIcon => getIcon('celebrate');
  static String get celebrateRevertIcon => getRevertIcon('celebrate');
  static String get kireedamIcon => getIcon('kireedam');
  static String get aircraftIcon => getIcon('aircraft');
  static String get ticketsIcon => getIcon('tickets');
  static String get chatIcon => getIcon('chat');
  static String get chat2Icon => getIcon('chat2');
  static String get chat3Icon => getIcon('chat3');
  static String get bookshelf2 => getIcon('bookshelf2');
  static String get shop => getIcon('shop');
  static String get bar => getIcon('bar');

  static String get filter => getIcon('filter');
  static String get paint => getIcon('paint');

  static String get imageAddIcon => getIcon('image_add');
  static String get blogDefaultImage => getIcon('blogImage');
  static String get doneIcon => getIcon('done');
  static String get closeIcon => getIcon('close');
  static String get heartIcon => getIcon('heart');
  static String get mapIcon => getIcon('map');
  static String get pictureIcon => getIcon('picture');
  static String get trashIcon => getIcon('trash');
  //
  static String get magicianIcon => getIcon('magician');
  static String get artsCraftIcon => getIcon('arts_craft');
  static String get photographyIcon => getIcon('photography');
  static String get gardeningIcon => getIcon('gardening');
  static String get campingIcon => getIcon('camping');
  static String get housePartyIcon => getIcon('house_party');
  static String get foodieIcon => getIcon('foodie');
  //
  static String get notificationsIcon => getIcon('notifications');
  static String get historyStatisticsIcon => getIcon('history_statistics');
  static String get findHobbyEventsIcon => getIcon('find_hobby_events');
  static String get createHobbyEventsIcon => getIcon('create_hobby_events');
  //
  static String get successGifIcon => getIcon('success', format: 'gif');
  static String get warningGifIcon => getIcon('warning_gif', format: 'gif');
  static String get sunGifIcon => getIcon('sun_gif', format: 'gif');
  static String get medalGifIcon => getIcon('medal', format: 'gif');
  //
  static String get calendarIcon => getIcon('calendar');
  static String get eventsCalendarIcon => getIcon('events_calendar');
  static String get searchIcon => getIcon('search');
  //
  static String get matchedBGImage => 'assets/logo/matched.png';
  //id
  static String get youtubeIcon => getSocialIcon('youtube');
  static String get facebookIcon => getSocialIcon('facebook');
  static String get instagramIcon => getSocialIcon('instagram');
  static String get pinterestIcon => getSocialIcon('pinterest');
  static String get twitterIcon => getSocialIcon('twitter');
  static String get paypalIcon => getSocialIcon('paypal');
  //
  static const String _socialPath = 'assets/social/';

  static String get blogYoutubeIcon => isDarkMode
      ? '${_socialPath}icons8-youtubedark.png'
      : '${_socialPath}icons8-youtubelight.png';
  static String get blogFacebookIcon => isDarkMode
      ? '${_socialPath}icons8-facebook-dark.png'
      : '${_socialPath}icons8-facebook-light.png';
  static String get blogInstagramIcon => isDarkMode
      ? '${_socialPath}icons8-instagramdark.png'
      : '${_socialPath}icons8-instagramlight.png';
  static String get blogPinterestIcon => isDarkMode
      ? '${_socialPath}icons8-pinterestdark.png'
      : '${_socialPath}icons8-pinterestlight.png';
  static String get blogTwitterIcon => isDarkMode
      ? '${_socialPath}icons8-twitterdark.png'
      : '${_socialPath}icons8-twitterlight.png';
  static String get blogShareIcon => isDarkMode
      ? '${_socialPath}icons8-share-24 1dark.png'
      : '${_socialPath}icons8-share-24 1light.png';
  static String get likedIcon =>
      isDarkMode ? '${_socialPath}liked_dark.png' : '${_socialPath}liked_light.png';
  static String get unlikedIcon => isDarkMode
      ? '${_socialPath}unliked_dark.png'
      : '${_socialPath}unliked_light.png';
  static String get paypalConnectedIcon => isDarkMode
      ? '${_socialPath}connected_dark.png'
      : '${_socialPath}connected_light.png';
  static String get paypalNotConnectedIcon => isDarkMode
      ? '${_socialPath}notConnected_dark.png'
      : '${_socialPath}notConnected_light.png';
  //
  static String get copyIcon => getIcon('copy');
  static String get bluetoothIcon => getIcon('bluetooth');
  static String get gdriveIcon => getIcon('g_drive');
  static String get whatsappIcon => getIcon('whatsapp');

  // Json Icons
  static String get jsonCheckMark => getJsonIcon('checkmark');
  static String get jsonClock => getJsonIcon('clock');
  static String get jsonError => getJsonIcon('error');
  static String get jsonFirework => getJsonIcon('firework');
  static String get jsonGift => getJsonIcon('gift');
  static String get jsonImportant => getJsonIcon('important');
  static String get jsonLoading => getJsonIcon('loading');
  static String get jsonManCandy => getJsonIcon('man_candy');
  static String get jsonMarshmallows => getJsonIcon('marshmallows');
  static String get jsonOk => getJsonIcon('ok');
  static String get jsonPadLock => getJsonIcon('padlock');
  static String get jsonPrize => getJsonIcon('prize');
  static String get jsonSpeechBubble => getJsonIcon('speech_bubble');
  static String get jsonSun => getJsonIcon('sun');
  static String get jsonToast => getJsonIcon('toast');
  static String get jsonAnimMarshmallows => getJsonIcon('anim_marshmallows');
  //
}
