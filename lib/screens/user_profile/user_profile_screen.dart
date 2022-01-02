import 'package:flutter/material.dart';

import '../../constants.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  final double coverHeight = 200;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Container();
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
          'url cover image',
          fit: BoxFit.cover,
        ),
        width: double.infinity,
        height: coverHeight,
      ),
    ],
  );

  Widget buildProfileImage() => Builder(builder: (context) {
    return InkWell(
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
            'url avatar'),
      ),
      onTap: () {
        // Navigator.pushNamed(context, '/profile_picture');
      },
    );
  });

  Widget buildIntro() => Column(
    children: [
      Text("Username",
          style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.all(10)),
          ],
        ),
      )
    ],
  );
}
