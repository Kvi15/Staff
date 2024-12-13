import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

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
    tz.setLocalLocation(tz.getLocation(
        'Europe/Moscow')); // Устанавливаем временную зону по умолчанию

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/my_custom_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
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

  // Метод для планирования уведомлений с учетом временной зоны
  Future<void> scheduleNotification(DateTime scheduledDate, User user,
      String message, int notificationId) async {
    // Планируем уведомление на 8:00 по времени устройства
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
      DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day,
          8), // Время уведомления (8:00)
      tz.local, // Локальная временная зона
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

      // Для отладки выводим дату и время уведомления с учетом временной зоны
      debugPrint(
          'Запланировано уведомление с ID $notificationId на ${DateFormat('dd.MM.yyyy HH:mm').format(scheduledTime)}');
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
