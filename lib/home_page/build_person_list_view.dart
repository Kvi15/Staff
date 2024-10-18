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
      // Отменяем все запланированные уведомления, привязанные к этому пользователю
      for (int notificationId in user.notificationIds) {
        await notificationService.cancelNotification(notificationId);
      }

      // Удаляем пользователя из Hive
      await userBox.delete(user.key); // Удаление пользователя по ключу

      if (mounted) {
        setState(() {
          widget.users.remove(user); // Удаляем пользователя из списка в UI
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении: $e')),
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
