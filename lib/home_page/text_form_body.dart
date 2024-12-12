import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/bloc/user_bloc.dart';
import 'package:flutter_staff/bloc/user_event.dart';
import 'package:flutter_staff/home_page/formatter_date.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TextFormBody extends StatelessWidget {
  final TextEditingController surnameController;
  final TextEditingController nameController;
  final TextEditingController patronymicController;
  final TextEditingController numberController;
  final TextEditingController deviceDateController;
  final TextEditingController medicalBookController;
  final Future<void> Function() onPickImage;
  final Future<void> Function() onSave;
  final XFile? image;

  const TextFormBody({
    super.key,
    required this.surnameController,
    required this.nameController,
    required this.patronymicController,
    required this.numberController,
    required this.deviceDateController,
    required this.medicalBookController,
    required this.onPickImage,
    required this.onSave,
    this.image,
  });

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Регистрация нового сотрудника',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<UserBloc>().add(
                    SaveUserEvent(
                      surname: surnameController.text,
                      name: nameController.text,
                      patronymic: patronymicController.text,
                      number: numberController.text,
                      deviceDate: deviceDateController.text,
                      medicalBook: medicalBookController.text,
                      imagePath: image?.path,
                    ),
                  );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save, size: 30),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await onPickImage(); // Вызов асинхронной функции
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 150,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: image == null
                        ? const Center(child: Icon(Icons.person, size: 80))
                        : FutureBuilder<File>(
                            future: Future.value(File(image!.path)),
                            builder: (context, snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.done
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 170,
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator());
                            },
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: surnameController,
                        decoration: _buildInputDecoration('Фамилия'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        decoration: _buildInputDecoration('Имя'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: patronymicController,
                        decoration: _buildInputDecoration('Отчество'),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: numberController,
              decoration: _buildInputDecoration('Номер телефона'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [FormatterDate()],
                      keyboardType: TextInputType.number,
                      controller: deviceDateController,
                      decoration: _buildInputDecoration('Дата устройства'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [FormatterDate()],
                      keyboardType: TextInputType.number,
                      controller: medicalBookController,
                      decoration: _buildInputDecoration('Медкнижка'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
