import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/message//components/body.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(),
          SizedBox(width: kDefaultPadding,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tên người dùng", style: TextStyle(fontSize: 14),),
              Text("Đang hoạt động", style: TextStyle(fontSize: 12),)
            ],
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () { },icon: Icon(Icons.videocam),),
        IconButton(onPressed: (){}, icon: Icon(Icons.call))
      ],
    );
  }
}
