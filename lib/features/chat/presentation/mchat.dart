import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/features/chat/presentation/chat_page.dart';
import 'package:kuemele/features/chat/presentation/chat_room.dart';
import 'package:kuemele/shared/utils/utils.dart';

/// Tablet Chat tab. Shows only the chat list until a chat is opened; once
/// one is selected, splits into list + the live ChatRoom for that chat.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatRoomEntity? _selectedChat;

  @override
  Widget build(BuildContext context) {
    final selectedChat = _selectedChat;

    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: selectedChat == null
            ? ChatPage(onChatOpened: _onChatOpened)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Utils.getWidth * 0.3,
                    child: ChatPage(onChatOpened: _onChatOpened),
                  ),
                  const Gap(20),
                  Expanded(
                    child: ChatRoom(
                      key: ValueKey(selectedChat.id),
                      chat: selectedChat,
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
