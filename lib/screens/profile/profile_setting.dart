// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:halo/screens/profile/change_password_screen.dart';
import 'package:halo/screens/profile/update_profile_screen.dart';

class ProfileSetting extends StatelessWidget {
  final String username;
  const ProfileSetting({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
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
            title: Text('Đổi ảnh đại diện'),
          ),
          ListTile(
            // ignore: prefer_const_constructors
            title: Text('Đổi ảnh bìa'),
          ),
          ListTile(
            title: Text('Cập nhật giới thiệu bản thân'),
          ),
          Container(
            color: Colors.blue,
            height: 1,
          ),
          ListTile(
            title: Text(
              'Cài đặt',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          ListTile(
            title: Text('Đổi mật khẩu'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
            },
          ),
          ListTile(
            title: Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
