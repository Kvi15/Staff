// user_event.dart

import 'package:flutter_staff/home_page/user.dart';

abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class SaveUserEvent extends UserEvent {
  final String surname;
  final String name;
  final String patronymic;
  final String number;
  final String deviceDate;
  final String medicalBook;
  final String? imagePath;

  SaveUserEvent({
    required this.surname,
    required this.name,
    required this.patronymic,
    required this.number,
    required this.deviceDate,
    required this.medicalBook,
    this.imagePath,
  });
}

class EditUser extends UserEvent {
  final User user;
  EditUser({required this.user});
}

class DeleteUser extends UserEvent {
  final User user;

  DeleteUser(this.user);
}

class SearchUsersEvent extends UserEvent {
  final String query;
  SearchUsersEvent(this.query);
}

class SortUsersEvent extends UserEvent {
  final int filterOption;
  SortUsersEvent(this.filterOption);
}

class PickImage extends UserEvent {}

class ShowInfoDialogEvent extends UserEvent {}

class HideInfoDialogEvent extends UserEvent {}
