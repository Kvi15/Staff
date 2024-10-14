// ui/text_form_body.dart
import 'package:flutter/material.dart';
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
  final Function() onPickImage;
  final Function() onSave;
  final XFile? image;

  const TextFormBody({
    Key? key,
    required this.surnameController,
    required this.nameController,
    required this.patronymicController,
    required this.numberController,
    required this.deviceDateController,
    required this.medicalBookController,
    required this.onPickImage,
    required this.onSave,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Регистрация нового сотрудника',
              style: TextStyle(fontSize: 21, color: Colors.black),
            ),
            IconButton(
              onPressed: onSave,
              icon: const Icon(
                Icons.save,
                size: 35,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: onPickImage,
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
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 170,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: surnameController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Фамилия',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: patronymicController,
                        decoration: const InputDecoration(
                          labelText: 'Отчество',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
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
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
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
                      decoration: const InputDecoration(
                        labelText: 'Дата устройства',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [FormatterDate()],
                      keyboardType: TextInputType.number,
                      controller: medicalBookController,
                      decoration: const InputDecoration(
                        labelText: 'Медкнижка',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save, size: 24),
              label: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
