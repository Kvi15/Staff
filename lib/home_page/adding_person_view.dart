import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staff/bloc/user_bloc.dart';
import 'package:flutter_staff/bloc/user_event.dart';
import 'package:flutter_staff/bloc/user_state.dart';
import 'package:flutter_staff/home_page/build_person_list_view.dart';
import 'package:flutter_staff/home_page/confirm_delete_dialog.dart';
import 'package:flutter_staff/home_page/text_form.dart';
import 'package:flutter_staff/home_page/user.dart';

class AddingPersonView extends StatefulWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback toggleSearch;
  final void Function(User) addUser;

  const AddingPersonView({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.toggleSearch,
    required this.addUser,
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

  void _onSearchChanged() {
    context
        .read<UserBloc>()
        .add(SearchUsersEvent(widget.searchController.text));
  }

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UsersLoaded && state.dialogIsOpen) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Связь с разработчиком',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  'Обратитесь по адресу putslizox@gmail.com',
                  style: TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Закрыть'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<UserBloc>().add(HideInfoDialogEvent());
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              _buildBackground(),
              CustomScrollView(
                slivers: [
                  _buildSliverAppBar(screenWidth, screenHeight),
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

  Widget _buildSliverAppBar(double screenWidth, double screenHeight) {
    return SliverAppBar(
      expandedHeight: screenHeight * 0.4,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Column(
          children: [
            Spacer(),
            _buildInfoButton(
              context,
            ),
            _buildSearchAndFilterRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.info_outline, size: 20),
          color: Colors.black,
          iconSize: 30,
          onPressed: () {
            context.read<UserBloc>().add(ShowInfoDialogEvent());
          },
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.isSearching)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: widget.searchController,
                      focusNode: widget.searchFocusNode,
                      decoration: _inputDecoration.copyWith(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 15,
                          ),
                          onPressed: _clearSearch,
                        ),
                      ),
                    ),
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
              onSelected: _onFilterChanged,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Сначала новый сотрудник"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Сначала старый сотрудник"),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text("Сначала новая книжка"),
                ),
                const PopupMenuItem(
                  value: 4,
                  child: Text("Сначала старая книжка"),
                ),
              ],
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearSearch() async {
    widget.searchController.clear();
    widget.toggleSearch();
    setState(() {});
  }

  Widget _buildUserList() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is UsersLoaded) {
          return BuildPersonListView(
            users: state.users,
            onDelete: (user) => showConfirmDeleteDialog(context, user),
            onRefresh: () {},
          );
        } else if (state is UserError) {
          return SliverToBoxAdapter(
            child: Center(child: Text(state.message)),
          );
        }
        return const SliverToBoxAdapter(
          child: Center(child: Text("Не удалось загрузить пользователей")),
        );
      },
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

  Future<void> _showAddUserForm() async {
    final User? newUser = await showModalBottomSheet<User>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: FractionallySizedBox(
            heightFactor: 0.65,
            child: TextForm(
              onEmployeeAdded: widget.addUser,
            ),
          ),
        );
      },
    );

    if (newUser != null) {
      widget.addUser(newUser);
    }
  }

  // Обработчик выбора фильтра
  void _onFilterChanged(int value) {
    context.read<UserBloc>().add(SortUsersEvent(value));
  }
}
