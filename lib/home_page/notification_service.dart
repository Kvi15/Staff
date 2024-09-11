import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Инициализация Timezone
    tz.initializeTimeZones();

    // Вместо явного указания имени временной зоны, используйте локальную зону
    tz.setLocalLocation(tz.local);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> scheduleDailyNotification(
      DateTime selectedDate, User user) async {
    // Используем локальное время, чтобы избежать сдвига на UTC
    final tz.TZDateTime scheduledTime = tz.TZDateTime.local(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      8, // Час, когда должно быть запланировано уведомление (8:00 утра)
      0, // Минута
    );

    // Выводим временную зону для отладки
    debugPrint('Local timezone: ${tz.local}');

    try {
      await _notificationsPlugin.zonedSchedule(
        user.key as int, // Используем user.key как уникальный идентификатор
        "RoStaff",
        "Приближается день ТЕТ-А-ТЕТ с ${user.surname} ${user.name} ${user.patronymic}",
        scheduledTime,
        _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification scheduled successfully for $scheduledTime');
    } catch (e) {
      debugPrint('Error scheduling notifications: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
