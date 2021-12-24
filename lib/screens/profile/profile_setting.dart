// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nguyen Van Avatar"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Container(
          //   height: 50,
          //   // color: Colors.amber[600],
          //   child: Text('Entry A'),
          // ),
          // Container(
          //   height: 50,
          //   // color: Colors.amber[500],
          //   child: Text('Entry B'),
          // ),
          // Container(
          //   height: 50,
          //   // color: Colors.amber[100],
          //   child: Text('Entry C'),
          // ),
          ListTile(
            title: Text('Thông tin'),
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
          ),
          ListTile(
            title: Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
