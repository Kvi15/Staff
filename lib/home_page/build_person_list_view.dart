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
    // Отменяем уведомления перед удалением пользователя
    final notificationService = NotificationService();

    try {
      await notificationService
          .cancelNotification(user.key); // отменяем уведомление
      await userBox.delete(user.key); // удаляем пользователя
      setState(() {
        widget.users.remove(user);
      });
    } catch (e) {
      // Обработка ошибок, если они возникли
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении пользователя: $e')),
      );
    }
  }

  Future<void> _editUser(User user) async {
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
