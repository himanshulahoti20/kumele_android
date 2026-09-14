import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/presentation/chat_page.dart';
import 'package:kuemele/features/chat/presentation/chat_room.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';

/// Tablet Chat tab — a permanent list + conversation split (matches iOS
/// ChatView_iPad's SidebarView + ChatDetailView). Nothing is selected on
/// open — the right pane stays empty until the user taps a chat.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatRoomEntity? _selectedChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChatPanel(
              width: Utils.getWidth * 0.3,
              child: ChatPage(embedded: true, onChatOpened: _onChatOpened),
            ),
            const Gap(20),
            Expanded(
              child: _ChatPanel(
                child: _selectedChat == null
                    ? const _NoChatSelected()
                    : ChatRoom(
                        key: ValueKey(_selectedChat!.id),
                        chat: _selectedChat,
                        showBackButton: false,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChatOpened(ChatRoomEntity chat) {
    setState(() => _selectedChat = chat);
  }
}

/// Shared rounded card chrome for both panels — matches iOS SidebarView's
/// `.background(Color("bgColor").cornerRadius(8))`. iOS's "bgColor" (a card
/// surface) is Android's bg3Color — the two ColorSet names are swapped
/// between the apps.
class _ChatPanel extends StatelessWidget {
  const _ChatPanel({required this.child, this.width});

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}

class _NoChatSelected extends StatelessWidget {
  const _NoChatSelected();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState(
        title: AppLocalizations.of(context)!.noChats,
        description: AppLocalizations.of(context)!.noChatsDescription,
      ),
    );
  }
}
