import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/screens/contact/components/friends.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);
  @override
  State<ContactScreen> createState() => _ContactState();
}

class _ContactState extends State<ContactScreen> {

  late Future<List<UFriend>> futureFriend;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureFriend = fetchFriends();
  }

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
            FutureBuilder<List<UFriend>>(
                future: futureFriend,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Friend(friend: snapshot.data![index]);
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


Future<List<UFriend>> fetchFriends() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  //print(token);
  final response = await http.post(Uri.parse('http://192.168.1.9:8000/api/v1/friends/list'), headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
  if (response.statusCode == 200) {
    return parseFriends(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<UFriend> parseFriends(String responseBody) {
  //print(responseBody);
  final parsed = json.decode(responseBody)["data"]["friends"].cast<Map<String, dynamic>>();
  //print(parsed);
  return parsed.map<UFriend>((json) =>UFriend.fromJson(json)).toList();
}

class UFriend{
  late String id;
  late String username;
  late String avatar;
  late String gender;

  UFriend(this.id, this.username, this.avatar, this.gender);
  factory UFriend.fromJson(Map<String, dynamic> json) {
    //print("fromMap");
    return UFriend(json["_id"], json["username"], json["avatar"]["_id"], json["gender"]);
  }
}
