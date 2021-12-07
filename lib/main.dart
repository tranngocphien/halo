import 'package:flutter/material.dart';
import 'package:zalo/screen_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zalo App',
      theme: ThemeData(
        // primaryColor: Colors.lightBlue,
        // brightness: Brightness.dark,
        fontFamily: "OpenSans",
        primarySwatch: Colors.blue,
      ),
      home: const ScreenNav(),
    );
  }
}
