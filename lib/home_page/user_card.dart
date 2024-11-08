import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/day_Indicator.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:flutter_staff/home_page/confirm_delete_dialog.dart'; // Импортируем новый диалог

class UserCard extends StatelessWidget {
  final User user;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  String get _imagePath => user.imagePath?.isNotEmpty == true
      ? user.imagePath!
      : 'assets/icons/icon_S.png';

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
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
        color: Colors.white,
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
                    _buildImage(),
                    const SizedBox(width: 10),
                    Expanded(child: _buildUserInfo()),
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
              onPressed: () async {
                await onEdit();
              },
              icon: const Icon(Icons.more_vert, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 7,
            right: 5,
            child: IconButton(
              onPressed: () => showConfirmDeleteDialog(context, user),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 130,
      width: 130,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _imagePath.startsWith('assets/')
            ? Image.asset(_imagePath, fit: BoxFit.cover)
            : Image.file(
                File(_imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/icons/icon_S.png',
                      fit: BoxFit.cover);
                },
              ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(user.surname),
        _buildText(user.name),
        _buildText(user.patronymic),
        _buildText(user.number),
        Row(
          children: [
            const Icon(Icons.directions_walk, size: 15),
            const SizedBox(width: 4),
            Text(user.deviceDate, style: const TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.import_contacts, size: 15),
            const SizedBox(width: 4),
            Text(user.medicalBook, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
