import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/features/explore/data/mappers/notification_item_mapper.dart';
import 'package:kuemele/features/explore/data/models/notification_model.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';

void main() {
  test('event matched notifications open the event from target reference', () {
    final item = NotificationItemMapper.fromModel(
      const NotificationModel(
        notificationId: 'notification-1',
        type: 'EVENT_MATCHED',
        title: 'Matched',
        message: 'Join now',
        icon: 'icon_event_matched',
        targetReference: {'event_id': 'event-123'},
      ),
    );

    expect(item.type, NotificationType.eventMatched);
    expect(item.actionType, NotificationActionType.eventJoinPreview);
    expect(item.section, NotificationSection.matched);
    expect(item.eventId, 'event-123');
    expect(item.isEventJoined, isFalse);
  });

  test('backend aliases map to existing notification actions', () {
    final rate = NotificationItemMapper.fromModel(
      const NotificationModel(
        notificationId: 'notification-2',
        type: 'rate-event',
        title: 'Rate',
        message: 'Please rate the event',
        icon: 'icon_event_rate',
        targetReference: {'eventId': 'event-456'},
      ),
    );
    final medal = NotificationItemMapper.fromModel(
      const NotificationModel(
        notificationId: 'notification-3',
        type: 'medal_notification',
        title: 'Medal',
        message: 'You earned a medal',
        icon: 'icon_reward',
      ),
    );

    expect(rate.actionType, NotificationActionType.eventRate);
    expect(rate.section, NotificationSection.created);
    expect(medal.type, NotificationType.reward);
    expect(medal.actionType, NotificationActionType.statusUpdateDialog);
  });

  test('category and target media drive section and leading image', () {
    final item = NotificationItemMapper.fromModel(
      const NotificationModel(
        notificationId: 'notification-4',
        type: 'PAYMENT_EXPIRED',
        title: 'Created event',
        message: 'Payment expired',
        icon: 'icon_payment_expired',
        category: 'created_events',
        targetReference: {
          'event': {
            'id': 99,
            'event_image': 'https://example.com/event.jpg',
          },
        },
      ),
    );

    expect(item.section, NotificationSection.created);
    expect(item.eventId, '99');
    expect(item.leadingAssetPath, 'https://example.com/event.jpg');
  });

  test('joined event state accepts backend boolean aliases', () {
    const item = NotificationItem(
      id: 'notification-5',
      title: 'Matched',
      timeLabel: '',
      description: '',
      actionType: NotificationActionType.eventJoinPreview,
      type: NotificationType.eventMatched,
      targetReference: {
        'event': {'is_joined': true}
      },
    );

    expect(item.isEventJoined, isTrue);
  });
}
