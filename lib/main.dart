import 'package:flutter/material.dart';
import 'package:halo/screens/chats/chat_screen.dart';
import 'package:halo/screens/contact/add_friend/search_friend.dart';
import 'package:halo/screens/contact/request_addfriend/requests_addfriends.dart';
import 'package:halo/screens/login/login_screen.dart';
import 'package:halo/screens/main/main_screen.dart';
import 'package:halo/screens/message/message_screen.dart';
import 'package:halo/screens/post/newpost/new_post_screen.dart';
import 'package:halo/screens/postdetail/post_detail.dart';
import 'package:halo/screens/register/error_screen.dart';
import 'package:halo/screens/register/register_screen.dart';
import 'package:halo/constants.dart';

import 'screens/welcome/welcomescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/chatspage',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/chatspage': (context) => const ChatScreen(),
        '/message': (context) => const MessageScreen(),
        '/newpost': (context) => const NewPost(),
        '/main': (context) => const MainScreen(),
        '/requestsAddFriend': (context) => const RequestsAddFriendsScreen(),
        '/searchFriend': (context) => const SearchFriendScreen()
      },
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: primaryColor,
      ),
    );
  }
}
