import 'package:flutter/material.dart';
import 'screens/chats/conversation_list.dart';

class ScreenNav extends StatefulWidget {
  const ScreenNav({Key? key}) : super(key: key);

  @override
  State<ScreenNav> createState() => _NavScreenState();
}

class _NavScreenState extends State<ScreenNav> {
  int _selectedIndex = 0;

  final _screens = [
    const ConversationList(),
    const Scaffold(body: Center(child: Text('Danh bạ'))),
    const Scaffold(body: Center(child: Text('Nhật ký'))),
    const Scaffold(body: Center(child: Text('Cá nhân')))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: _screens
            .asMap()
            .map(
              (i, screen) => MapEntry(
                i,
                Offstage(offstage: _selectedIndex != i, child: screen),
              ),
            )
            .values
            .toList(),
      ),
      bottomNavigationBar: buildNavigator(),
    );
  }

  Theme buildNavigator() {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedFontSize: 16,
          unselectedFontSize: 16,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: 'Tin nhắn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account_outlined),
              activeIcon: Icon(Icons.supervisor_account),
              label: 'Danh bạ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              activeIcon: Icon(Icons.access_time),
              label: 'Nhật ký',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                activeIcon: Icon(Icons.person),
                label: 'Cá nhân'),
          ]),
    );
  }
}
