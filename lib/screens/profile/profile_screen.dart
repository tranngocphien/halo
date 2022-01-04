// import 'package:flutter/material.dart';
// import 'package:halo/constants.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         children: [
//           Container(
//             width: size.width,
//             height: 300,
//             // decoration: const BoxDecoration(
//             //     image: DecorationImage(
//             //         image: AssetImage("assets/images/profile_avatar.jpg"),
//             //         fit: BoxFit.fill)),

//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Positioned(
//                     top: 0,
//                     child: Image.network(
//                       "${urlFiles}/defaul_cover_image.jpg",
//                       height: 270,
//                       width: size.width,
//                       fit: BoxFit.fill,
//                     )),
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     height: 150,
//                     width: 150,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                       image: DecorationImage(image: NetworkImage("${urlFiles}/avatar_2.png"))
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Column(
//             children: [

//             ],
//           )
//         ],
//       )),
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/post/newfeed/components/post.dart';
import 'package:halo/screens/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:halo/screens/profile/profile_setting.dart';

TextEditingController _controller =
    TextEditingController(text: "Nhấn để đổi trạng thái");
bool _isEnable = false;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final double coverHeight = 200;
  final double profileHeight = 144;

  final profileController = Get.put(ProfileController());

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ảnh đại diện"),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        Text("Xem ảnh đại diện"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        Text("Chụp ảnh mới"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.landscape,
                            color: Colors.blue,
                          ),
                        ),
                        Text("Chọn ảnh từ thiết bị"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: profileController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Obx(() => ListView(
                    // padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                    children: <Widget>[
                      buildTop(),
                      buildIntro(),
                      ...profileController.posts.value
                          .map((e) => PostItem(post: e))
                    ])));
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
              '$urlFiles/${profileController.userInfo.value!.coverImage}',
              fit: BoxFit.cover,
            ),
            width: double.infinity,
            height: coverHeight,
          ),
          Button(
            username: profileController.userInfo.value!.username,
          )
        ],
      );

  Widget buildProfileImage() => Builder(builder: (context) {
        return InkWell(
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: NetworkImage(
                '$urlFiles/${profileController.userInfo.value!.avatar}'),
          ),
          onTap: () {
            // Navigator.pushNamed(context, '/profile_picture');
            createAlertDialog(context);
          },
        );
      });

  Widget buildIntro() => Column(
        children: [
          Text(profileController.userInfo.value!.username,
              style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(profileController.userInfo.value!.description)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Love(),
                Padding(padding: EdgeInsets.all(10)),
                Comment(),
              ],
            ),
          )
        ],
      );
}

class Button extends StatelessWidget {
  final String username;
  const Button({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      child: IconButton(
        icon: Icon(
          Icons.more_horiz,
          size: 36,
        ),
        color: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileSetting(
                        username: username,
                      )));
          // Navigator.pushNamed(context, '/newpost');
          // print("Hello");
        },
        // size: 40,
      ),
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Container(
          height: 80,
          color: Colors.pink[50],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      color: Colors.yellow[900],
                    ),
                    Text("  Bình luận nhiều (1)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text("Bài viết nhiều bình luận nhất")
            ],
          ),
        ));
  }
}

class Love extends StatelessWidget {
  const Love({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Container(
          height: 80,
          color: Colors.pink[50],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                    Text("  Yêu thích nhất (1)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text("Ảnh được thả tim nhiều nhất")
            ],
          ),
        ));
  }
}
