import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staff/home_page/formatter_date.dart';
import 'package:flutter_staff/home_page/user.dart';

class ChangePersonListUI extends StatefulWidget {
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
  ChangePersonListUIState createState() => ChangePersonListUIState();
}

class ChangePersonListUIState extends State<ChangePersonListUI> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить данные'),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      content: SizedBox(
        width: widget.dialogWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                _buildImagePicker(),
                _buildTextField(
                    controller: widget.surnameController, label: 'Фамилия'),
                _buildTextField(
                    controller: widget.nameController, label: 'Имя'),
                _buildTextField(
                    controller: widget.patronymicController, label: 'Отчество'),
                _buildTextField(
                    controller: widget.numberController,
                    label: 'Номер телефона'),
                _buildDateField(
                    controller: widget.deviceDateController,
                    label: 'Дата устройства'),
                _buildDateField(
                    controller: widget.medicalBookController,
                    label: 'Медкнижка'),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: widget.onUpdate,
          child: const Text('Сохранить изменения'),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: widget.pickImage,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: widget.image == null
            ? const Center(
                child: Icon(
                  Icons.person,
                  size: 80,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(widget.image!.path),
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      textCapitalization: TextCapitalization.words,
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDateField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      inputFormatters: [FormatterDate()],
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
