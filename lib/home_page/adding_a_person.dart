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
    _userCache = userBox.values.toList();
    _filteredUsers = _userCache;
    _searchController.addListener(_updateSearchState);
    _searchFocusNode.addListener(_handleFocusChange);
    _sortUsers();
  }

  void _sortUsers() {
    setState(() {
      _filteredUsers.sort((a, b) {
        DateTime deviceDateA, deviceDateB, medicalDateA, medicalDateB;

        try {
          deviceDateA = DateFormat('dd.MM.yyyy').parse(a.deviceDate);
        } catch (e) {
          deviceDateA =
              DateTime(0); // Значение по умолчанию, если парсинг не удался
        }

        try {
          deviceDateB = DateFormat('dd.MM.yyyy').parse(b.deviceDate);
        } catch (e) {
          deviceDateB = DateTime(0);
        }

        try {
          medicalDateA = DateFormat('dd.MM.yyyy').parse(a.medicalBook);
        } catch (e) {
          medicalDateA = DateTime(0);
        }

        try {
          medicalDateB = DateFormat('dd.MM.yyyy').parse(b.medicalBook);
        } catch (e) {
          medicalDateB = DateTime(0);
        }

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

  void _addUser(User user) {
    setState(() {
      if (user.isInBox) {
        user.save();
      } else {
        userBox.add(user);
      }
      _userCache = userBox.values.toList(); // Обновляем кэш
      _filteredUsers = _userCache;
      _sortUsers(); // Применяем сортировку после добавления
    });
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
    setState(() {
      _filteredUsers = updateSearchState(_searchController, _userCache);
      _sortUsers();
    });
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
      onFilterChanged: _onFilterChanged, // Передаем обработчик
    );
  }
}
