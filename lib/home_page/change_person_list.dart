import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/formatter_date.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void showChangePersonListDialog(
    BuildContext context, User user, VoidCallback onUpdate) {
  showDialog(
    context: context,
    builder: (context) {
      return ChangePersonList(user: user, onUpdate: onUpdate);
    },
  );
}

class ChangePersonList extends StatefulWidget {
  final User user;
  final VoidCallback onUpdate;

  const ChangePersonList({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  _ChangePersonListState createState() => _ChangePersonListState();
}

class _ChangePersonListState extends State<ChangePersonList> {
  late TextEditingController _surnameController;
  late TextEditingController _nameController;
  late TextEditingController _patronymicController;
  late TextEditingController _numberController;
  late TextEditingController _deviceDateController;
  late TextEditingController _medicalBookController;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _surnameController = TextEditingController(text: widget.user.surname);
    _nameController = TextEditingController(text: widget.user.name);
    _patronymicController = TextEditingController(text: widget.user.patronymic);
    _numberController = TextEditingController(text: widget.user.number);
    _deviceDateController = TextEditingController(text: widget.user.deviceDate);
    _medicalBookController =
        TextEditingController(text: widget.user.medicalBook);
    _image =
        widget.user.imagePath != null ? XFile(widget.user.imagePath!) : null;
  }

  void _rescheduleNotification(User user) async {
    final notificationService = NotificationService();

    // Отменяем старые уведомления
    await notificationService.cancelNotification(user.key);

    // Планируем новые уведомления
    _scheduleNotificationsForUser(user);
  }

  void _scheduleNotificationsForUser(User user) {
    final NotificationService notificationService = NotificationService();
    final dateFormat = DateFormat('dd.MM.yyyy');

    if (user.deviceDate.isNotEmpty) {
      try {
        DateTime startDate = dateFormat.parse(user.deviceDate);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 12)),
            user,
            "Через 2 дня ТЕТ-А-ТЕТ c ${user.surname} ${user.name} ${user.patronymic}");
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 14)),
            user,
            "Сегодня день ТЕТ-А-ТЕТ c ${user.surname} ${user.name} ${user.patronymic}");
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 28)),
            user,
            "Через 2 дня ТЕТ-А-ТЕТ c ${user.surname} ${user.name} ${user.patronymic}");
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 30)),
            user,
            "Сегодня день ТЕТ-А-ТЕТ c ${user.surname} ${user.name} ${user.patronymic}");
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 58)),
            user,
            "Через 2 дня ТЕТ-А-ТЕТ c ${user.surname} ${user.name} ${user.patronymic}");
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 60)),
            user,
            "Сегодня день ТЕТ-А-ТЕТ c ${user.surname} ${user.name} ${user.patronymic}");
      } catch (e) {
        debugPrint('Error scheduling notifications: $e');
      }
    }
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _patronymicController.dispose();
    _numberController.dispose();
    _deviceDateController.dispose();
    _medicalBookController.dispose();
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

  void updateUser() {
    setState(() {
      widget.user.surname = _surnameController.text;
      widget.user.name = _nameController.text;
      widget.user.patronymic = _patronymicController.text;
      widget.user.number = _numberController.text;
      widget.user.deviceDate = _deviceDateController.text;
      widget.user.medicalBook = _medicalBookController.text;
      widget.user.imagePath = _image?.path;
    });

    widget.user.save().then((_) {
      _rescheduleNotification(widget.user); // Перепланируем уведомления
      widget.onUpdate(); // Вызов обратного вызова для обновления списка
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width - 60; // 15 пикселей слева и 15 пикселей справа

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
                  onTap: _pickImage,
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 150,
                    height: 150,
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
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                  ),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _surnameController,
                  decoration: const InputDecoration(labelText: 'Фамилия'),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _patronymicController,
                  decoration: const InputDecoration(labelText: 'Отчество'),
                ),
                TextField(
                  controller: _numberController,
                  decoration:
                      const InputDecoration(labelText: 'Номер телефона'),
                ),
                TextField(
                  inputFormatters: [FormatterDate()],
                  controller: _deviceDateController,
                  decoration:
                      const InputDecoration(labelText: 'Дата устройства'),
                ),
                TextField(
                  inputFormatters: [FormatterDate()],
                  controller: _medicalBookController,
                  decoration: const InputDecoration(labelText: 'Медкнижка'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: updateUser,
          child: const Text('Сохранить изменения'),
        ),
      ],
    );
  }
}
