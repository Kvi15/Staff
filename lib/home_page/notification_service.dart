import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staff/home_page/user.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final User _user = User();

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

  Future<void> showDay12Notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'day_12_channel_id',
      'Day 12 Notification',
      channelDescription: 'Notification when the 12th day is reached',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'RoStaff',
      'Приблежается день ТЕТ-А-ТЕТ с ${_user.name} ${_user.surname} ',
      platformChannelSpecifics,
      payload: 'day_12',
    );
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

  Future<void> showDay28Notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'day_28_channel_id',
      'Day 28 Notification',
      channelDescription: 'Notification when the 28th day is reached',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'RoStaff',
      'Приблежается день ТЕТ-А-ТЕТ с 28 ',
      platformChannelSpecifics,
      payload: 'day_28',
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

  Future<void> showDay58Notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'day_58_channel_id',
      'Day 58 Notification',
      channelDescription: 'Notification when the 58th day is reached',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'RoStaff',
      'Приблежается день ТЕТ-А-ТЕТ с 58 ',
      platformChannelSpecifics,
      payload: 'day_58',
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
      payload: 'day_60',
    );
  }
}
