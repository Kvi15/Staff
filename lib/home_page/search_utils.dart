import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/user.dart';

/// Функция для обновления состояния поиска.
/// Фильтрует пользователей на основе введенного текста в поле поиска.
List<User> updateSearchState(
  TextEditingController searchController,
  List<User> users,
) {
  if (searchController.text.isEmpty) {
    return users;
  } else {
    return users.where((user) {
      return user.surname.contains(searchController.text) ||
          user.name.contains(searchController.text) ||
          user.patronymic.contains(searchController.text) ||
          user.number.contains(searchController.text) ||
          user.deviceDate.contains(searchController.text) ||
          user.medicalBook.contains(searchController.text);
    }).toList();
  }
}

/// Функция для переключения режима поиска.
/// Возвращает обновленное значение [_isSearching].
bool toggleSearchMode(
  bool isSearching,
  TextEditingController searchController,
  FocusNode searchFocusNode,
) {
  if (isSearching) {
    searchController.clear();
    return false;
  } else {
    searchFocusNode.requestFocus();
    return true;
  }
}

/// Функция для обработки потери фокуса при выходе из режима поиска.
bool handleFocusChange(FocusNode searchFocusNode, String searchText) {
  return searchFocusNode.hasFocus || searchText.isNotEmpty;
}
