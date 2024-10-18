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
    tz.setLocalLocation(tz.local);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/my_custom_icon');

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

  Future<void> scheduleNotification(DateTime scheduledDate, User user,
      String message, int notificationId) async {
    // Создаем TZDateTime из scheduledDate и устанавливаем время на 8:00 AM
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
      tz.TZDateTime.now(tz.local).copyWith(
        year: scheduledDate.year,
        month: scheduledDate.month,
        day: scheduledDate.day,
        hour: 8, // Время уведомления (8:00 AM по локальному времени)
        minute: 0,
        second: 0,
        microsecond: 0,
      ),
      tz.local,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        notificationId, // Уникальный идентификатор для каждого уведомления
        "Rostic's Staff", // Заголовок уведомления
        message, // Текст уведомления
        scheduledTime,
        _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint(
          'Запланировано уведомление с ID $notificationId на ${scheduledTime.toIso8601String()}');
    } catch (e) {
      debugPrint('Ошибка создания уведомлений: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('Уведомление с ID $id отменено');
    } catch (e) {
      debugPrint('Ошибка при отмене уведомления: $e');
    }
  }
}
