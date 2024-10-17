import 'package:flutter/material.dart';

Future<void> showConfirmDeleteDialog(
  BuildContext context,
  Future<void> Function() onDelete,
) async {
  // Открытие диалога
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
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Да'),
          ),
        ],
      );
    },
  );

  // Выполнение onDelete только если пользователь подтвердил удаление
  if (shouldDelete == true) {
    await onDelete();
  }
}
