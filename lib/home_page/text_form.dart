// text_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/notification_helper.dart';
import 'package:flutter_staff/home_page/text_form_body.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

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

    // Планирование уведомлений через NotificationHelper
    NotificationHelper.scheduleNotificationsForUser(newUser);

    // Передаем нового пользователя в коллбэк для добавления и обновления состояния в основном виджете
    widget.onEmployeeAdded(newUser);

    if (mounted) {
      Navigator.of(context).pop(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormBody(
      surnameController: _surname,
      nameController: _name,
      patronymicController: _patronymic,
      numberController: _number,
      deviceDateController: _deviceDate,
      medicalBookController: _medicalBook,
      onPickImage: _pickImage,
      onSave: saveUser,
      image: _image,
    );
  }
}
