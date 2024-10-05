import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';

class NotificationHelper {
  static void scheduleNotificationsForUser(User user) {
    final NotificationService notificationService = NotificationService();
    final dateFormat = DateFormat('dd.MM.yyyy');

    if (user.deviceDate.isNotEmpty) {
      try {
        DateTime startDate;
        try {
          startDate = dateFormat.parse(user.deviceDate);
          debugPrint("Дата устройства успешно преобразована: $startDate");
        } catch (e) {
          debugPrint("Ошибка при преобразовании даты: $e");
          return; // Прекращаем выполнение функции, если дата неверна
        }

        String fullName = "${user.surname} ${user.name} ${user.patronymic}";

        List<Map<String, dynamic>> notifications = [
          {"days": 12, "message": "Через 2 дня ТЕТ-А-ТЕТ c $fullName"},
          {"days": 14, "message": "Сегодня день ТЕТ-А-ТЕТ c $fullName"},
          {"days": 28, "message": "Через 2 дня ТЕТ-А-ТЕТ c $fullName"},
          {"days": 30, "message": "Сегодня день ТЕТ-А-ТЕТ c $fullName"},
          {"days": 58, "message": "Через 2 дня ТЕТ-А-ТЕТ c $fullName"},
          {"days": 60, "message": "Сегодня день ТЕТ-А-ТЕТ c $fullName"}
        ];

        for (var notification in notifications) {
          DateTime scheduledDate =
              startDate.add(Duration(days: notification["days"]));
          notificationService.scheduleDailyNotification(
              scheduledDate, user, notification["message"]);

          // Вывод в консоль запланированной даты и сообщения
          debugPrint(
              "Запланировано уведомление на ${dateFormat.format(scheduledDate)}: ${notification["message"]}");
        }
      } catch (e) {
        debugPrint('Error scheduling notifications: $e');
      }
    }
  }
}
