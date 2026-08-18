import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/chat/data/chat_event_details_cache.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/presentation/bloc/chat_room_bloc.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/chat_more_dialog.dart';
import 'package:kuemele/shared/modals/dialog/event_cancelled_dialog.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/core/responsive/responsive_scope.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

/// Assumed rate/review window: 7 days from the event date. The chat-room
/// API has no explicit rating-deadline field, only open/close state, so
/// this is an approximation until the backend exposes a real deadline.
/// ponytail: fixed 7-day window, swap for a real `reviewClosesAt` field
/// if/when the API adds one.
const _reviewWindowDays = 7;

class ChatListItem extends StatefulWidget {
  const ChatListItem({
    super.key,
    required this.chat,
    required this.index,
    this.isCheckingAccess = false,
  });

  final ChatRoomEntity chat;
  final int index;
  final bool isCheckingAccess;

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  ExploreEventDetail? _detail;

  @override
  void initState() {
    super.initState();
    _detail = ChatEventDetailsCache.peek(widget.chat.eventId);
    if (_detail == null) {
      ChatEventDetailsCache.load(widget.chat.eventId).then((detail) {
        if (mounted) setState(() => _detail = detail);
      });
    }
  }

  void _requestOpenChat(BuildContext context) {
    context.read<ChatRoomBloc>().add(CheckChatAccess(chat: widget.chat));
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final isEventCanceled = chat.status != 'ACTIVE';
    final isMuted = isEventCanceled || !chat.isOpen;

    final reviewDeadline =
        chat.eventDate?.add(const Duration(days: _reviewWindowDays));
    final daysRemaining = reviewDeadline == null
        ? 0
        : reviewDeadline
            .difference(DateTime.now())
            .inDays
            .clamp(0, _reviewWindowDays);
    final showReviewCountdown = !isEventCanceled && daysRemaining > 0;
    final reviewProgress = reviewDeadline == null
        ? 0.0
        : (1 - daysRemaining / _reviewWindowDays).clamp(0.0, 1.0);

    final categoryName = _detail?.primaryHobby ?? '';
    final scannedCount = _detail?.attendeeCount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: ColorSet.chatListTileFillColor,
      ),
      child: Column(
        children: [
          Opacity(
            opacity: isMuted ? 0.55 : 1.0,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildCategoryIcon(),
                    if (categoryName.isNotEmpty) ...[
                      const Gap(8),
                      Text(
                        categoryName,
                        style: context.textTheme.titleMedium.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Builder(
                      builder: (c) {
                        final renderBox =
                            c.findRenderObject() as RenderBox?;
                        final position =
                            renderBox?.localToGlobal(Offset.zero) ??
                                Offset.zero;
                        final isOnBottomHalf =
                            position.dy > Utils.getHeight / 2;
                        return AppRoundedIconButton(
                          assetPath: Assets.icons.chats.more.path,
                          iconSize: 15,
                          onTap: () {
                            final scopeData = ResponsiveScope.maybeOf(c);
                            Widget dialog = ChatMoreDialog(
                              eventId: chat.eventId,
                              hostId: chat.hostId,
                            );
                            if (scopeData != null) {
                              dialog = ResponsiveScope(
                                  data: scopeData, child: dialog);
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
                          if (showReviewCountdown)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .daysLeftToRate(daysRemaining),
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
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  showReviewCountdown ? reviewProgress : 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorSet.specialYellowColor,
                                ),
                              ),
                            ),
                          ),
                          if (scannedCount != null) ...[
                            const Gap(8),
                            Text(
                              AppLocalizations.of(context)!
                                  .scannedList(scannedCount),
                              style: context.textTheme.bodySmallBold
                                  .copyWith(
                                color: ColorSet.chatListTileDateColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton.primary(
                label: isEventCanceled
                    ? AppLocalizations.of(context)!.eventCanceled
                    : AppLocalizations.of(context)!.chat,
                isLoading: widget.isCheckingAccess,
                fullWidth: false,
                backgroundColor: isMuted
                    ? ColorSet.revbg3Color.withValues(alpha: 0.5)
                    : null,
                foregroundColor: isMuted ? Colors.white70 : null,
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

  Widget _buildCategoryIcon() {
    final icon = _detail?.categoryIcon;
    if (icon == null || icon.isEmpty) {
      return const SizedBox(width: 24, height: 24);
    }

    final isEmoji = !icon.contains('/') && !icon.contains('.');
    if (isEmoji) {
      return SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 18)),
        ),
      );
    }

    return KumeleAssetWidget(
      assetPath: icon,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
    );
  }
}
