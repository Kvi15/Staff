import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class DayIndicator extends StatelessWidget {
  final String startDateString;

  const DayIndicator({super.key, required this.startDateString});

  @override
  Widget build(BuildContext context) {
    DateTime? startDate;
    try {
      startDate = DateFormat('dd.MM.yyyy').parse(startDateString);
    } catch (e) {
      return const Text('Неверный формат даты устройства');
    }

    final daysPassed = DateTime.now().difference(startDate).inDays;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        size: const Size(double.infinity, 50),
        painter: DayIndicatorPainter(daysPassed: daysPassed),
      ),
    );
  }
}

class DayIndicatorPainter extends CustomPainter {
  final int daysPassed;
  final int totalDays = 60;

  DayIndicatorPainter({required this.daysPassed});

  @override
  void paint(Canvas canvas, Size size) {
    final double lineY = size.height / 2;
    final double endX = size.width;
    final double passedFraction = (daysPassed / totalDays).clamp(0.0, 1.0);

    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    final passedPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 34, 255)
      ..strokeWidth = 2;

    // Сначала рисуем серую линию на всю ширину, затем синий индикатор
    canvas.drawLine(Offset(0, lineY), Offset(endX, lineY), linePaint);
    canvas.drawLine(
        Offset(0, lineY), Offset(passedFraction * endX, lineY), passedPaint);

    // Рисуем отметки дней и текст с надписью количества дней
    const List<int> dayMarks = [14, 30, 60];
    const double circleRadius = 5;
    final textStyle = TextStyle(color: Colors.black, fontSize: 12);

    for (final dayMark in dayMarks) {
      final double x = (dayMark / totalDays) * size.width;

      // Краска для кругов
      final circlePaint = Paint()
        ..color = daysPassed >= dayMark ? passedPaint.color : Colors.grey;
      canvas.drawCircle(Offset(x, lineY), circleRadius, circlePaint);

      // Рисуем текст под кругами
      final textSpan = TextSpan(style: textStyle, text: '$dayMark дней');
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      )..layout();

      textPainter.paint(
          canvas, Offset(x - (textPainter.width / 2), lineY + 10));
    }

    // Вертикальная черта в начале линии
    canvas.drawLine(Offset(0, lineY - 5), Offset(0, lineY + 5), passedPaint);
  }

  @override
  bool shouldRepaint(DayIndicatorPainter oldDelegate) {
    return oldDelegate.daysPassed != daysPassed;
  }
}
