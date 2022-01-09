import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/chats/chat_screen_lam.dart';
import 'package:halo/screens/contact/add_friend/search_friend.dart';
import 'package:halo/screens/contact/request_addfriend/requests_addfriends.dart';
import 'package:halo/screens/login/login_screen.dart';
import 'package:halo/screens/main/main_screen.dart';
import 'package:halo/screens/post/newpost/new_post_screen.dart';
import 'package:halo/screens/register/register_screen.dart';
import 'package:halo/screens/profile/profile_screen.dart';

import 'screens/chats/components/components.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/chatspage': (context) => ChatScreen(),
        '/newpost': (context) => const NewPost(),
        '/main': (context) => MainScreen(),
        '/requestsAddFriend': (context) => RequestsAddFriendsScreen(),
        '/searchFriend': (context) => SearchFriendScreen(),
        '/profile': (context) => ProfileScreen(),
        '/historyRepair': (context) => const HistoryRepair(),
        '/createGroup': (context) => const CreateGroup(),
      },
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
    );
  }
}
