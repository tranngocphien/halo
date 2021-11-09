import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchFriendScreen extends StatefulWidget {
  const SearchFriendScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchFriend();

}

class _SearchFriend extends State<SearchFriendScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          //actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search))],
          title: const Text("Thêm bạn", style: TextStyle(fontSize: 25, color: Color(0xFFFFFFFF))),
        ),
    );
  }

}