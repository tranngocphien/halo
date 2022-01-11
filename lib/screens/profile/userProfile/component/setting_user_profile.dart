// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:halo/models/models.dart';
import 'package:halo/screens/profile/change_password_screen.dart';
import 'package:halo/screens/profile/update_profile_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';

class SettingUserProfile extends StatefulWidget {
  final UserInfo userInfo;
  const SettingUserProfile({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<SettingUserProfile> createState() => _SettingUserProfileState();
}

class _SettingUserProfileState extends State<SettingUserProfile> {

  bool isBlock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userInfo.username),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: Text('Thông tin'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen()));
            },
          ),
          ListTile(
            title: Text('Đổi tên gợi nhớ'),
            onTap: () {},
          ),
          ListTile(
            // ignore: prefer_const_constructors
            title: Text('Đánh dấu bạn thân'),
            onTap: () {},
          ),
          Container(
            color: Colors.blue,
            height: 1,
          ),
          !isBlock ? ListTile(
            title: Text(
              'Chặn người này',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {

              final prefs = await SharedPreferences.getInstance();

              final token = prefs.getString('token') ?? "";

              String userId = prefs.getString('userId') ?? "";

              //print(token);
              Map data = {"user_id": widget.userInfo.id, "type": '0'};

              //print(data);

              final response = await http.post(
                  Uri.parse('${urlApi}/users/set-block-user'),
                  headers: {
                    HttpHeaders.authorizationHeader: 'Bearer $token'
                  },
                  body: data);
              int code = response.statusCode;
              print(response.body);

              if (code == 200) {
                setState(() {
                  isBlock = true;
                  SnackBar snackBar = SnackBar(
                    content: Text('Chặn ${widget.userInfo.username} thành công'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              } else {
                SnackBar snackBar = SnackBar(
                  content: Text('Bỏ chặn ${widget.userInfo.username} thất bại'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ) : ListTile(
            title: Text(
              'Bỏ chặn người này',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {

              final prefs = await SharedPreferences.getInstance();

              final token = prefs.getString('token') ?? "";

              String userId = prefs.getString('userId') ?? "";

              //print(token);
              Map data = {"user_id": widget.userInfo.id, "type": '1'};

              //print(data);

              final response = await http.post(
                  Uri.parse('${urlApi}/users/set-block-user'),
                  headers: {
                    HttpHeaders.authorizationHeader: 'Bearer $token'
                  },
                  body: data);
              int code = response.statusCode;
              print(response.body);

              if (code == 200) {
                setState(() {
                  isBlock = false;
                  SnackBar snackBar = SnackBar(
                    content: Text('Bỏ chặn ${widget.userInfo.username} thành công'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              } else {
                SnackBar snackBar = SnackBar(
                  content: Text('Bỏ chặn ${widget.userInfo.username} thất bại'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          )
          ,
        ],
      ),
    );
  }
}
