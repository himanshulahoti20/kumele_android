import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/chat/models/chat_config.dart';
import 'package:kuemele/features/profile/presentation/guideline/guideline_config.dart';
import 'package:kuemele/features/profile/presentation/guideline/widgets/guideline_chat_avatar.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/services/api_service/chatbot/chatbot_repo.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/kumele_rich_text.dart';

class GuidelineKnowledgeBase extends StatefulWidget {
  const GuidelineKnowledgeBase({super.key});

  @override
  State<GuidelineKnowledgeBase> createState() => _GuidelineKnowledgeBaseState();
}

class _GuidelineKnowledgeBaseState extends State<GuidelineKnowledgeBase> {
  final _messageController = TextEditingController();
  late final List<ChatMessage> _messages = [
    _message(
      from: GuidelineConfig.aiAssistantName,
      msg: 'How can I help you with Kumele?',
      itsMe: false,
    ),
  ];
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chats = _messages.groupListsBy((chat) => chat.date);

    return Column(
      children: [
        Expanded(child: _ChatList(chats: chats)),
        _ChatInput(
          controller: _messageController,
          isSending: _isSending,
          onSend: _sendMessage,
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    final query = _messageController.text.trim();
    if (query.isEmpty || _isSending) return;

    setState(() {
      _messages.add(
        _message(
          from: _currentUserName,
          msg: query,
          itsMe: true,
          profile: InjectionHelper.profileCubit.userData?.profilePicture ?? '',
        ),
      );
      _messageController.clear();
      _isSending = true;
    });

    try {
      final userId = InjectionHelper.profileCubit.userData?.id ?? 'guest';
      final answer = await ChatbotRepo.ask(userId: userId, query: query);
      if (!mounted) return;
      setState(() {
        _messages.add(
          _message(
            from: GuidelineConfig.aiAssistantName,
            msg: answer,
            itsMe: false,
          ),
        );
        _isSending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _message(
            from: GuidelineConfig.aiAssistantName,
            msg: 'I could not reach the knowledge base. Please try again.',
            itsMe: false,
          ),
        );
        _isSending = false;
      });
    }
  }

  String get _currentUserName {
    final name = InjectionHelper.profileCubit.userData?.fullname?.trim();
    return name?.isNotEmpty == true ? name! : 'You';
  }

  ChatMessage _message({
    required String from,
    required String msg,
    required bool itsMe,
    String profile = '',
  }) {
    final now = DateTime.now();
    return ChatMessage(
      from: from,
      date: DateFormat('MMM d').format(now),
      time: DateFormat('h:mm a').format(now),
      msg: msg,
      itsME: itsMe,
      profile: profile,
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({required this.chats});

  final Map<String, List<ChatMessage>> chats;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: chats.entries
          .map(
            (entry) => SliverStickyHeader.builder(
              builder: (context, state) => _DateHeader(
                label: entry.key,
                isPinned: state.isPinned,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: entry.value.length,
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _ChatTile(chat: entry.value[index]),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.label, required this.isPinned});

  final String label;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: isPinned ? 1 : 0.7,
        child: Container(
          width: GuidelineConfig.dateHeaderWidth,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: ShapeDecoration(
            color: ColorSet.chatTileColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19),
            ),
          ),
          child: Text(
            label,
            style: context.textTheme.titleSmall.copyWith(
              color: ColorSet.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});

  final ChatMessage chat;

  @override
  Widget build(BuildContext context) {
    final isMe = chat.itsME;
    final tileColor =
        isMe ? ColorSet.chatTileColor : ColorSet.specialYellowColor;
    final mention = chat.tags?.map((tag) => tag.name).join(', ') ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.biggest.width;
        final widthFactor =
            Utils.isPortrait ? (FormFactor.isTablet ? 0.7 : 0.9) : 0.55;

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: SizedBox(
            width: maxWidth * widthFactor,
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuidelineChatAvatar(chat: chat),
                    const Gap(8),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(size(15)),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: isMe
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(size(20)),
                                  topRight: Radius.circular(size(20)),
                                  bottomLeft: Radius.circular(size(20)),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(size(20)),
                                  topRight: Radius.circular(size(20)),
                                  bottomRight: Radius.circular(size(20)),
                                ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.from,
                              style: context.textTheme.bodyLargeBold.copyWith(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            KumeleTextLink(
                              leading: mention,
                              trailing:
                                  mention.isEmpty ? chat.msg : ' ${chat.msg}',
                              leadingStyle:
                                  context.textTheme.bodyLarge.copyWith(
                                color: ColorSet.specialBlueColor,
                                fontWeight: FontWeight.bold,
                              ),
                              trailingStyle:
                                  context.textTheme.bodyLarge.copyWith(
                                color: ColorSet.textColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                AppRoundedIconButton(
                  assetPath: IconSet.jsonSpeechBubble,
                  iconSize: GuidelineConfig.chatBubbleIconSize,
                  padding: 0,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: ColorSet.bgColor,
        borderRadius: BorderRadius.circular(size(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: KumeleTextField(
              controller: controller,
              hintText: GuidelineConfig.chatInputHint,
              filled: false,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(
                horizontal: size(15),
                vertical: size(10),
              ),
            ),
          ),
          AppRoundedIconButton(
            assetPath: IconSet.addIcon,
            iconSize: GuidelineConfig.chatActionIconSize,
            padding: 8,
            backgroundColor: Colors.transparent,
          ),
          AppRoundedIconButton(
            assetPath: IconSet.sendIcon,
            onTap: onSend,
            iconSize: GuidelineConfig.chatActionIconSize,
            padding: 8,
            backgroundColor: Colors.transparent,
            isLoading: isSending,
          ),
          Gap(size(8)),
        ],
      ),
    );
  }
}
