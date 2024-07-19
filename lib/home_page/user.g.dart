// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      surname: fields[0] as String? ?? 'Фамилия',
      name: fields[1] as String? ?? 'Имя',
      patronymic: fields[2] as String? ?? 'Отчество',
      number: fields[3] as String? ?? 'Номер',
      imagePath: fields[4] as String?,
      deviceDate: fields[5] as String? ?? '01.01.2020',
      medicalBook: fields[6] as String? ?? 'Медкнижка',
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.surname)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.patronymic)
      ..writeByte(3)
      ..write(obj.number)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.deviceDate)
      ..writeByte(6)
      ..write(obj.medicalBook);
  }
}
