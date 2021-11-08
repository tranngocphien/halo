import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/contact/request_addfriend/components/request.dart';
import 'package:halo/screens/newfeed/components/body.dart';

class RequestsAddFriendsScreen extends StatelessWidget {
  const RequestsAddFriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search))],
        title: const Text("Lời mời kết bạn", style: TextStyle(fontSize: 25, color: Color(0xFFFFFFFF))),
      ),
      backgroundColor: backgroundColor,
      body: ListView(
        children: [
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),
          Request(),

        ],
      )
    );
  }
}