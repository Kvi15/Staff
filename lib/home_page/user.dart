import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String surname;

  @HiveField(1)
  String name;

  @HiveField(2)
  String patronymic;

  @HiveField(3)
  String number;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  String deviceDate;

  @HiveField(6)
  String medicalBook;

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
