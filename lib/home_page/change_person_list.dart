import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:image_picker/image_picker.dart';
import 'change_person_list_ui.dart';

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
  ChangePersonListState createState() => ChangePersonListState();
}

class ChangePersonListState extends State<ChangePersonList> {
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  void _rescheduleNotification(User user) async {
    final notificationService = NotificationService();
    await notificationService.cancelNotification(user.key);
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
      if (mounted) {
        _rescheduleNotification(widget.user);
        widget.onUpdate();
        Navigator.of(context).pop();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ChangePersonListUI(
      user: widget.user,
      image: _image,
      onUpdate: updateUser,
      surnameController: _surnameController,
      nameController: _nameController,
      patronymicController: _patronymicController,
      numberController: _numberController,
      deviceDateController: _deviceDateController,
      medicalBookController: _medicalBookController,
      pickImage: _pickImage,
      dialogWidth: width - 60,
    );
  }
}
