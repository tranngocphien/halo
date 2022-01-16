// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:halo/data/data.dart';
import 'package:halo/screens/profile/change_password_screen.dart';
import 'package:halo/screens/profile/update_profile_screen.dart';
import 'package:get/get.dart';
import 'package:halo/screens/profile/user_block_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'controller/profile_controller.dart';

class ProfileSetting extends StatelessWidget {
  final String username;
  const ProfileSetting({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

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
            title: Text('Danh sách bạn bè đã chặn'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserBlockScreen()));
            },
          ),
          ListTile(
            title: Text('Đổi ảnh đại diện'),
            onTap: () async {
              final pickedFileList =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFileList != null) {
                profileController.changeAvatar(pickedFileList, true);
              }
            },
          ),
          ListTile(
            // ignore: prefer_const_constructors
            title: Text('Đổi ảnh bìa'),
            onTap: () async {
              final pickedFileList =
                  await ImagePicker().pickMultiImage();
              if (pickedFileList != null) {
                profileController.changeAvatar(pickedFileList[0], false);
              }
            },
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
            onTap: () async{
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              prefs.remove('userId');
              Get.delete<ProfileController>();
              prefs.clear();
              SearchData.cached_chat.clear();
              SearchData.friendList.clear();
              SearchData.groupChatList.clear();
              SearchData.searched_chat.clear();
              SearchData.searched_word.clear();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
