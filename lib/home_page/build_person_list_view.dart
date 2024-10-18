import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/user_card.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:flutter_staff/home_page/change_person_list.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BuildPersonListView extends StatefulWidget {
  final double scrollOffset;
  final List<User> users;

  const BuildPersonListView({
    super.key,
    this.scrollOffset = 0.0,
    required this.users,
  });

  @override
  State<BuildPersonListView> createState() => _BuildPersonListViewState();
}

class _BuildPersonListViewState extends State<BuildPersonListView> {
  late Box<User> userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('users');
  }

  Future<void> _deleteUser(User user) async {
    final notificationService = NotificationService();

    try {
      // Отмена уведомлений
      for (int id in user.notificationIds) {
        await notificationService.cancelNotification(id);
      }

      await userBox.delete(user.key); // Удаление пользователя

      if (mounted) {
        setState(() {
          widget.users.remove(user);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пользователь успешно удален.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении пользователя: $e')),
        );
      }
    }
  }

  Future<void> _editUser(User user) async {
    // Проверяем, что виджет все еще монтирован перед вызовом диалога
    if (!mounted) return;

    showChangePersonListDialog(context, user, _refreshUsers);
  }

  Future<void> _refreshUsers() async {
    setState(() {
      widget.users.sort((a, b) => a.surname.compareTo(b.surname));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final user = widget.users[index];
          return UserCard(
            user: user,
            onEdit: () => _editUser(user),
            onDelete: () => _deleteUser(user),
          );
        },
        childCount: widget.users.length,
      ),
    );
  }
}
