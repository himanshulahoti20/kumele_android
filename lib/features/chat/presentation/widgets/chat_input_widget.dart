import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/presentation/bloc/chat_room_bloc.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({super.key});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final state = context.read<ChatRoomBloc>().state;
    if (state is! ChatMessagesLoaded) return;

    final user = InjectionHelper.profileCubit.userData;
    final firstName = user?.firstName?.trim();
    _messageController.clear();
    context.read<ChatRoomBloc>().add(
          SendChatMessage(
            eventId: state.eventId,
            content: content,
            userId: user?.id ?? '',
            userDisplayName: firstName?.isNotEmpty == true
                ? firstName!
                : AppLocalizations.of(context)!.unknownUser,
            userAvatar: user?.profilePicture ?? '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomBloc, ChatRoomState>(
      buildWhen: (previous, current) =>
          (current is ChatMessagesLoaded) != (previous is ChatMessagesLoaded),
      builder: (context, state) {
        final canSend = state is ChatMessagesLoaded;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: KumeleTextField(
            controller: _messageController,
            hintText: AppLocalizations.of(context)!.typeAMessage,
            fillColor: ColorSet.bgColor,
            enabled: canSend,
            textInputAction: TextInputAction.send,
            onSubmitted: canSend ? (_) => _submit() : null,
            suffixIcon: GestureDetector(
              onTap: canSend ? _submit : null,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: Opacity(
                  opacity: canSend ? 1 : 0.4,
                  child: KumeleAssetWidget(
                    assetPath: Assets.icons.chats.sendMessage.path,
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
