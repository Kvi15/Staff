import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class DayIndicator extends StatelessWidget {
  final String startDateString;
  final NotificationService _notificationService =
      NotificationService(); // Создайте экземпляр сервиса

  DayIndicator({super.key, required this.startDateString});

  @override
  Widget build(BuildContext context) {
    DateTime startDate;
    try {
      startDate = DateFormat('dd.MM.yyyy').parse(startDateString);
    } catch (e) {
      return const Text('Неверный формат даты устройства');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildDayIndicator(context, startDate),
        ],
      ),
    );
  }

  Widget _buildDayIndicator(BuildContext context, DateTime startDate) {
    int daysPassed = DateTime.now().difference(startDate).inDays;

    // Проверка на количество дней
    if (daysPassed == 12) {
      _notificationService.showDay12Notification(); // Вызов функции уведомления
    } else if (daysPassed == 14) {
      _notificationService.showDay14Notification();
    } else if (daysPassed == 28) {
      _notificationService.showDay28Notification();
    } else if (daysPassed == 30) {
      _notificationService.showDay30Notification();
    } else if (daysPassed == 58) {
      _notificationService.showDay58Notification();
    } else if (daysPassed == 60) {
      _notificationService.showDay60Notification();
    }

    // Если прошло больше 60 дней, уведомления не отправляются
    if (daysPassed > 60) {
      // Если нужно, можно добавить код для предотвращения отправки уведомлений
      return CustomPaint(
        size: const Size(double.infinity, 50),
        painter: DayIndicatorPainter(daysPassed: daysPassed, exceeded: true),
      );
    }

    return CustomPaint(
      size: const Size(double.infinity, 50),
      painter: DayIndicatorPainter(daysPassed: daysPassed),
    );
  }
}

class DayIndicatorPainter extends CustomPainter {
  final int daysPassed;
  final int totalDays = 60; // Общее количество дней для заполнения
  final bool exceeded;

  DayIndicatorPainter({required this.daysPassed, this.exceeded = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    double startX = 0;
    double endX = size.width;
    double lineY = size.height / 2;

    // Доля пройденных дней
    double passedFraction = (daysPassed / totalDays).clamp(0.0, 1.0);

    // Нарисовать синюю часть
    Paint passedPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 34, 255)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(startX, lineY), Offset(passedFraction * endX, lineY),
        passedPaint);

    // Нарисовать серую часть
    canvas.drawLine(
        Offset(passedFraction * endX, lineY), Offset(endX, lineY), linePaint);

    // Нарисовать круги для отметок дней
    double circleRadius = 5;
    List<int> dayMarks = [14, 30, 60];
    for (int i = 0; i < dayMarks.length; i++) {
      double x = (dayMarks[i] / totalDays) * size.width;
      Paint circlePaint = Paint()
        ..color = (daysPassed >= dayMarks[i])
            ? const Color.fromARGB(255, 0, 34, 255)
            : Colors.grey;
      canvas.drawCircle(Offset(x, lineY), circleRadius, circlePaint);

      // Добавить текст под кругами
      TextSpan span = TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        text: '${dayMarks[i]} дней',
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );

      tp.layout();

      tp.paint(canvas, Offset(x - (tp.width / 2), lineY + 10));
    }

    // Нарисовать вертикальную черту в начале линии
    Paint verticalLinePaint = Paint()
      ..color = const Color.fromARGB(255, 0, 34, 255)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(startX, lineY - 5), Offset(startX, lineY + 5),
        verticalLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
