import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/presentation/bloc/chat_room_bloc.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/chat_more_dialog.dart';
import 'package:kuemele/shared/modals/dialog/event_cancelled_dialog.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/core/responsive/responsive_scope.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.chat,
    required this.index,
    this.isCheckingAccess = false,
  });

  final ChatRoomEntity chat;
  final int index;
  final bool isCheckingAccess;

  void _requestOpenChat(BuildContext context) {
    context.read<ChatRoomBloc>().add(CheckChatAccess(chat: chat));
  }

  @override
  Widget build(BuildContext context) {
    final bool isEventCanceled = chat.status != 'ACTIVE';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: ColorSet.chatListTileFillColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              KumeleAssetWidget(
                assetPath: SVGAsset.icon_yinyang,
                width: 24,
                height: 24,
                color: ColorSet.textColor,
              ),
              const Gap(8),
              Text(
                AppLocalizations.of(context)!.spirituality,
                style: context.textTheme.titleMedium.copyWith(
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Builder(
                builder: (c) {
                  final renderBox = c.findRenderObject() as RenderBox?;
                  final position =
                      renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
                  final isOnBottomHalf = position.dy > Utils.getHeight / 2;
                  return AppRoundedIconButton(
                    assetPath: Assets.icons.chats.more.path,
                    iconSize: 15,
                    onTap: () {
                      final scopeData = ResponsiveScope.maybeOf(c);
                      Widget dialog = ChatMoreDialog(eventId: chat.eventId);
                      if (scopeData != null) {
                        dialog =
                            ResponsiveScope(data: scopeData, child: dialog);
                      }
                      AppDialog.attach(
                        context: c,
                        dialog: dialog,
                        alignment: isOnBottomHalf
                            ? Alignment.topRight
                            : Alignment.bottomRight,
                        targetBuilder: (offset, size) =>
                            Offset(offset.dx - 100, offset.dy),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const Gap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.eventName,
                      style: context.textTheme.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      '${AppLocalizations.of(context)!.hostedBy} ${chat.hostName}',
                      style: context.textTheme.bodyMedium.copyWith(
                        color: ColorSet.special1Color,
                      ),
                    ),
                    const Gap(12),
                    Text(
                      chat.eventDate != null
                          ? Utils.convertDateTimeToPatternTime(
                              chat.eventDate!, 'd MMM, yyyy')
                          : '--',
                      style: context.textTheme.labelMedium.copyWith(
                        color: ColorSet.chatListTileDateColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isEventCanceled)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.daysLeftToRate,
                          style: context.textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    Container(
                      height: 9,
                      width: 130,
                      padding: const EdgeInsets.all(1.8),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorSet.revertBgColor,
                      ),
                      child: Container(
                        width: isEventCanceled ? 0 : 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorSet.specialYellowColor,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      AppLocalizations.of(context)!.scannedList,
                      style: context.textTheme.bodySmallBold.copyWith(
                        color: ColorSet.chatListTileDateColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton.primary(
                label: isEventCanceled
                    ? AppLocalizations.of(context)!.eventCanceled
                    : AppLocalizations.of(context)!.chat,
                isLoading: isCheckingAccess,
                fullWidth: false,
                onPressed: () {
                  if (isEventCanceled) {
                    showDialog(
                      context: context,
                      builder: (_) => const EventCancelledDialog(),
                    );
                  } else {
                    _requestOpenChat(context);
                  }
                },
              ),
              if (!chat.isOpen) Assets.icons.trash.image(width: 20, height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
