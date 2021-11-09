import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:halo/screens/contact/request_addfriend/requests_addfriends.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../contact_screen.dart';


class Request extends StatelessWidget {
  final RQFriend rqFriend;
  const Request({Key? key, required this.rqFriend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/profile_avatar.jpg"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(rqFriend.username, style: TextStyle(fontSize: 20)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () async {
                      print("request add friend");
                      final prefs = await SharedPreferences.getInstance();

                      final token = prefs.getString('token') ?? "";
                      print(token);
                      Map data = {
                        'user_id' : rqFriend.id.toString(),
                        'userId': prefs.getString('userId') ?? "",
                        "is_accept" : "1"
                      };
                      print(data);
                      final response = await http.post(Uri.parse('http://192.168.1.9:8000/api/v1/friends/set-accept)'),
                          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
                          body: data);

                      print(response.body);


                    },
                    child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('Xác nhận', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: (){
                      print("addfiend");
                    },
                    child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: Color(0x00FFA0A2A3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('Xóa')
                    ),
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }

}

