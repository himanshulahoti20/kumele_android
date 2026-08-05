enum EventType {
  activism,
  artsCraft,
  boardGames,
  camping,
  clubbing,
  costume,
  diy,
  familyActivities,
  festival,
  foodie,
  gardening,
  houseParty,
  liveShow,
  movies,
  other,
  outdoors,
  petLove,
  photography,
  pubsAndBars,
  sports,
  spirituality,
  tech,
  vanLife,
  videoGames,
  volunteer;

  String get label => switch (this) {
        EventType.activism => 'Activism',
        EventType.artsCraft => 'Arts & Craft',
        EventType.boardGames => 'Board Games',
        EventType.camping => 'Camping',
        EventType.clubbing => 'Clubbing',
        EventType.costume => 'Costume',
        EventType.diy => 'DIY',
        EventType.familyActivities => 'Family activities',
        EventType.festival => 'Festival',
        EventType.foodie => 'Foodie',
        EventType.gardening => 'Gardening',
        EventType.houseParty => 'House Party',
        EventType.liveShow => 'Live show',
        EventType.movies => 'Movies',
        EventType.other => 'Other',
        EventType.outdoors => 'Outdoors',
        EventType.petLove => 'Pet love',
        EventType.photography => 'Photography',
        EventType.pubsAndBars => 'Pubs & Bars',
        EventType.sports => 'Sports',
        EventType.spirituality => 'Sprituality',
        EventType.tech => 'Tech',
        EventType.vanLife => 'Van Life',
        EventType.videoGames => 'Video Games',
        EventType.volunteer => 'Volunteer'
      };

  // String get icon => switch (this) {
  //       EventType.activism => 'Activism',
  //       EventType.artsCraft => SVGAsset.icon_tech,
  //       EventType.boardGames => SVGAsset.icon_knight,
  //       EventType.camping => SVGAsset.icon_camping,
  //       EventType.clubbing => SVGAsset.icon_live_show,
  //       EventType.costume => SVGAsset.icon_family,
  //       EventType.diy => 'DIY',
  //       EventType.familyActivities => SVGAsset.icon_volunteer,
  //       EventType.festival => SVGAsset.icon_clubbing,
  //       EventType.foodie => SVGAsset.icon_costume,
  //       EventType.gardening => SVGAsset.icon_other,
  //       EventType.houseParty => SVGAsset.icon_foodie,
  //       EventType.liveShow => SVGAsset.icon_party,
  //       EventType.movies => SVGAsset.icon_movie,
  //       EventType.other => 'Other',
  //       EventType.outdoors => SVGAsset.icon_activism,
  //       EventType.petLove => 'Pet love',
  //       EventType.photography => SVGAsset.icon_photo,
  //       EventType.pubsAndBars => SVGAsset.icon_pub,
  //       EventType.sports => SVGAsset.icon_sport,
  //       EventType.spirituality => SVGAsset.icon_yinyang,
  //       EventType.tech => SVGAsset.icon_video_game,
  //       EventType.vanLife => SVGAsset.icon_van,
  //       EventType.videoGames => SVGAsset.icon_festival,
  //       EventType.volunteer => SVGAsset.icon_pet
  //     };
}

// List<InterestsModel> interests = [
//   InterestsModel(image: SVGAsset.icon_van, title: 'Van Life', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_yinyang, title: 'Spirituality', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_knight, title: 'Board Games', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_movie, title: 'Movies', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_sport, title: 'Sports', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_pub, title: 'Pubs & Bars', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_party, title: 'Live show', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_live_show, title: 'Clubbing', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_clubbing, title: 'Festival', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_activism, title: 'Outdoors', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_pet, title: 'Volunteer', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_outdoor, title: 'Erotic', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_festival, title: 'Video Games', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_volunteer, title: 'Family activities', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_diy, title: 'Cannabis', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_video_game, title: 'Tech', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_family, title: 'Costume', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_costume, title: 'Foodie', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_foodie, title: 'House Party', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_camping, title: 'Camping', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_other, title: 'Gardening', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_photo, title: 'Photography', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_tech, title: 'Arts & Craft', isSelected: false),
//   InterestsModel(image: SVGAsset.icon_garden, title: 'Other', isSelected: false),
// ];

extension StringToEventTypeExtension on String? {
  EventType? toEventType() {
    final lowercased = this?.toLowerCase().replaceAll(' ', '');
    for (var type in EventType.values) {
      if (type.label.toLowerCase().replaceAll(' ', '') == lowercased) {
        return type;
      }
    }
    return null;
  }
}
