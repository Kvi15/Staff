import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/adding_person_view.dart';
import 'package:flutter_staff/home_page/search_utils.dart';
import 'package:flutter_staff/home_page/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

    // Загружаем данные пользователей в кэш
    _userCache = userBox.values.toList();
    _filteredUsers = _userCache;

    _searchController.addListener(_updateSearchState);
    _searchFocusNode.addListener(_handleFocusChange);
  }

  void _addUser(User user) {
    setState(() {
      if (user.isInBox) {
        user.save();
      } else {
        userBox.add(user);
      }
      _userCache = userBox.values.toList(); // Обновляем кэш
      _filteredUsers = _userCache; // Обновляем отображение
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
    );
  }
}
