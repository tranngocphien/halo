import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

import 'components/body.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      title: Text("Chat"),
      elevation: 0,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search))
      ],

    );
  }
}
