import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_staff/home_page/adding_a_person.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Hive
  await Hive.initFlutter();

  // Регистрируем адаптер User
  Hive.registerAdapter(UserAdapter());

  // Открываем коробку (Box) пользователей
  var userBox = await Hive.openBox<User>('users');

  // Инициализация NotificationService
  final notificationService = NotificationService();
  await notificationService.init();

  // Инициализация локализации для работы с датами на русском
  await initializeDateFormatting('ru', null);

  // Запускаем приложение и передаем userBox в MyApp
  runApp(MyApp(userBox: userBox));
}

class MyApp extends StatelessWidget {
  final Box<User> userBox;

  const MyApp({super.key, required this.userBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddingAPerson(userBox: userBox),
    );
  }
}
