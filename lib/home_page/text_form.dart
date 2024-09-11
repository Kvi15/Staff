import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staff/home_page/formatter_date.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // Для работы с датами

class TextForm extends StatefulWidget {
  final Function(User) onEmployeeAdded;
  const TextForm({super.key, required this.onEmployeeAdded});

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  final _surname = TextEditingController();
  final _name = TextEditingController();
  final _patronymic = TextEditingController();
  final _number = TextEditingController();
  final _deviceDate = TextEditingController();
  final _medicalBook = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  final NotificationService _notificationService = NotificationService();

  @override
  void dispose() {
    _surname.dispose();
    _name.dispose();
    _patronymic.dispose();
    _number.dispose();
    _deviceDate.dispose();
    _medicalBook.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  void saveUser() async {
    if (!mounted) return;

    final newUser = User(
      surname: _surname.text.isNotEmpty ? _surname.text : 'Фамилия',
      name: _name.text.isNotEmpty ? _name.text : 'Имя',
      patronymic: _patronymic.text.isNotEmpty ? _patronymic.text : 'Отчество',
      number: _number.text.isNotEmpty ? _number.text : 'Номер телефона',
      imagePath: _image?.path,
      medicalBook:
          _medicalBook.text.isNotEmpty ? _medicalBook.text : 'Медкнижка',
      deviceDate:
          _deviceDate.text.isNotEmpty ? _deviceDate.text : 'Дата устройства',
    );

    // Сохраняем пользователя в базу данных
    final box = Hive.box<User>('users');
    await box.add(newUser); // После этого newUser.key будет доступен

    // Планирование уведомлений
    if (_deviceDate.text.isNotEmpty) {
      try {
        final dateFormat = DateFormat('dd.MM.yyyy');
        DateTime startDate = dateFormat.parse(_deviceDate.text);

        // Используем ключ пользователя как уникальный идентификатор уведомлений
        await _notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 12)), newUser);
        await _notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 14)), newUser);
        await _notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 28)), newUser);
        await _notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 30)), newUser);
        await _notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 58)), newUser);
        await _notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 60)), newUser);
      } catch (e) {
        debugPrint('Error scheduling notifications: $e');
      }
    }

    widget.onEmployeeAdded(newUser);

    if (mounted) {
      Navigator.of(context).pop(newUser);
    }
  }

  User newUser = User();

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
                onPressed: () {
                  saveUser();
                },
                icon: const Icon(
                  Icons.save,
                  size: 35,
                ),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 5, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 150,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: _image == null
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(_image!.path),
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
                        controller: _surname,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          labelText: 'Фамилия',
                        ),
                        onChanged: (value) => newUser.surname = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Имя',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        onChanged: (value) => newUser.name = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: _patronymic,
                        decoration: const InputDecoration(
                          labelText: 'Отчество',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        onChanged: (value) => newUser.patronymic = value,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _number,
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              onChanged: (value) => newUser.number = value,
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
                      controller: _deviceDate,
                      decoration: const InputDecoration(
                        labelText: 'Дата устройства',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      onChanged: (value) => newUser.deviceDate = value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [FormatterDate()],
                      keyboardType: TextInputType.number,
                      controller: _medicalBook,
                      decoration: const InputDecoration(
                        labelText: 'Медкнижка',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      onChanged: (value) => newUser.medicalBook = value,
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
