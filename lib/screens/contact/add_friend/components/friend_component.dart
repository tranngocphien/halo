import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/models/models.dart';
import 'package:get/get.dart';
import 'package:halo/screens/contact/controller/friend_controller.dart';
import 'package:halo/screens/profile/userProfile/user_profile_screen.dart';

import '../../../../constants.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class FriendComponent extends StatefulWidget {
  final UserInfo friend;

  const FriendComponent({Key? key, required this.friend}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Friend(friend);
}

class _Friend extends State<FriendComponent> {
  UserInfo friend;
  _Friend(this.friend);

  String textButton = "Kết bạn";
  Color colorButton = const Color(0xFF035DFD);
  FriendController friendController = Get.find();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfileScreen(userInfo: friend)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('$urlFiles/${friend.avatar}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child:
                          Text(friend.username, style: const TextStyle(fontSize: 23)),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: friendController.checkFriend(friend.id)
                        ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: whiteColor,
                            primary: const Color(0xc8006d01),
                            shadowColor: const Color(0xc8c8c8c8),
                            fixedSize: const Size(90, 35),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          onPressed: (){},
                          child: Text("Bạn bè"))
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: whiteColor,
                          primary: colorButton,
                          shadowColor: const Color(0xc8c8c8c8),
                          fixedSize: const Size(90, 35),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();

                          final token = prefs.getString('token') ?? "";

                          String userId = prefs.getString('userId') ?? "";

                          //print(token);
                          Map data = {"user_id": friend.id, "userId": userId};

                          print(data);

                          final response = await http.post(
                              Uri.parse('${urlApi}/friends/set-request-friend'),
                              headers: {
                                HttpHeaders.authorizationHeader: 'Bearer $token'
                              },
                              body: data);
                          int code = response.statusCode;

                          print(response.body);

                          if (code == 200) {
                            setState(() {
                              textButton = "Đã gửi";
                              colorButton = const Color(0xc8c8c8c8);
                            });
                          }
                        },
                        child: Text(textButton),
                      ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
