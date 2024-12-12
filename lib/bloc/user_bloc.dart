import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/home_page/notification_helper.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Box<User> userBox;
  final NotificationService notificationService;

  UserBloc({required this.userBox, required this.notificationService})
      : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<SaveUserEvent>(_onSaveUser);
    on<EditUser>(_onEditUser);
    on<DeleteUser>(_onDeleteUser);
    on<SearchUsersEvent>(_onSearchUsers);
    on<SortUsersEvent>(_onSortUsers);
    on<ShowInfoDialogEvent>(_onShowInfoDialog);
    on<HideInfoDialogEvent>(_onHideInfoDialog);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) {
    try {
      final users = userBox.values.toList();

      // Сортировка по умолчанию: сначала новый сотрудник
      users.sort((a, b) {
        final DateFormat inputFormat = DateFormat('dd.MM.yyyy');
        DateTime deviceDateA = DateTime(1900);
        DateTime deviceDateB = DateTime(1900);

        try {
          if (a.deviceDate.isNotEmpty) {
            deviceDateA = inputFormat.parse(a.deviceDate);
          }
          if (b.deviceDate.isNotEmpty) {
            deviceDateB = inputFormat.parse(b.deviceDate);
          }
        } catch (_) {}

        return deviceDateB.compareTo(deviceDateA);
      });

      emit(UsersLoaded(users, dialogIsOpen: false));
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

      // Загружаем пользователей с сортировкой по умолчанию
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Не удалось сохранить пользователя'));
    }
  }

  Future<void> _onEditUser(EditUser event, Emitter<UserState> emit) async {
    try {
      final user = event.user;

      // Сохраняем изменения пользователя
      await user.save();

      // Загружаем пользователей с сортировкой по умолчанию
      add(LoadUsers());
    } catch (e) {
      emit(UserError('Не удалось обновить данные пользователя'));
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
    emit(UsersLoaded(users, dialogIsOpen: false));
  }

  void _onSortUsers(SortUsersEvent event, Emitter<UserState> emit) {
    final DateFormat inputFormat = DateFormat('dd.MM.yyyy');
    final users = userBox.values.toList();

    bool _isValidDate(String date) {
      try {
        inputFormat.parse(date);
        return true;
      } catch (_) {
        return false;
      }
    }

    users.sort((a, b) {
      DateTime deviceDateA = DateTime(1900); // Дата по умолчанию
      DateTime deviceDateB = DateTime(1900);
      DateTime medicalDateA = DateTime(1900);
      DateTime medicalDateB = DateTime(1900);

      // Парсим даты устройства
      if (_isValidDate(a.deviceDate)) {
        deviceDateA = inputFormat.parse(a.deviceDate);
      }
      if (_isValidDate(b.deviceDate)) {
        deviceDateB = inputFormat.parse(b.deviceDate);
      }

      // Парсим даты медкнижки
      if (_isValidDate(a.medicalBook)) {
        medicalDateA = inputFormat.parse(a.medicalBook);
      }
      if (_isValidDate(b.medicalBook)) {
        medicalDateB = inputFormat.parse(b.medicalBook);
      }

      // Сортировка по выбранному фильтру
      switch (event.filterOption) {
        case 1: // Сначала новый сотрудник
          return deviceDateB.compareTo(deviceDateA);
        case 2: // Сначала старый сотрудник
          return deviceDateA.compareTo(deviceDateB);
        case 3: // Сначала новая книжка
          return medicalDateB.compareTo(medicalDateA);
        case 4: // Сначала старая книжка
          return medicalDateA.compareTo(medicalDateB);
        default:
          emit(UserError('Неизвестный параметр сортировки.'));
          return 0;
      }
    });

    emit(UsersLoaded(users, dialogIsOpen: false));
  }

  void _onShowInfoDialog(ShowInfoDialogEvent event, Emitter<UserState> emit) {
    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(dialogIsOpen: true));
    }
  }

  void _onHideInfoDialog(HideInfoDialogEvent event, Emitter<UserState> emit) {
    if (state is UsersLoaded) {
      emit((state as UsersLoaded).copyWith(dialogIsOpen: false));
    }
  }
}
