import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/chats/chat_screen_lam.dart';
import 'package:halo/screens/contact/contact_screen.dart';
import 'package:halo/screens/post/newfeed/newfeed_screen.dart';
import 'package:halo/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  List<Widget> pageLists = <Widget>[
    ChatScreen(),
    ContactScreen(),
    NewFeedScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageLists[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Tin nhắn"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Danh bạ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_sharp), label: "Nhật ký"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Cá nhân")
        ],
      ),
    );
  }
}
