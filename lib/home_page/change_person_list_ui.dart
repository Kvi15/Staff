import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staff/home_page/formatter_date.dart';
import 'package:flutter_staff/home_page/user.dart';

class ChangePersonListUI extends StatelessWidget {
  final User user;
  final XFile? image;
  final VoidCallback onUpdate;
  final TextEditingController surnameController;
  final TextEditingController nameController;
  final TextEditingController patronymicController;
  final TextEditingController numberController;
  final TextEditingController deviceDateController;
  final TextEditingController medicalBookController;
  final Future<void> Function() pickImage;
  final double dialogWidth;

  const ChangePersonListUI({
    super.key,
    required this.user,
    required this.image,
    required this.onUpdate,
    required this.surnameController,
    required this.nameController,
    required this.patronymicController,
    required this.numberController,
    required this.deviceDateController,
    required this.medicalBookController,
    required this.pickImage,
    required this.dialogWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить данные'),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: image == null
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                  ),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: surnameController,
                  decoration: const InputDecoration(labelText: 'Фамилия'),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: patronymicController,
                  decoration: const InputDecoration(labelText: 'Отчество'),
                ),
                TextField(
                  controller: numberController,
                  decoration:
                      const InputDecoration(labelText: 'Номер телефона'),
                ),
                TextField(
                  inputFormatters: [FormatterDate()],
                  controller: deviceDateController,
                  decoration:
                      const InputDecoration(labelText: 'Дата устройства'),
                ),
                TextField(
                  inputFormatters: [FormatterDate()],
                  controller: medicalBookController,
                  decoration: const InputDecoration(labelText: 'Медкнижка'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onUpdate,
          child: const Text('Сохранить изменения'),
        ),
      ],
    );
  }
}
