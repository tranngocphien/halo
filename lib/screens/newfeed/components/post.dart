import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';
import 'package:halo/models/post.dart';

import '../../../constants.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({
    Key? key, required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        Navigator.pushNamed(context, "/postdetail");

      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ProfileAvatar(),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${post.username}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Row(children: [
                          Text(
                            "10 phút",
                            style:
                                TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.public,
                            color: Colors.grey[500],
                            size: 12,
                          )
                        ])
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
                ],
              ),
              SizedBox(
                height: 4,
              ),
              post.content == null? Container():
              Text(
                "${post.content}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Image.asset("assets/images/profile_avatar.jpg"),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle
                    ),
                    child: Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.thumb_up),
                      Icon(Icons.comment),
                      Icon(Icons.share)
                    ],

                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
