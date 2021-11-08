import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';
import 'package:halo/constants.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Bình luận"),
      ),
      body: Column(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            "Phiên",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Row(children: [
                            Text(
                              "10 phút",
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
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
                  height: 16,
                ),
                Text(
                  "Chào các bạn",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 16,
                ),
                Image.asset("assets/images/profile_avatar.jpg"),
                SizedBox(
                  height: 8,
                ),
                Divider(thickness: 1,),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("12", style: TextStyle( fontSize: 16),),
                  ],
                ),
                Divider(thickness: 1,),
                Text("Hãy là người đầu tiên bình luận")
              ],
            ),
          )),
          Container(
            padding: EdgeInsets.all(kDefaultPadding / 2),
            child: SafeArea(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.sentiment_satisfied_outlined),
                          SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                              hintText: "Nhập bình luận",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 18),
                          )),
                          Icon(Icons.image)
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.send,
                    color: primaryColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
