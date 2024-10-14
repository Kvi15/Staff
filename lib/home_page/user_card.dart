import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/day_Indicator.dart';
import 'package:flutter_staff/home_page/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = user.imagePath?.isNotEmpty == true
        ? user.imagePath!
        : 'assets/icons/icon_S.png';

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: imagePath.startsWith('assets/')
                            ? Image.asset(imagePath, fit: BoxFit.cover)
                            : Image.file(File(imagePath), fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/icons/icon_S.png');
                              }),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            const Icon(Icons.directions_walk, size: 15),
                            Text(user.deviceDate),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.import_contacts, size: 15),
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
              onPressed: onEdit,
              icon: const Icon(Icons.more_vert, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 7,
            right: 5,
            child: IconButton(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить'),
          content: const Text('Вы точно хотите удалить сотрудника?'),
          actions: [
            TextButton(
              child: const Text('Нет'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Да'),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
