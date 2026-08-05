import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/shared/widgets/app_refresh_indicator.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/skeleton_list_item.dart';
import 'package:kuemele/features/chat/models/chat_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/presentation/bloc/chat_room_bloc.dart';
import 'package:kuemele/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:kuemele/navigation/app_routes.dart';

class ChatPage extends StatefulWidget implements BasePage {
  final bool? isHome;
  const ChatPage({super.key, this.isHome});

  @override
  State<ChatPage> createState() => _ChatPageState();

  @override
  String get screenName => 'ChatPage';
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatRoomBloc>().add(LoadChatRooms());
  }

  Future<void> _onRefresh() async {
    context.read<ChatRoomBloc>().add(LoadChatRooms());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatRoomBloc, ChatRoomState>(
      listenWhen: (_, current) =>
          current is ChatAccessGranted || current is ChatAccessDenied,
      listener: (context, state) {
        if (state is ChatAccessGranted) {
          InjectionHelper.snackBar.showSuccess(AppStrings.joinChatSuccess);
          context.push(AppRoutes.chatRoom, extra: state.chat);
        } else if (state is ChatAccessDenied) {
          InjectionHelper.snackBar.showError(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                const MobileHeader(label: AppStrings.chat),
                const Gap(22),
                Expanded(
                  child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
                    buildWhen: (_, current) =>
                        current is ChatRoomLoading ||
                        current is ChatRoomInitial ||
                        current is ChatRoomLoaded ||
                        current is ChatRoomError,
                    builder: (context, state) {
                      if (state is ChatRoomError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state is ChatRoomLoaded) {
                        return _buildRooms(
                          state.chatRooms,
                          checkingEventId: state.checkingEventId,
                        );
                      }

                      return SkeletonListItem(
                        child: _buildRooms(dummyChatRooms),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRooms(
    List<ChatRoomEntity> chatRooms, {
    String? checkingEventId,
  }) {
    if (chatRooms.isEmpty) {
      return AppCleanRefresh(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                title: AppStrings.noChats,
                description: AppStrings.noChatsDescription,
                icon: KumeleAssetWidget(
                  assetPath: Assets.icons.chat.path,
                  width: 64,
                  height: 64,
                  color: ColorSet.subTextColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AppCleanRefresh(
      onRefresh: _onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: chatRooms.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, i) => ChatListItem(
          chat: chatRooms[i],
          index: i,
          isCheckingAccess: checkingEventId == chatRooms[i].eventId,
        ),
      ),
    );
  }
}
