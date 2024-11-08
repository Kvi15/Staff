import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для работы с SystemChrome
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/bloc/user_bloc.dart';
import 'package:flutter_staff/bloc/user_event.dart';
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

  // Запускаем приложение и передаем userBox и notificationService в MyApp
  runApp(MyApp(userBox: userBox, notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final Box<User> userBox;
  final NotificationService notificationService;

  const MyApp(
      {super.key, required this.userBox, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    // Здесь изменим стиль статус-бара для всего приложения
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Прозрачный статус-бар
      statusBarIconBrightness: Brightness.dark, // Чёрные значки статус-бара
      statusBarBrightness: Brightness.light, // Яркость для iOS
    ));

    return BlocProvider(
      create: (context) {
        final userBloc = UserBloc(
            userBox: userBox, notificationService: notificationService);
        userBloc.add(LoadUsers()); // Добавляем событие загрузки пользователей
        return userBloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // Прозрачный AppBar
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark, // Тёмные иконки
          ),
        ),
        home: AddingAPerson(userBox: userBox),
      ),
    );
  }
}
