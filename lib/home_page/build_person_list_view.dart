import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/change_person_list.dart';
import 'package:flutter_staff/home_page/day_Indicator.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';
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

  void _deleteUser(User user) async {
    // Отменяем уведомления перед удалением пользователя
    final notificationService = NotificationService();
    await notificationService
        .cancelNotification(user.key); // отмени уведомление

    await userBox.delete(user.key); // удаляем пользователя
    setState(() {
      widget.users.remove(user);
      _refreshUsers();
    });
  }

  void _editUser(User user) {
    showChangePersonListDialog(context, user, _refreshUsers);
  }

  void _refreshUsers() {
    setState(() {
      widget.users.sort((a, b) => a.surname.compareTo(b.surname));
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCount = widget.users.length;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final user = widget.users[index];
          final imagePath = user.imagePath?.isNotEmpty == true
              ? user.imagePath!
              : 'assets/icons/icon_S.png';

          return Center(
            child: Container(
              height: 200,
              margin: EdgeInsets.fromLTRB(
                40,
                index == 0
                    ? MediaQuery.of(context).size.height * widget.scrollOffset
                    : 0,
                40,
                index == userCount - 1 ? 80 : 20,
              ),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 3, 3, 3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 130,
                              width: 130,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: imagePath.startsWith('assets/')
                                    ? Image.asset(imagePath, fit: BoxFit.cover)
                                    : Image.file(File(imagePath),
                                        fit: BoxFit.cover, errorBuilder:
                                            (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/icons/icon_S.png');
                                      }),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(user.surname),
                                const SizedBox(height: 3),
                                Text(user.name),
                                const SizedBox(height: 3),
                                Text(user.patronymic),
                                const SizedBox(height: 3),
                                Text(user.number),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.directions_walk,
                                      size: 15,
                                    ),
                                    Text(user.deviceDate),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.import_contacts,
                                      size: 15,
                                    ),
                                    Text(user.medicalBook),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: DayIndicator(startDateString: user.deviceDate),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        _editUser(user);
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 7,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Удалить'),
                              content: const Text(
                                  'Вы точно хотите удалить сотрудника ? '),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Нет'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Да'),
                                  onPressed: () {
                                    _deleteUser(user);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: userCount,
      ),
    );
  }
}
