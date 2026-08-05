import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';

final List<ChatRoomEntity> dummyChatRooms = List.generate(
  5,
  (index) => ChatRoomEntity(
    id: 'id_$index',
    eventId: 'eventId_$index',
    eventName: 'Loading event name',
    eventDate: DateTime.now(),
    eventImage: '',
    hostId: 'hostId',
    hostName: 'Host name',
    hostImage: '',
    status: 'ACTIVE',
    isOpen: true,
  ),
);

class ChatMessage {
  final String from;
  final String date;
  final String time;
  final String msg;
  final String reaction;
  final List<SeenInfo> seenList;
  final bool itsME;
  final String profile;
  final bool typing;
  final List<Tag>? tags;

  ChatMessage({
    required this.from,
    required this.date,
    required this.time,
    required this.msg,
    required this.reaction,
    this.seenList = const [],
    required this.itsME,
    required this.profile,
    required this.typing,
    this.tags,
  });

  factory ChatMessage.fakeOther(String date, String msg) => ChatMessage(
        typing: true,
        from: "Alkesh kumar",
        date: date,
        time: "10:30 AM",
        msg: msg,
        reaction: "thumbsUp",
        itsME: false,
        profile: testImage2,
      );

  factory ChatMessage.fakeMe(String date, String msg) => ChatMessage(
        typing: true,
        from: "Josh durrant",
        date: date,
        time: "10:30 AM",
        msg: msg,
        reaction: "thumbsUp",
        itsME: true,
        profile: testImage3,
      );
}

class Tag {
  final String name;
  final String profileImagePath;
  final String id;
  Tag({required this.name, required this.profileImagePath, required this.id});
}

class SeenInfo {
  final String name;
  final String profileImagePath;
  final String seenTime;
  final String seenDate;

  SeenInfo({
    required this.name,
    required this.profileImagePath,
    required this.seenTime,
    required this.seenDate,
  });
}

class ChatModel {
  final String type;
  final String iconSet;
  final String title;
  final String hostName;
  final String date;
  final String rateAndReview;
  final int days;
  final List<String> scannedList;
  final List<ChatMessage> chats;
  bool isEnabled;

  ChatModel({
    required this.type,
    required this.title,
    required this.hostName,
    required this.date,
    required this.rateAndReview,
    required this.days,
    required this.scannedList,
    required this.chats,
    required this.iconSet,
    required this.isEnabled,
  });
}

class InterestsModel {
  final String svgCode;
  final String title;
  final bool isSelected;

  InterestsModel({
    required this.svgCode,
    required this.title,
    required this.isSelected,
  });
}

List<InterestsModel> interests = [
  InterestsModel(
      svgCode: SVGAsset.icon_van, title: 'Van Life', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_yinyang, title: 'Spirituality', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_knight, title: 'Board Games', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_movie, title: 'Movies', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_sport, title: 'Sports', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_pub, title: 'Pubs & Bars', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_party, title: 'Live show', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_live_show, title: 'Clubbing', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_clubbing, title: 'Festival', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_activism, title: 'Outdoors', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_pet, title: 'Volunteer', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_outdoor, title: 'Erotic', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_festival, title: 'Video Games', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_volunteer,
      title: 'Family activities',
      isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_diy, title: 'Cannabis', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_video_game, title: 'Tech', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_family, title: 'Costume', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_costume, title: 'Foodie', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_foodie, title: 'House Party', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_camping, title: 'Camping', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_other, title: 'Gardening', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_photo, title: 'Photography', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_tech, title: 'Arts & Craft', isSelected: false),
  InterestsModel(
      svgCode: SVGAsset.icon_garden, title: 'Other', isSelected: false),
];

List<ChatModel> demoChatList = [
  ChatModel(
    type: "Van Life",
    title: "Van Life Adventure",
    hostName: "Adventure Explorer",
    date: "8th Oct 2022",
    rateAndReview: "4.5",
    days: 7,
    scannedList: ["John", "Emma", "Chris"],
    iconSet: SVGAsset.icon_van,
    isEnabled: true,
    chats: [
      ChatMessage(
        typing: true,
        from: "Alkesh Kumar",
        date: "8th Oct 2022",
        time: "10:30 AM",
        msg: "Welcome to my event",
        reaction: "thumbsUp",
        itsME: false,
        profile: testImage2,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: blogImage1,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: chatImage1,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: blogImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: blogImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
      ChatMessage(
        typing: true,
        from: "Josh Durrant",
        date: "2023-11-29",
        time: "9:45 AM",
        msg: "Absolutely! Can't wait to hit the road.",
        reaction: "heart",
        itsME: true,
        profile: blogImage1,
        tags: [
          Tag(name: 'Alkesh Kumar', profileImagePath: testImage2, id: 'id'),
        ],
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
    ],
  ),
  ChatModel(
    type: "Psychedelic",
    title: "Mind-Expanding Journey",
    hostName: "Psychedelic Explorer",
    date: "8th Oct 2022",
    rateAndReview: "4.8",
    days: 5,
    scannedList: ["Alice", "Bob", "Charlie"],
    iconSet: SVGAsset.icon_art,
    isEnabled: true,
    chats: [
      ChatMessage(
        typing: true,
        from: "Alice",
        date: "8th Oct 2022",
        time: "8:00 PM",
        msg: "Hey, are you ready for the psychedelic journey?",
        reaction: "peace",
        itsME: false,
        profile: testImage2,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
      ChatMessage(
        typing: true,
        from: "Bob",
        date: "2023-12-06",
        time: "10:15 AM",
        msg: "Absolutely! Let's explore the unknown.",
        reaction: "star",
        itsME: true,
        profile: testImage3,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
    ],
  ),
  ChatModel(
    type: "Spirituality",
    title: "Spiritual Retreat",
    hostName: "Spiritual Guide",
    date: "2023-12-10",
    rateAndReview: "4.7",
    days: 3,
    scannedList: ["Grace", "David", "Sophie"],
    iconSet: SVGAsset.icon_yinyang,
    isEnabled: false,
    chats: [
      ChatMessage(
        typing: true,
        from: "Grace",
        date: "2023-12-10",
        time: "9:00 AM",
        msg: "Namaste! Are you excited for the spiritual retreat?",
        reaction: "meditation",
        itsME: false,
        profile: testImage2,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
      ChatMessage(
        typing: true,
        from: "David",
        date: "2023-12-11",
        time: "11:45 AM",
        msg: "Absolutely! Let's find inner peace together.",
        reaction: "om",
        itsME: true,
        profile: testImage3,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
    ],
  ),
  ChatModel(
    type: "Board Games",
    title: "Board Game Night",
    hostName: "Game Master",
    date: "8th Oct 2022",
    rateAndReview: "4.6",
    days: 1,
    scannedList: ["Michael", "Olivia", "Daniel"],
    iconSet: SVGAsset.icon_knight,
    isEnabled: false,
    chats: [
      ChatMessage(
        typing: true,
        from: "Michael",
        date: "8th Oct 2022",
        time: "7:00 PM",
        msg: "Hey, get ready for a night of intense board games!",
        reaction: "dice",
        itsME: false,
        profile: testImage2,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
      ChatMessage(
        typing: true,
        from: "Olivia",
        date: "8th Oct 2022",
        time: "8:30 PM",
        msg: "I'm bringing my favorite games. Can't wait!",
        reaction: "boardGame",
        itsME: true,
        profile: testImage3,
        seenList: [
          SeenInfo(
              name: "Emma",
              profileImagePath: matchedBGImage,
              seenTime: "11:00 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
              name: "Chris",
              profileImagePath: testImage4,
              seenTime: "11:15 AM",
              seenDate: "8th Oct 2022"),
          SeenInfo(
            name: "George",
            profileImagePath: testImage3,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
          SeenInfo(
            name: "Moh",
            profileImagePath: testImage2,
            seenTime: "11:15 AM",
            seenDate: "8th Oct 2022",
          ),
        ],
      ),
    ],
  ),
];

String testImage2 = 'https://via.placeholder.com/150';
String testImage3 = 'https://via.placeholder.com/150';
String testImage4 = 'https://via.placeholder.com/150';
String blogImage1 = 'https://via.placeholder.com/150';
String blogImage2 = 'https://via.placeholder.com/150';
String blogImage3 = 'https://via.placeholder.com/150';
String chatImage1 = 'https://via.placeholder.com/150';
String matchedBGImage = 'https://via.placeholder.com/150';
