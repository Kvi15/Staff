import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/build_person_list_view.dart';
import 'package:flutter_staff/home_page/notification_service.dart';
import 'package:flutter_staff/home_page/text_form.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    userBox = widget.userBox; // Используем переданный userBox
    _searchController.addListener(_updateSearchState);
    _searchFocusNode.addListener(_handleFocusChange);
    _filteredUsers = userBox.values.toList();
  }

  void _addUser(User user) {
    setState(() {
      if (user.isInBox) {
        // Если пользователь уже сохранен, просто обновляем его данные
        user.save();
      } else {
        // Если пользователь новый, добавляем его в коробку
        userBox.add(user);

        // Планирование уведомлений только для нового пользователя
        _scheduleNotificationsForUser(user);
      }
      _filteredUsers = userBox.values.toList();
    });
  }

  void _scheduleNotificationsForUser(User user) {
    final NotificationService notificationService = NotificationService();
    final dateFormat = DateFormat('dd.MM.yyyy');

    if (user.deviceDate.isNotEmpty) {
      try {
        DateTime startDate = dateFormat.parse(user.deviceDate);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 12)), user);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 14)), user);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 28)), user);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 30)), user);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 58)), user);
        notificationService.scheduleDailyNotification(
            startDate.add(const Duration(days: 60)), user);
      } catch (e) {
        debugPrint('Error scheduling notifications: $e');
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      } else {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _updateSearchState() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredUsers = userBox.values.toList();
      } else {
        _filteredUsers = userBox.values
            .where((user) =>
                user.surname.contains(_searchController.text) ||
                user.name.contains(_searchController.text) ||
                user.patronymic.contains(_searchController.text) ||
                user.number.contains(_searchController.text) ||
                user.deviceDate.contains(_searchController.text) ||
                user.medicalBook.contains(_searchController.text))
            .toList();
      }
    });
  }

  void _handleFocusChange() {
    if (!_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 0, 0),
                  Color.fromARGB(255, 255, 255, 255),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        'assets/icons/lgv9s1kz-removebg-preview.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 260, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _isSearching
                            ? Expanded(
                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  decoration: InputDecoration(
                                      hintText: 'Поиск',
                                      suffixIcon: IconButton(
                                          onPressed: _searchController.clear,
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                            size: 20,
                                          ))),
                                ),
                              )
                            : IconButton(
                                onPressed: _toggleSearch,
                                icon: const Icon(
                                  Icons.search,
                                  size: 25,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              BuildPersonListView(
                scrollOffset: 0.0,
                users: _filteredUsers,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
        onPressed: () {
          showModalBottomSheet<User>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: FractionallySizedBox(
                  heightFactor: 0.53,
                  child: TextForm(
                    onEmployeeAdded: _addUser,
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(
          Icons.person_add,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 40,
        ),
      ),
    );
  }
}
