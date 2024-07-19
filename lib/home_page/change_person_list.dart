import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class ChangePersonList extends StatefulWidget {
  final User user;

  const ChangePersonList({super.key, required this.user});

  @override
  State<ChangePersonList> createState() => _ChangePersonListState();
}

class _ChangePersonListState extends State<ChangePersonList> {
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _patronymicController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _deviceDate = TextEditingController();
  final TextEditingController _medicalBook = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _surnameController.text = widget.user.surname;
    _nameController.text = widget.user.name;
    _patronymicController.text = widget.user.patronymic;
    _numberController.text = widget.user.number;
    _deviceDate.text = widget.user.deviceDate;
    _medicalBook.text = widget.user.medicalBook;
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _patronymicController.dispose();
    _numberController.dispose();
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

  void updateUser() {
    final updatedUser = User(
      surname: _surnameController.text,
      name: _nameController.text,
      patronymic: _patronymicController.text,
      number: _numberController.text,
      deviceDate: _deviceDate.text,
      medicalBook: _medicalBook.text,
      imagePath: _image?.path,
    );

    Hive.box<User>('users').put(widget.user.key, updatedUser);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _patronymicController,
                  decoration: const InputDecoration(
                    labelText: 'Отчество',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: 'Номер телефона',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _deviceDate,
                  decoration: const InputDecoration(
                    labelText: 'Дата устройства',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _medicalBook,
                  decoration: const InputDecoration(
                    labelText: 'Медкнижка',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateUser,
                  child: const Text('Сохранить изменения'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showChangePersonListDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ChangePersonList(user: user);
    },
  );
}
