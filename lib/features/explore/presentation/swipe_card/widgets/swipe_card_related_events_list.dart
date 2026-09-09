import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/event_card2.dart';

/// "Other events from {host}" carousel — matches iOS EventDetailView's
/// ZStack(ScrollView + left/right chevron buttons): the list scrolls
/// horizontally on its own, and circular chevron buttons at each edge nudge
/// it by roughly one card width per tap.
class SwipeCardRelatedEventsList extends StatefulWidget {
  const SwipeCardRelatedEventsList({
    super.key,
    required this.events,
    this.onEventTap,
  });

  final List<ExploreEventItem> events;
  final ValueChanged<ExploreEventItem>? onEventTap;

  @override
  State<SwipeCardRelatedEventsList> createState() =>
      _SwipeCardRelatedEventsListState();
}

class _SwipeCardRelatedEventsListState
    extends State<SwipeCardRelatedEventsList> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scroll(BuildContext context, double direction) {
    if (!_controller.hasClients) return;
    final responsive = context.responsive;
    final step = responsive.w(240) + responsive.w(10);
    final next = (_controller.offset + direction * step)
        .clamp(0.0, _controller.position.maxScrollExtent);
    _controller.animateTo(
      next,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);

    return SizedBox(
      height: layout.relatedEventsListHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: widget.events.length,
            separatorBuilder: (_, __) => Gap(responsive.w(10)),
            itemBuilder: (context, index) {
              final event = widget.events[index];
              return GestureDetector(
                onTap: widget.onEventTap != null
                    ? () => widget.onEventTap!(event)
                    : null,
                child: EventCard2(
                  title: event.title,
                  imagePath: event.imagePath,
                  category: event.category ?? '',
                  time: event.time,
                  price: event.price,
                  guests: event.guests,
                  startTime: event.startTime,
                  bgColor: ColorSet.hostTileColor,
                ),
              );
            },
          ),
          if (widget.events.length > 1) ...[
            Positioned(
              left: 0,
              child: _ChevronButton(
                icon: Icons.chevron_left,
                onTap: () => _scroll(context, -1),
              ),
            ),
            Positioned(
              right: 0,
              child: _ChevronButton(
                icon: Icons.chevron_right,
                onTap: () => _scroll(context, 1),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final size = responsive.w(34);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF6B6B6B),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: responsive.w(24),
              offset: Offset(0, responsive.h(3)),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: responsive.w(18)),
      ),
    );
  }
}
