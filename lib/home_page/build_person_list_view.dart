import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/change_person_list.dart';
import 'package:flutter_staff/home_page/day_Indicator.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BuildPersonListView extends StatefulWidget {
  final double scrollOffset;

  const BuildPersonListView({
    super.key,
    this.scrollOffset = 0.0,
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

  void _deleteUser(User user) {
    userBox.delete(user.key);
  }

  void _editUser(User user) {
    showChangePersonListDialog(context, user);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userBox.listenable(),
      builder: (context, Box<User> box, _) {
        List<User> users = box.values.toList().cast<User>();
        users.sort((a, b) =>
            b.key.compareTo(a.key)); // Сортировка по ключу в обратном порядке

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final user = users[index];
              return Center(
                child: Container(
                  height: 200,
                  margin: EdgeInsets.fromLTRB(
                    40,
                    index == 0
                        ? MediaQuery.of(context).size.height *
                            widget.scrollOffset
                        : 0,
                    40,
                    index == users.length - 1 ? 80 : 20,
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
                                  child: user.imagePath != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            File(user.imagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/icons/lgv9s1kz-removebg-preview.png',
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
                                        Text(user.deviceDate)
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
                              child: DayIndicator(
                                  startDateString: user.deviceDate),
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
                            _deleteUser(user);
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
            childCount: users.length,
          ),
        );
      },
    );
  }
}
