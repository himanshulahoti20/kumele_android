import 'package:kuemele/features/explore/domain/entities/explore_event.dart';

class ExploreEventsPage {
  const ExploreEventsPage({
    required this.events,
    required this.limit,
    this.cursor,
    this.hasNext = false,
  });

  final List<ExploreEvent> events;
  final int limit;
  final String? cursor;
  final bool hasNext;
}
