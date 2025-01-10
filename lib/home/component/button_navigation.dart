import 'package:app_note_client/home/note_list/note_list_page.dart';
import 'package:flutter/material.dart';

import '../note_home/home_page.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  int _selectedIndex = 0;
  late List<Widget> tabs;
  void initState() {
    super.initState();
    tabs = [
      HomePage(),
      NoteListPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 27, color: Color(0xFF80AF81)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded,
                size: 27, color: Color(0xFF80AF81)),
            label: "Catatan",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
