import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/adding_person_view.dart';
import 'package:flutter_staff/home_page/search_utils.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive/hive.dart';

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
  }

  Future<List<User>> _getUsers() async {
    // Возвращаем список пользователей из базы данных
    return userBox.values.toList();
  }

  Future<void> _addUser(User user) async {
    setState(() {
      if (user.isInBox) {
        user.save();
      } else {
        userBox.add(user);
      }
      _updateUserCache(); // Обновляем кэш
    });
  }

  Future<void> _updateUserCache() async {
    _userCache = await _getUsers(); // Обновляем кэш асинхронно
    _filteredUsers = _userCache; // Применяем изменения в одном вызове
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
      isSearching: _isSearching,
      searchController: _searchController,
      searchFocusNode: _searchFocusNode,
      toggleSearch: _toggleSearch,
      addUser: _addUser,
    );
  }
}
