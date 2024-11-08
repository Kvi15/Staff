import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/bloc/user_bloc.dart';
import 'package:flutter_staff/bloc/user_event.dart';
import 'package:flutter_staff/home_page/user.dart';

Future<void> showConfirmDeleteDialog(BuildContext context, User user) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Удалить'),
        content: const Text('Вы точно хотите удалить сотрудника?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              // Отправляем событие удаления через Bloc
              context.read<UserBloc>().add(DeleteUser(user));
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Да'),
          ),
        ],
      );
    },
  );

  if (shouldDelete == true) {
    context
        .read<UserBloc>()
        .add(LoadUsers()); // Обновляем список после удаления
  }
}
