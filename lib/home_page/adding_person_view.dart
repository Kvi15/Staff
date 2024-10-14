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

  const AddingPersonView({
    super.key,
    required this.filteredUsers,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.toggleSearch,
    required this.addUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 0, 0),
                    Color.fromARGB(115, 255, 255, 255),
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
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 260, 10, 8),
                            child: Row(
                              children: [
                                if (isSearching)
                                  Expanded(
                                    child: TextField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: searchController,
                                      focusNode: searchFocusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Поиск',
                                        suffixIcon: IconButton(
                                          onPressed: searchController.clear,
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
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
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            size: 20,
                          ),
                          color: Colors.black,
                          iconSize: 30,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Связь с разработчиком'),
                                  content: const Text(
                                      'Обратитесь по адресу putslizox@gmail.com'),
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
