import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String surname = 'Фамилия';

  @HiveField(1)
  String name = 'Имя';

  @HiveField(2)
  String patronymic = 'Отчество';

  @HiveField(3)
  String number = 'Номер';

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  String deviceDate = '01.01.2020';

  @HiveField(6)
  String medicalBook = 'Медкнижка';

  User({
    this.surname = 'Фамилия',
    this.name = 'Имя',
    this.patronymic = 'Отчество',
    this.number = 'Номер',
    this.imagePath,
    this.deviceDate = '01.01.2020',
    this.medicalBook = 'Медкнижка',
  });
}

void updateExistingUsers(Box<User> userBox) {
  for (int i = 0; i < userBox.length; i++) {
    User? user = userBox.getAt(i);
    if (user != null) {
      user.surname = user.surname.isNotEmpty ? user.surname : 'Фамилия';
      user.name = user.name.isNotEmpty ? user.name : 'Имя';
      user.patronymic =
          user.patronymic.isNotEmpty ? user.patronymic : 'Отчество';
      user.number = user.number.isNotEmpty ? user.number : 'Номер';
      user.deviceDate =
          user.deviceDate.isNotEmpty ? user.deviceDate : '01.01.2020';
      user.medicalBook =
          user.medicalBook.isNotEmpty ? user.medicalBook : 'Медкнижка';
      user.save();
    }
  }
}
