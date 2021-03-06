import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/screens/contact/contact_screen.dart';

class Friend extends StatelessWidget {
  final UFriend friend;

  const Friend({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/message");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile_avatar.jpg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(friend.username, style: TextStyle(fontSize: 23)),
                    ),
                  ],
                ),
              ),


            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(
                    onPressed: (){

                    },
                    icon: const Icon(Icons.call_outlined,size: 25, color: Color(0xFF767678)),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    onPressed: (){

                    },
                    icon: const Icon(Icons.video_call_outlined, size: 30, color: Color(0xFF767678)),
                  )
                )
              ],
            )

          ],
        ),
      ),
    );
  }

}