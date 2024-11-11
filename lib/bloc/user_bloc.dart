// user_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/home_page/notification_helper.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // Импортируем пакет для работы с датами
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Box<User> userBox;
  final NotificationService notificationService;

  UserBloc({required this.userBox, required this.notificationService})
      : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<SaveUserEvent>(_onSaveUser);
    on<DeleteUser>(_onDeleteUser);
    on<SearchUsersEvent>(_onSearchUsers); // Добавлено событие поиска
    on<SortUsersEvent>(_onSortUsers); // Добавлено событие сортировки
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) {
    try {
      final users = userBox.values.toList();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError('Не удалось загрузить пользователей'));
    }
  }

  Future<void> _onSaveUser(SaveUserEvent event, Emitter<UserState> emit) async {
    try {
      final newUser = User(
        surname: event.surname.isNotEmpty ? event.surname : 'Фамилия',
        name: event.name.isNotEmpty ? event.name : 'Имя',
        patronymic: event.patronymic.isNotEmpty ? event.patronymic : 'Отчество',
        number: event.number.isNotEmpty ? event.number : 'Номер телефона',
        deviceDate:
            event.deviceDate.isNotEmpty ? event.deviceDate : 'Дата устройства',
        medicalBook:
            event.medicalBook.isNotEmpty ? event.medicalBook : 'Медкнижка',
        imagePath: event.imagePath,
      );

      await userBox.add(newUser);
      NotificationHelper.scheduleNotificationsForUser(newUser);
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Не удалось сохранить пользователя'));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      for (int notificationId in event.user.notificationIds) {
        await notificationService.cancelNotification(notificationId);
      }

      await userBox.delete(event.user.key);
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Не удалось удалить пользователя'));
    }
  }

  void _onSearchUsers(SearchUsersEvent event, Emitter<UserState> emit) {
    final query = event.query.toLowerCase();
    final users = userBox.values
        .where((user) =>
            user.surname.toLowerCase().contains(query) ||
            user.name.toLowerCase().contains(query) ||
            user.patronymic.toLowerCase().contains(query) ||
            user.number.toLowerCase().contains(query))
        .toList();
    emit(UsersLoaded(users));
  }

  void _onSortUsers(SortUsersEvent event, Emitter<UserState> emit) {
    final DateFormat inputFormat =
        DateFormat('dd.MM.yyyy'); // Формат даты, как в вашей строке
    final users = userBox.values.toList();

    users.sort((a, b) {
      DateTime deviceDateA, deviceDateB, medicalDateA, medicalDateB;

      try {
        deviceDateA =
            inputFormat.parse(a.deviceDate); // Преобразуем строку в DateTime
        deviceDateB =
            inputFormat.parse(b.deviceDate); // Преобразуем строку в DateTime
        medicalDateA =
            inputFormat.parse(a.medicalBook); // Преобразуем строку в DateTime
        medicalDateB =
            inputFormat.parse(b.medicalBook); // Преобразуем строку в DateTime
      } catch (e) {
        emit(UserError('Ошибка парсинга даты: $e'));
        return 0;
      }

      switch (event.filterOption) {
        case 1:
          return deviceDateB.compareTo(
              deviceDateA); // Сортировка по дате устройства от большего к меньшему
        case 2:
          return deviceDateA.compareTo(
              deviceDateB); // Сортировка по дате устройства от меньшего к большему
        case 3:
          return medicalDateB.compareTo(
              medicalDateA); // Сортировка по дате мед книжки от большего к меньшему
        case 4:
          return medicalDateA.compareTo(
              medicalDateB); // Сортировка по дате мед книжки от меньшего к большему
        default:
          return 0;
      }
    });

    // Обновляем Box с отсортированными пользователями, используя их оригинальные ключи
    for (var user in users) {
      userBox.put(user.key, user); // Используем ключ для сохранения объектов
    }

    emit(UsersLoaded(users)); // Отправляем обновленный список
  }
}
