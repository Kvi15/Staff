import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showDay14Notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'day_14_channel_id',
      'Day 14 Notification',
      channelDescription: 'Notification when the 14th day is reached',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'RoStaff',
      'Сегодня день ТЕТ-А-ТЕТ с 14 ',
      platformChannelSpecifics,
      payload: 'day_14',
    );
  }

  Future<void> showDay30Notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'day_30_channel_id',
      'Day 30 Notification',
      channelDescription: 'Notification when the 30th day is reached',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'RoStaff',
      'Сегодня день ТЕТ-А-ТЕТ с 30 ',
      platformChannelSpecifics,
      payload: 'day_30',
    );
  }

  Future<void> showDay60Notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'day_60_channel_id',
      'Day 60 Notification',
      channelDescription: 'Notification when the 60th day is reached',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'RoStaff',
      'Сегодня день ТЕТ-А-ТЕТ с 60',
      platformChannelSpecifics,
      payload: 'day_30',
    );
  }
}
