import 'package:flutter/material.dart';
import 'package:halo/main.dart';
import 'package:halo/screens/contact/components/friends.dart';
import 'package:halo/screens/login/login_screen.dart';
import 'package:halo/screens/main/main_screen.dart';

import '../../constants.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: Icon(Icons.search),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.person_add_alt_sharp))],
        title: const TextField(
        ),
      ),
      body: Container(

        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,"/requestsAddFriend");
                      },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 25, left: 10),
                      child: ListTile(
                        title: Text("Lời mời kết bạn", style: TextStyle(fontSize: 25),),
                        leading: Icon(Icons.people, size: 45, color: primaryColor),
                      ),
                    )
                  ),
                  GestureDetector(
                      onTap: () {

                        Navigator.pushNamed(context,"/requestsAddFriend");
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 25, left: 10),
                        child: ListTile(
                          title: Text("Bạn bè từ danh bạ", style: TextStyle(fontSize: 25),),
                          leading: Icon(Icons.contact_phone_rounded, size: 45, color: Colors.green),
                        ),
                      )
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                height: 10,
                width: 500,
                color: const Color(0x00c4c4c4)
              ),
            ),
            Container(
              child: Column (
                children: [
                  Friend(),
                  Friend(),
                  Friend(),
                  Friend(),
                  Friend(),
                  Friend(),
                ],
              )
            )


          ],
        ),
      ),
    );
  }
}
