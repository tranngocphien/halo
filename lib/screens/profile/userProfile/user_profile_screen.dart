import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/post.dart';
import 'package:halo/models/user_info.dart';
import 'package:halo/screens/contact/controller/friend_controller.dart';
import 'package:halo/screens/post/newfeed/components/post.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'component/setting_user_profile.dart';

class UserProfileScreen extends StatefulWidget {
  final UserInfo userInfo;
  UserProfileScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final double coverHeight = 200;

  final double profileHeight = 144;

  String textButton = "Gửi lời mời";

  String textButtonFriend = "Bạn bè";

  Color colorButton = const Color(0xFF035DFD);

  FriendController friendController = Get.find();

  late Future<List<PostModel>> futurePost;

  var isLoading = false;

  bool isFriend = false;

  @override
  Widget build(BuildContext context) {
    futurePost = fetchPost(widget.userInfo.id);
    isFriend = friendController.checkFriend(widget.userInfo.id);
    return Scaffold(
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          // padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
            children: <Widget>[
              buildTop(),
              buildIntro(),
              FutureBuilder<List<PostModel>>(
                  future: futurePost,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return PostItem(
                                  post: snapshot
                                      .data![snapshot.data!.length - index - 1]);
                            }),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
            ]));
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: buildCoverImage()),
          Positioned(top: top, child: buildProfileImage()),
        ]);
  }

  Widget buildCoverImage() => Stack(
    children: [
      Container(
        color: Colors.grey,
        child: Image.network(
          '$urlFiles/${widget.userInfo.coverImage}',
          fit: BoxFit.cover,
        ),
        width: double.infinity,
        height: coverHeight,
      ),
      Button(
        userInfo: widget.userInfo,
      ),
      IconButton(
        alignment: Alignment.topLeft,
        onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
      ),
    ],
  );

  Widget buildProfileImage() => Builder(builder: (context) {
    return InkWell(
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
            '$urlFiles/${widget.userInfo.avatar}'),
      ),
      onTap: () {
        // Navigator.pushNamed(context, '/profile_picture');
      },
    );
  });

  Widget buildIntro() => Column(
    children: [
      Text(widget.userInfo.username,
          style: const TextStyle(fontSize: 25), textAlign: TextAlign.center),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: isFriend ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: whiteColor,
                  primary: colorButton,
                  shadowColor: const Color(0xc8c8c8c8),
                  fixedSize: const Size(90, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {  },
                child: Text(textButtonFriend),
              ) : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: whiteColor,
                  primary: colorButton,
                  shadowColor: const Color(0xc8c8c8c8),
                  fixedSize: const Size(120, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  final token = prefs.getString('token') ?? "";

                  String userId = prefs.getString('userId') ?? "";

                  //print(token);
                  Map data = {"user_id": widget.userInfo.id, "userId": userId};

                  //print(data);

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
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Container(
              child: isFriend ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary:  const Color(0xc8c8c8c8),
                  shadowColor: const Color(0xC8c8c8c8),
                  fixedSize: const Size(110, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  final token = prefs.getString('token') ?? "";

                  String userId = prefs.getString('userId') ?? "";

                  //print(token);
                  Map data = {"user_id": widget.userInfo.id, "userId": userId};

                  //print(data);

                  final response = await http.post(
                      Uri.parse('${urlApi}/friends/set-remove'),
                      headers: {
                        HttpHeaders.authorizationHeader: 'Bearer $token'
                      },
                      body: data);
                  int code = response.statusCode;
                  print(response.body);

                  if (code == 200) {
                    setState(() {
                      isFriend = false;
                      friendController.getListFriend();
                      SnackBar snackBar = SnackBar(
                        content: Text('Xóa thành công ${widget.userInfo.username} khỏi danh sách bạn bè'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                },
                child: Text("Hủy kêt bạn"),
              ) : Container(),
            ),
          ],
        ),
      )
    ],
  );
}

class Button extends StatelessWidget {
  final UserInfo userInfo;
  const Button({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      child: IconButton(
        icon: const Icon(
          Icons.more_horiz,
          size: 36,
        ),
        color: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>SettingUserProfile(
                    userInfo: userInfo,
                  )));
          // Navigator.pushNamed(context, '/newpost');
          // print("Hello");
        },
        // size: 40,
      ),
    );
  }
}

Future<List<PostModel>> fetchPost(String userId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  var response = await http.get(Uri.parse("$urlApi/posts/list?userId=$userId"),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

  if (response.statusCode == 200) {
    final parsed =
    json.decode(response.body)["data"].cast<Map<String, dynamic>>();
    return parsed.map<PostModel>((json) => PostModel.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}

Future<UserInfo> getUserInfoFuture(String userId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  var response = await http.get(Uri.parse("$urlApi/users/show/$userId"),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

  if (response.statusCode == 200) {
    final parsed =
    json.decode(response.body)["data"].cast<Map<String, dynamic>>();
    return parsed.map<UserInfo>((json) => UserInfo.fromJson(json));
  } else {
    throw Exception('Failed to load post');
  }

}
