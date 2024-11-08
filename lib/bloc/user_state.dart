// bloc/user_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_staff/home_page/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserDeleted extends UserState {}

class UserDeleteError extends UserState {
  final String message;
  const UserDeleteError(this.message);
}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class ImagePicked extends UserState {
  final String imagePath;

  const ImagePicked(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
