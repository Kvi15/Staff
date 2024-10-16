import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/build_person_list_view.dart';
import 'package:flutter_staff/home_page/text_form.dart';
import 'package:flutter_staff/home_page/user.dart';

class AddingPersonView extends StatefulWidget {
  final List<User> filteredUsers;
  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback toggleSearch;
  final void Function(User) addUser;
  final Function(int) onFilterChanged;

  const AddingPersonView({
    super.key,
    required this.filteredUsers,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.toggleSearch,
    required this.addUser,
    required this.onFilterChanged,
  });

  @override
  AddingPersonViewState createState() => AddingPersonViewState();
}

class AddingPersonViewState extends State<AddingPersonView> {
  static const _backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(115, 255, 255, 255),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  );

  static const _inputDecoration = InputDecoration(
    hintText: 'Поиск',
    suffixIcon: Icon(
      Icons.clear,
      color: Color.fromARGB(255, 0, 0, 0),
      size: 20,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 65),
                  sliver: _buildUserList(),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: _backgroundDecoration,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image(
                  image: AssetImage('assets/icons/background_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Column(
          children: [
            const Spacer(),
            _buildInfoButton(),
            _buildSearchAndFilterRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.info_outline, size: 20),
          color: Colors.black,
          iconSize: 30,
          onPressed: _showInfoDialog,
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.isSearching)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: widget.searchController,
                    focusNode: widget.searchFocusNode,
                    decoration: _inputDecoration,
                  ),
                ),
              )
            else
              IconButton(
                onPressed: widget.toggleSearch,
                icon: const Icon(Icons.search, size: 25),
              ),
            PopupMenuButton<int>(
              icon: const Icon(Icons.filter_list),
              onSelected: widget.onFilterChanged,
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 1,
                  child: Text("Сначала новый сотрудник"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Сначала старый сотрудник"),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text("Сначала новая книжка"),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Text("Сначала старая книжка"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return BuildPersonListView(
      users: widget.filteredUsers,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 255, 17, 0),
      onPressed: _showAddUserForm,
      child: const Icon(
        Icons.person_add,
        color: Color.fromARGB(255, 255, 255, 255),
        size: 40,
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Связь с разработчиком',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'Обратитесь по адресу putslizox@gmail.com',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddUserForm() {
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
              onEmployeeAdded: widget.addUser,
            ),
          ),
        );
      },
    );
  }
}
