import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/day_Indicator.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:flutter_staff/home_page/confirm_delete_dialog.dart';

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

  Widget _buildText(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(text, style: TextStyle(fontSize: fontSize)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1, vertical: screenWidth * 0.03),
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
      child: AspectRatio(
        aspectRatio: 16 / 11, // Фиксированное соотношение ширины к высоте
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.02,
                screenWidth * 0.03,
                screenWidth * 0.02,
                0,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(
                          screenWidth, screenHeight), // Передаем оба аргумента
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(child: _buildUserInfo(screenWidth)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.1),
                    child: DayIndicator(startDateString: user.deviceDate),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenWidth * 0.03,
              right: screenWidth * 0.02,
              child: IconButton(
                onPressed: () async {
                  await onEdit();
                },
                icon: const Icon(Icons.more_vert, color: Colors.black),
              ),
            ),
            Positioned(
              bottom: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: IconButton(
                onPressed: () => showConfirmDeleteDialog(context, user),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.17,
      width: screenWidth * 0.3,
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

  Widget _buildUserInfo(double screenWidth) {
    final fontSize = screenWidth * 0.03;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(user.surname, fontSize),
        _buildText(user.name, fontSize),
        _buildText(user.patronymic, fontSize),
        _buildText(user.number, fontSize),
        Row(
          children: [
            const Icon(Icons.directions_walk, size: 15),
            const SizedBox(width: 4),
            Text(user.deviceDate, style: TextStyle(fontSize: fontSize)),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.import_contacts, size: 15),
            const SizedBox(width: 4),
            Text(user.medicalBook, style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ],
    );
  }
}
