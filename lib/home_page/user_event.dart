import 'package:equatable/equatable.dart';
import 'package:flutter_staff/home_page/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;

  const AddUser(this.user);

  @override
  List<Object?> get props => [user];
}

class RemoveUser extends UserEvent {
  final User user;

  const RemoveUser(this.user);

  @override
  List<Object?> get props => [user];
}
