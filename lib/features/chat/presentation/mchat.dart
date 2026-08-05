import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/features/chat/presentation/chat_page.dart';
import 'package:kuemele/features/chat/presentation/chat_room.dart';
import 'package:kuemele/shared/utils/utils.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Utils.getWidth * 0.3,
              child: const ChatPage(),
            ),
            Gap(20),
            Expanded(
              child: ChatRoom(),
            ),
          ],
        ),
      ),
    );
  }
}
