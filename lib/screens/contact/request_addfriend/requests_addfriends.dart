import 'package:flutter/material.dart';
import 'package:halo/screens/contact/request_addfriend/components/request.dart';
import 'package:halo/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:halo/screens/profile/profile_screen.dart';
import 'package:halo/screens/chats/chat_screen.dart';
import 'package:halo/screens/contact/contact_screen.dart';

class RequestsAddFriendsScreen extends StatefulWidget {
  const RequestsAddFriendsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsAddFriendsScreen> createState() => _RequestAddFriend();
}

class _RequestAddFriend extends State<RequestsAddFriendsScreen> {
  late Future<List<RQFriend>> futureRQFriend;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureRQFriend = fetchRQFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: const Text("Lời mời kết bạn",
            style: TextStyle(fontSize: 25, color: Color(0xFFFFFFFF))),
      ),
      backgroundColor: backgroundColor,
      body: Column(children: [
        FutureBuilder<List<RQFriend>>(
            future: futureRQFriend,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Request(rqFriend: snapshot.data![index]);
                      }),
                );
              }
              return Center(child: CircularProgressIndicator());
            })
      ]),
    );
  }
}

Future<List<RQFriend>> fetchRQFriends() async {
  //print("request add friend");
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  //print(token);
  Map data = {'userId': prefs.getString('userId') ?? ""};
  //print(data);
  final response = await http.post(
      Uri.parse('${urlApi}/friends/get-requested-friend'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'},
      body: data);
  //print(response);
  if (response.statusCode == 200) {
    return parseFriends(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<RQFriend> parseFriends(String responseBody) {
  //print(responseBody);
  final parsed =
      json.decode(responseBody)["data"]["friends"].cast<Map<String, dynamic>>();
  //print(parsed);
  return parsed.map<RQFriend>((json) => RQFriend.fromJson(json)).toList();
}

class RQFriend {
  late String id;
  late String username;
  late String avatar;
  late String gender;

  RQFriend(this.id, this.username, this.avatar, this.gender);
  factory RQFriend.fromJson(Map<String, dynamic> json) {
    print("fromMap");
    return RQFriend(
        json["_id"], json["username"], json["avatar"]["_id"], json["gender"]);
  }
}
