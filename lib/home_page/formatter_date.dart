import 'package:flutter/services.dart';

class FormatterDate extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Удаляем все нечисловые символы

    // Форматируем текст с точками
    if (newText.length >= 2) {
      newText = '${newText.substring(0, 2)}.${newText.substring(2)}';
    }
    if (newText.length >= 5) {
      newText = '${newText.substring(0, 5)}.${newText.substring(5)}';
    }

    // Обрезаем текст, если его длина больше 10 символов
    newText = newText.substring(0, newText.length > 10 ? 10 : newText.length);

    // Корректируем положение курсора, чтобы пользователь мог удалять символы в любом месте
    int cursorPosition = newText.length;
    if (oldValue.text.length > newValue.text.length) {
      // Если пользователь удаляет символ, корректируем позицию курсора
      cursorPosition = newValue.selection.baseOffset;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
