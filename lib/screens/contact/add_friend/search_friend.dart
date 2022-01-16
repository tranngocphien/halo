import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/models/user_info.dart';
import 'package:halo/screens/contact/add_friend/components/friend_component.dart';
import 'package:halo/screens/contact/controller/friend_controller.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../contact_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchFriendScreen extends StatefulWidget {
  const SearchFriendScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchFriend();

}

class _SearchFriend extends State<SearchFriendScreen> {
  final _phoneNumber = TextEditingController();

  bool loading = false;

   late Future<List<UserInfo>> futureSearchFriend;

   FriendController friendController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureSearchFriend = fetchSearchFriends("0000000000000000");
  }

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 15),
              child: Text("Thêm bạn bằng số điện thoại", style: TextStyle(fontSize: 17),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumber,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Nhập số điện thoại"
                      ),
                      textAlign: TextAlign.center,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: RaisedButton (
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        friendController.getListFriend();
                        setState(() {
                          loading = true;
                        });
                        futureSearchFriend = fetchSearchFriends(_phoneNumber.text).whenComplete(() => setState(() {
                          loading = false;
                        }));
                          // setState(() {
                          //   futureSearchFriend = future;
                          //   //loading = false;
                          // });
                      },
                      child: const Text("Tìm", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: loading == true ? const Center(child: CircularProgressIndicator()) : FutureBuilder<List<UserInfo>>(
                  future: futureSearchFriend,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return FriendComponent(friend: snapshot.data![index]);
                            }),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            )
          ],
        ),
      ),
    );
  }

}

Future<List<UserInfo>> fetchSearchFriends(String keyword) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";

  //print(token);
  Map data = {
    "keyword" : keyword
  };

  final response = await http.post(Uri.parse('${urlApi}/users/search'), headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}, body: data);
  if (response.statusCode == 200) {
    return parseFriends(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<UserInfo> parseFriends(String responseBody) {
  //print(responseBody);
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<UserInfo>((json) =>UserInfo.fromJson(json)).toList();
}