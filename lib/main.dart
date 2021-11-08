import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/chats/chat_screen.dart';
import 'package:halo/screens/login/login_screen.dart';
import 'package:halo/screens/main/main_screen.dart';
import 'package:halo/screens/message/message_screen.dart';
import 'package:halo/screens/newfeed/newfeed_screen.dart';
import 'package:halo/screens/newpost/new_post_screen.dart';
import 'package:halo/screens/newpost/post_detail.dart';
import 'package:halo/screens/register/error_screen.dart';
import 'package:halo/screens/register/register_screen.dart';

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
        '/' : (context) => const WelcomeScreen(),
        '/login' : (context) => const LoginScreen(),
        '/register' : (context) => const RegisterScreen(),
        '/chatspage' : (context) => const ChatScreen(),
        '/message' : (context) => const MessageScreen(),
        '/newpost': (context) => const NewPost(),
        '/postdetail': (context) => const PostDetailScreen(),
        '/main' : (context) => MainScreen()
      },
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
    );
  }
}
