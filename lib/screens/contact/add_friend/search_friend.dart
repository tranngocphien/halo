import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/screens/contact/add_friend/components/friend_component.dart';

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

   late Future<List<UFriend>> futureSearchFriend;

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

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: RaisedButton (
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        print(_phoneNumber.text);
                        setState(() {
                          futureSearchFriend = fetchSearchFriends(_phoneNumber.text);
                        });
                      },
                      child: Text("Tìm", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder<List<UFriend>>(
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
                  return Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ),
    );
  }

}

Future<List<UFriend>> fetchSearchFriends(String keyword) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";

  //print(token);
  Map data = {
    "keyword" : keyword
  };

  final response = await http.post(Uri.parse('http://192.168.1.9:8000/api/v1/users/search'), headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}, body: data);
  if (response.statusCode == 200) {
    return parseFriends(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<UFriend> parseFriends(String responseBody) {
  //print(responseBody);
  final parsed = json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<UFriend>((json) =>UFriend.fromJson(json)).toList();
}