import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/comment.dart';
import 'package:halo/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var contentController = TextEditingController();
  var countLike;
  late Future<List<Comment>> futureComment;

  @override
  void initState() {
      futureComment = fetchComment(widget.post.id);
      countLike = widget.post.like.length;
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Bình luận"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(
                              size: 24.0,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.post.username}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
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
                          ],
                        ),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.more_horiz))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${widget.post.content}",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // Image.asset("assets/images/profile_avatar.jpg"),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 1,
                    ),
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${countLike}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    //Text("Hãy là người đầu tiên bình luận"),
                    FutureBuilder<List<Comment>>(
                      future: futureComment,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Comment>? listComment = snapshot.data;
                          return Column(
                            children: [
                              ...listComment!.map((comment){
                                return CommentContent(comment: comment,);
                              } ).toList(),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        else {
                          return Text("Hãy là người đầu tiên bình luận");
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                            controller: contentController,
                            decoration: const InputDecoration(
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
                  IconButton(
                      onPressed: () {
                        commentPost(widget.post.id, contentController.text)
                            .then((response){
                              if(response.statusCode == 200){
                                print("Success");
                              }

                            });
                      },
                      icon: Icon(
                        Icons.send,
                        color: primaryColor,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CommentContent extends StatelessWidget {
  final Comment comment;
  const CommentContent({
    Key? key, required this.comment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ProfileAvatar(
            size: 16.0,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("${comment.username}", style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            Text(
              "${comment.content}",
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            )
          ],),

        ],
      ),
    );
  }
}

Future<http.Response> commentPost(String postId, String content) async {
  var url = "http://192.168.1.9:8000/api/v1/postComment/create/${postId}";
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  final userId = prefs.getString('userId');
  Map data = {
    'userId': userId,
    'content': content,
    'commentAnswered': ""
  };
  return await http.post(Uri.parse(url),
      body: data,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
}

Future<List<Comment>> fetchComment(String postId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  var response = await http.get(
      Uri.parse("http://192.168.1.9:8000/api/v1/postComment/list/${postId}"),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body)["data"].cast<Map<String, dynamic>>();
    return parsed.map<Comment>((json) => Comment.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}
