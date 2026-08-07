import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/cubit/event_matched_bloc.dart';
import 'package:kuemele/features/discover/presentation/event_matched/widgets/event_matched_confetti_overlay.dart';
import 'package:kuemele/features/discover/presentation/event_matched/widgets/event_matched_event_header.dart';
import 'package:kuemele/features/discover/presentation/event_matched/widgets/event_matched_go_to_chat_button.dart';
import 'package:kuemele/features/discover/presentation/event_matched/widgets/event_matched_guests_section.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';

class EventMatchedDialogContent extends StatelessWidget {
  const EventMatchedDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventMatchedBloc, EventMatchedState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == EventMatchedStatus.navigating ||
              current.status == EventMatchedStatus.joinChatFailed),
      listener: (context, state) {
        if (state.status == EventMatchedStatus.joinChatFailed) {
          InjectionHelper.snackBar.showError(
            state.errorMessage ?? AppLocalizations.of(context)!.joinChatFailed,
          );
          return;
        }

        Navigator.of(context).pop();
        context.push(AppRoutes.chatList, extra: {'isHome': false});
      },
      builder: (context, state) {
        final responsive = context.responsive;
        final eventData = state.eventData;
        final isJoining = state.status == EventMatchedStatus.joiningChat ||
            state.status == EventMatchedStatus.navigating;

        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.w(24),
                vertical: responsive.h(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EventMatchedEventHeader(
                    heroImagePath: eventData.heroImagePath,
                    categoryIconPath: eventData.categoryIconPath,
                    title: eventData.title,
                  ),
                  EventMatchedGuestsSection(
                    guestCount: eventData.guestCount,
                    attendees: eventData.attendees,
                  ),
                  Gap(responsive.h(20)),
                  EventMatchedGoToChatButton(
                    isLoading: isJoining,
                    onTap: () => context
                        .read<EventMatchedBloc>()
                        .add(const EventMatchedGoToChatTapped()),
                  ),
                ],
              ),
            ),
            EventMatchedConfettiOverlay(
              animationPath: eventData.confettiAnimationPath,
              visible: state.showConfetti,
            ),
          ],
        );
      },
    );
  }
}
