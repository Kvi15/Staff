import 'package:flutter/material.dart';
import 'package:flutter_staff/home_page/build_person_list_view.dart';
import 'package:flutter_staff/home_page/text_form.dart';
import 'package:flutter_staff/home_page/user.dart';

class AddingPersonView extends StatelessWidget {
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

  // Вынесенные параметры
  static const BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(115, 255, 255, 255),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  );

  static const InputDecoration searchInputDecoration = InputDecoration(
    hintText: 'Поиск',
    suffixIcon: Icon(
      Icons.clear,
      color: Color.fromARGB(255, 0, 0, 0),
      size: 20,
    ),
  );

  static const TextStyle dialogTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dialogContentStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: backgroundDecoration,
              child: const Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image(
                          image: AssetImage('assets/icons/background_logo.png'),
                          fit: BoxFit.cover,
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
                    title: Column(
                      children: [
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info_outline, size: 20),
                              color: Colors.black,
                              iconSize: 30,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Связь с разработчиком',
                                          style: dialogTitleStyle),
                                      content: const Text(
                                          'Обратитесь по адресу putslizox@gmail.com',
                                          style: dialogContentStyle),
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
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (isSearching)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: searchController,
                                        focusNode: searchFocusNode,
                                        decoration: searchInputDecoration,
                                      ),
                                    ),
                                  )
                                else
                                  IconButton(
                                    onPressed: toggleSearch,
                                    icon: const Icon(
                                      Icons.search,
                                      size: 25,
                                    ),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: PopupMenuButton<int>(
                                    icon: const Icon(Icons.filter_list),
                                    onSelected: onFilterChanged,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 65),
                  sliver: BuildPersonListView(
                    users: filteredUsers,
                  ),
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
                      onEmployeeAdded: addUser,
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
      ),
    );
  }
}
