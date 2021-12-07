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
  final PostModel post;
  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var contentController = TextEditingController();
  var countLike;
  late Future<List<CommentModel>> futureComment;

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
        title: const Text("Bình luận"),
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
                            const ProfileAvatar(
                              size: 24.0,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.username,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                Row(children: [
                                  Text(
                                    "10 phút",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 12),
                                  ),
                                  const SizedBox(
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
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${widget.post.content}",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    widget.post.image.isNotEmpty?
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: widget.post.image
                          .map((e) => Image.network("${urlFiles}/${e.name}"))
                          .toList(),
                    ): Container(),
                    // Image.asset("assets/images/profile_avatar.jpg"),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.thumb_up,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${countLike}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    //Text("Hãy là người đầu tiên bình luận"),
                    FutureBuilder<List<CommentModel>>(
                      future: futureComment,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<CommentModel>? listComment = snapshot.data;
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
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: SafeArea(
              child: Row(
                children: [
                  const SizedBox(
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
                          const Icon(Icons.sentiment_satisfied_outlined),
                          const SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                            controller: contentController,
                            decoration: const InputDecoration(
                              hintText: "Nhập bình luận",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 18),
                          )),
                          const Icon(Icons.image)
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        commentPost(widget.post.id, contentController.text)
                            .then((response){
                              if(response.statusCode == 200){
                                print("Success");
                                FocusScope.of(context).requestFocus(FocusNode());
                                contentController.text = "";
                              }

                            });
                      },
                      icon: const Icon(
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
  final CommentModel comment;
  const CommentContent({
    Key? key, required this.comment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const ProfileAvatar(
            size: 16.0,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(comment.username, style: const TextStyle(
              fontWeight: FontWeight.bold
            ),),
            Text(
              comment.content,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            )
          ],),

        ],
      ),
    );
  }
}

Future<http.Response> commentPost(String postId, String content) async {
  var url_comment = urlApi + "/postComment/create/${postId}";
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  final userId = prefs.getString('userId');
  Map data = {
    'userId': userId,
    'content': content,
    'commentAnswered': ""
  };
  return await http.post(Uri.parse(url_comment),
      body: data,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
}

Future<List<CommentModel>> fetchComment(String postId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  var response = await http.get(
      Uri.parse("${urlApi}/postComment/list/${postId}"),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body)["data"].cast<Map<String, dynamic>>();
    return parsed.map<CommentModel>((json) => CommentModel.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}
