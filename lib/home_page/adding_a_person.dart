import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/adding_person_view.dart';
import 'package:flutter_staff/home_page/search_utils.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddingAPerson extends StatefulWidget {
  final Box<User> userBox;

  const AddingAPerson({super.key, required this.userBox});

  @override
  State<AddingAPerson> createState() => _AddingAPersonState();
}

class _AddingAPersonState extends State<AddingAPerson> {
  late Box<User> userBox;
  late List<User> _userCache; // Кэшированный список пользователей
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<User> _filteredUsers = [];
  int _selectedFilter =
      1; // По умолчанию, сортировка по дате устройства от большего к меньшему

  @override
  void initState() {
    super.initState();
    userBox = widget.userBox;
    _loadInitialUsers();
    _searchController.addListener(_updateSearchState);
    _searchFocusNode.addListener(_handleFocusChange);
  }

  // Асинхронная загрузка пользователей
  Future<void> _loadInitialUsers() async {
    _userCache = await _getUsers();
    _filteredUsers = _userCache;
    _sortUsers();
  }

  Future<List<User>> _getUsers() async {
    // Возвращаем список пользователей из базы данных
    return userBox.values.toList();
  }

  void _sortUsers() {
    setState(() {
      _filteredUsers.sort((a, b) {
        DateTime deviceDateA, deviceDateB, medicalDateA, medicalDateB;

        deviceDateA = _parseDate(a.deviceDate);
        deviceDateB = _parseDate(b.deviceDate);
        medicalDateA = _parseDate(a.medicalBook);
        medicalDateB = _parseDate(b.medicalBook);

        switch (_selectedFilter) {
          case 1: // По дате устройства от большего к меньшему
            return deviceDateB.compareTo(deviceDateA);
          case 2: // По дате устройства от меньшего к большему
            return deviceDateA.compareTo(deviceDateB);
          case 3: // По дате мед книжки от большего к меньшему
            return medicalDateB.compareTo(medicalDateA);
          case 4: // По дате мед книжки от меньшего к большему
            return medicalDateA.compareTo(medicalDateB);
          default:
            return 0;
        }
      });
    });
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('dd.MM.yyyy').parse(dateString);
    } catch (e) {
      return DateTime(0); // Значение по умолчанию, если парсинг не удался
    }
  }

  Future<void> _addUser(User user) async {
    setState(() {
      if (user.isInBox) {
        user.save();
      } else {
        userBox.add(user);
      }
      _updateUserCache(); // Обновляем кэш
      _sortUsers(); // Сортировка после добавления
    });
  }

  Future<void> _updateUserCache() async {
    _userCache = await _getUsers(); // Обновляем кэш асинхронно
    _filteredUsers = _userCache; // Применяем изменения в одном вызове
  }

  void _onFilterChanged(int filterOption) {
    setState(() {
      _selectedFilter = filterOption;
      _sortUsers();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching =
          toggleSearchMode(_isSearching, _searchController, _searchFocusNode);
    });
  }

  void _updateSearchState() {
    final newFilteredUsers = updateSearchState(_searchController, _userCache);
    if (_filteredUsers != newFilteredUsers) {
      setState(() {
        _filteredUsers = newFilteredUsers;
      });
    }
  }

  void _handleFocusChange() {
    setState(() {
      _isSearching =
          handleFocusChange(_searchFocusNode, _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddingPersonView(
      filteredUsers: _filteredUsers,
      isSearching: _isSearching,
      searchController: _searchController,
      searchFocusNode: _searchFocusNode,
      toggleSearch: _toggleSearch,
      addUser: _addUser,
      onFilterChanged: _onFilterChanged,
    );
  }
}
