import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  const ProfileAvatar({Key? key,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size,
          backgroundImage: NetworkImage("http://192.168.1.9:8000/files/avatar_2.png")
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: whiteColor
              )
            ),

          ),
        )
      ],
    );
  }
}
