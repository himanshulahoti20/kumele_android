import 'package:flutter/services.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';

class ClipboardService {
  Future<void> copyEventCode(ExploreEventItem event) async {
    final text = 'Hey! Check out this event on Kumele:\n\n'
        'Event: ${event.title}\n'
        'Event Code: ${event.id}\n'
        'Time: ${event.time}\n'
        'Price: ${event.price}\n'
        'Location: ${event.location}\n\n'
        'Search this code in Kumele app to join!\n'
        'https://kumele.com/';

    await Clipboard.setData(ClipboardData(text: text));
  }
}
