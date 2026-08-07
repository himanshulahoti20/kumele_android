import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';
import 'package:kuemele/features/chat/presentation/bloc/chat_room_bloc.dart';
import 'package:kuemele/features/chat/presentation/cubit/chat_room_header_cubit.dart';
import 'package:kuemele/features/chat/presentation/widgets/chat_bubble_widget.dart';
import 'package:kuemele/features/chat/presentation/widgets/chat_input_widget.dart';
import 'package:kuemele/features/chat/presentation/widgets/chat_room_app_bar.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ChatRoom extends StatefulWidget implements BasePage {
  final ChatRoomEntity? chat;
  const ChatRoom({super.key, this.chat});

  @override
  State<ChatRoom> createState() => _ChatRoomState();

  @override
  String get screenName => 'ChatRoom';
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController _scrollController = ScrollController();
  String? _lastErrorMessage;
  late final ChatRoomHeaderCubit _headerCubit;
  late final ChatRoomBloc _chatRoomBloc;
  bool _didLeaveRoom = false;

  @override
  void initState() {
    super.initState();
    _chatRoomBloc = context.read<ChatRoomBloc>();
    _headerCubit = ChatRoomHeaderCubit(
      repository: getIt<ExploreRepository>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _enterChatRoom();
      _loadHeader();
    });
  }

  @override
  void dispose() {
    _leaveChatRoom();
    _scrollController.dispose();
    _headerCubit.close();
    super.dispose();
  }

  void _leaveChatRoom() {
    if (_didLeaveRoom) return;
    _didLeaveRoom = true;
    _chatRoomBloc.add(LeaveChatRoom(eventId: widget.chat?.eventId));
  }

  void _loadHeader() {
    final eventId = widget.chat?.eventId;
    if (eventId == null || eventId.isEmpty) return;
    _headerCubit.load(eventId);
  }

  void _enterChatRoom({bool force = false}) {
    if (!mounted) return;
    final eventId = widget.chat?.eventId;
    if (eventId == null || eventId.isEmpty) return;

    final current = _chatRoomBloc.state;
    if (!force && current is ChatMessagesLoaded && current.eventId == eventId) {
      _chatRoomBloc.add(ConnectChatSocket(eventId: eventId));
      return;
    }

    _chatRoomBloc.add(EnterChatRoom(eventId: eventId));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _headerCubit,
      child: PopScope(
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) return;
          _leaveChatRoom();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChatRoomBloc, ChatRoomState>(
              listenWhen: (previous, current) =>
                  (current is ChatMessagesLoaded &&
                      previous is ChatRoomEntering &&
                      current.roomId != null) ||
                  current is ChatMessageSendFailed ||
                  current is ChatMessagesError,
              listener: (context, state) {
                if (state is ChatMessagesLoaded) {
                  _lastErrorMessage = null;
                  InjectionHelper.snackBar.showSuccess(
                      AppLocalizations.of(context)!.joinChatSuccess);
                } else if (state is ChatMessageSendFailed) {
                  InjectionHelper.snackBar.showError(state.message);
                } else if (state is ChatMessagesError) {
                  _lastErrorMessage = state.message;
                }
              },
            ),
            BlocListener<ChatRoomBloc, ChatRoomState>(
              listenWhen: (previous, current) {
                if (current is! ChatMessagesLoaded) return false;
                if (previous is! ChatMessagesLoaded) {
                  return current.messages.isNotEmpty;
                }
                return current.messages.length > previous.messages.length;
              },
              listener: (context, state) => _scrollToBottom(),
            ),
          ],
          child: Scaffold(
            backgroundColor: ColorSet.bgColor,
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size(8)),
                color: ColorSet.bg3Color,
              ),
              child: Column(
                children: [
                  ChatRoomAppBar(chat: widget.chat),
                  AppDivider.horizontal(),
                  const Gap(20),
                  Expanded(
                    child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
                      buildWhen: (previous, current) =>
                          current is ChatRoomEntering ||
                          current is ChatMessagesLoading ||
                          current is ChatMessagesLoaded ||
                          current is ChatMessagesError,
                      builder: (context, state) {
                        final isRetrying = _lastErrorMessage != null &&
                            (state is ChatRoomEntering ||
                                state is ChatMessagesLoading);

                        if (state is ChatMessagesError || isRetrying) {
                          return _buildError(
                            state is ChatMessagesError
                                ? state.message
                                : _lastErrorMessage!,
                            isLoading: isRetrying,
                          );
                        }

                        if (state is ChatRoomEntering ||
                            state is ChatMessagesLoading) {
                          return const Center(
                            child: AppLoadingIndicator.chasingDots(),
                          );
                        }

                        if (state is ChatMessagesLoaded) {
                          final messages = state.messages;
                          if (messages.isEmpty) {
                            return AppEmptyState(
                              title: AppLocalizations.of(context)!.noMessages,
                              description: AppLocalizations.of(context)!
                                  .noMessagesDescription,
                              icon: KumeleAssetWidget(
                                assetPath: Assets.icons.chats.chat.path,
                                width: 64.w,
                                height: 64.w,
                                color: ColorSet.subTextColor,
                              ),
                            );
                          }

                          final groupedMessages = groupBy(
                            messages,
                            (ChatRoomMessageEntity m) =>
                                DateFormat('d MMM yyyy').format(m.createdAt),
                          );

                          return _buildListChat(groupedMessages);
                        }

                        return const Center(
                          child: AppLoadingIndicator.chasingDots(),
                        );
                      },
                    ),
                  ),
                  const ChatInputWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message, {required bool isLoading}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            const Gap(16),
            AppButton.primary(
              label: AppLocalizations.of(context)!.retry,
              fullWidth: false,
              isLoading: isLoading,
              onPressed: isLoading ? null : () => _enterChatRoom(force: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListChat(
      Map<String, List<ChatRoomMessageEntity>> finalChatList) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: finalChatList.entries
          .map(
            (chat) => SliverStickyHeader.builder(
              builder: (context, state) {
                return Center(
                  child: Opacity(
                    opacity: state.isPinned ? 1 : 0.7,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorSet.chatTileColor,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Text(
                        chat.key,
                        style: context.textTheme.titleSmall.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: chat.value.length,
                  (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ChatBubbleWidget(chat: chat.value[i]),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
