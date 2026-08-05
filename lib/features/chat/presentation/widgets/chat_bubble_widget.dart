import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/kumele_rich_text.dart';
import 'package:lottie/lottie.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatRoomMessageEntity chat;

  const ChatBubbleWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    bool itsME = chat.userId == InjectionHelper.profileCubit.userData?.id;
    Color tileColor =
        itsME ? ColorSet.chatTileColor : ColorSet.specialYellowColor;
    return LayoutBuilder(builder: (context, constrain) {
      final maxWidth = constrain.biggest.width;
      return Align(
        alignment: itsME ? Alignment.centerRight : Alignment.centerLeft,
        child: SizedBox(
          width: maxWidth *
              (Utils.isPortrait ? (FormFactor.isTablet ? 0.7 : 0.9) : 0.55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                itsME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                padding: EdgeInsets.all(size(12)),
                decoration: BoxDecoration(
                  borderRadius: itsME
                      ? BorderRadius.only(
                          topLeft: Radius.circular(size(16)),
                          topRight: Radius.circular(size(16)),
                          bottomLeft: Radius.circular(size(16)),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(size(16)),
                          topRight: Radius.circular(size(16)),
                          bottomRight: Radius.circular(size(16)),
                        ),
                  color: tileColor,
                ),
                child: Row(
                  mainAxisAlignment: itsME
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAvatar(
                      size: 36,
                      imageUrl: chat.userAvatar,
                      name: chat.userDisplayName,
                    ),
                    Gap(8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chat.userDisplayName,
                              style: context.textTheme.titleMediumBold
                                  .copyWith(color: Colors.black, fontSize: 15)),
                          const Gap(4),
                          KumeleTextLink(
                              leading: '',
                              trailing: chat.content,
                              leadingStyle: context.textTheme.bodyMedium
                                  .copyWith(
                                      color: ColorSet.specialBlueColor,
                                      fontWeight: FontWeight.bold),
                              trailingStyle: context.textTheme.bodyMedium
                                  .copyWith(
                                      color:
                                          itsME ? Colors.black : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                              overflow: TextOverflow.visible),
                          const Gap(4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              ConversionUtils.formatDateTime(
                                  chat.createdAt, 'hh:mm a'),
                              style: context.textTheme.bodySmall.copyWith(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(6),
              Lottie.asset(IconSet.jsonSpeechBubble,
                  width: 40, height: 40, fit: BoxFit.fill),
            ],
          ),
        ),
      );
    });
  }
}
