import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: size.width,
            height: 300,
            // decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage("assets/images/profile_avatar.jpg"),
            //         fit: BoxFit.fill)),

            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    top: 0,
                    child: Image.network(
                      "${urlFiles}/defaul_cover_image.jpg",
                      height: 270,
                      width: size.width,
                      fit: BoxFit.fill,
                    )),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage("${urlFiles}/avatar_2.png"))
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [

            ],
          )
        ],
      )),
    );
  }
}
