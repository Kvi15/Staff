import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';

class NotificationHelper {
  static Future<void> scheduleNotificationsForUser(User user) async {
    final NotificationService notificationService = NotificationService();
    final dateFormat = DateFormat('dd.MM.yyyy');

    if (user.deviceDate.isNotEmpty) {
      try {
        DateTime startDate = dateFormat.parse(user.deviceDate);

        String fullName = "${user.surname} ${user.name} ${user.patronymic}";

        // Список уведомлений для каждого дня
        List<Map<String, dynamic>> notifications = [
          {"days": 12, "message": "Через 2 дня ТЕТ-А-ТЕТ c $fullName"},
          {"days": 14, "message": "Сегодня день ТЕТ-А-ТЕТ c $fullName"},
          {"days": 28, "message": "Через 2 дня ТЕТ-А-ТЕТ c $fullName"},
          {"days": 30, "message": "Сегодня день ТЕТ-А-ТЕТ c $fullName"},
          {"days": 58, "message": "Через 2 дня ТЕТ-А-ТЕТ c $fullName"},
          {"days": 60, "message": "Сегодня день ТЕТ-А-ТЕТ c $fullName"}
        ];

        for (int i = 0; i < notifications.length; i++) {
          var notification = notifications[i];
          DateTime scheduledDate =
              startDate.add(Duration(days: notification["days"]));

          // Генерация уникального идентификатора для каждого уведомления
          int notificationId = user.key.hashCode + i;

          // Планирование уведомления с уникальным идентификатором
          await notificationService.scheduleNotification(
            scheduledDate,
            user,
            notification["message"],
            notificationId,
          );

          // Логирование запланированных уведомлений для отладки
          debugPrint(
              "Запланировано уведомление на ${dateFormat.format(scheduledDate)}: ${notification["message"]} с ID $notificationId");
        }
      } catch (e) {
        debugPrint('Ошибка при планировании уведомлений: $e');
      }
    }
  }
}
