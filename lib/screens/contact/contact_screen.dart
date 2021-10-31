import 'package:flutter/material.dart';

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
        child: ListView(
          children: const [
            ListTile(
              title: Text("Ten nguoi dung"),
              leading: Icon(Icons.account_circle, size: 40,),
              subtitle: Text("So dien thoai"),
            ),
            ListTile(
              title: Text("Ten nguoi dung"),
              leading: Icon(Icons.account_circle, size: 40,),
              subtitle: Text("So dien thoai"),
            ),
            ListTile(
              title: Text("Ten nguoi dung"),
              leading: Icon(Icons.account_circle, size: 40,),
              subtitle: Text("So dien thoai"),
            ),
            ListTile(
              title: Text("Ten nguoi dung"),
              leading: Icon(Icons.account_circle, size: 40,),
              subtitle: Text("So dien thoai"),
            ),

          ],
        ),
      ),
    );
  }
}
