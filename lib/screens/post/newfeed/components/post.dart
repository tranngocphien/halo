import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';
import 'package:halo/models/post.dart';
import 'package:halo/screens/post/edit_post/edit_post_screen.dart';
import 'package:halo/screens/postdetail/post_detail.dart';
import 'package:halo/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';
import 'icon_interact.dart';

class PostItem extends StatefulWidget {
  final PostModel post;
  const PostItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  var isDeleted = false;
  var countLike;
  var isLiked = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countLike = widget.post.like.length;
    isLiked = widget.post.isLike;

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (isDeleted) {
      return Container();
    } else {
      return GestureDetector(
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: widget.post)),
          );
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
                    const ProfileAvatar(
                      size: 24,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.username,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Row(children: [
                            Text(
                              DateTimeConverter.durationToNow(widget.post.createAt),
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
                    ),
                    IconButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getString('userId');
                          if(userId == widget.post.userId){
                            buildShowOwnModalBottomSheet(context);
                          }
                          else {
                            buildShowFriendModalBottomSheet(context);
                          }

                        },
                        icon: const Icon(Icons.more_horiz))
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                if (widget.post.content == null)
                  Container()
                else
                  Text(
                    widget.post.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(
                  height: 8,
                ),
                widget.post.image.isNotEmpty
                    ? GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: widget.post.image
                            .map((e) => Image.network("${urlFiles}/${e.name}"))
                            .toList(),
                      )
                    : Container(),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: isLiked ?primaryColor :Colors.grey[500], shape: BoxShape.circle),
                      child: GestureDetector(
                        onTap: (){
                          likePost(widget.post.id).then((value) {
                            if(value.statusCode == 200){
                              setState(() {
                                isLiked = !isLiked;
                                if(isLiked == true){
                                  countLike = countLike + 1;
                                }
                              });
                            }
                          });

                        },
                        child: const Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${countLike ?? 0}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.grey[500], shape: BoxShape.circle),
                      child: const Icon(
                        Icons.messenger_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.post.countComments}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<dynamic> buildShowOwnModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
            padding: EdgeInsets.all(8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          deletePost(widget.post.id, context).then((value) {
                            Navigator.pop(context);
                            if (value.statusCode == 200) {
                              setState(() {
                                isDeleted = true;
                              });
                              showSnackBar("Xóa thành công");
                            } else {
                              var jsonResponse = json.decode(value.body);
                              showSnackBar(jsonResponse["message"]);
                            }
                          });
                        },
                        child: const Text(
                          "Xóa bài viết",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditPostScreen(post: widget.post)),
                          );
                        },
                        child: const Text(
                          "Sửa bài viết",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )),
                  ],
                ),
                const Divider(
                  thickness: 2,
                )
              ],
            ));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: whiteColor.withOpacity(1.0),
    );
  }

  Future<dynamic> buildShowFriendModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
            padding: EdgeInsets.all(8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.report_problem),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Báo cáo bài viết",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          deletePost(widget.post.id, context).then((value) {
                            Navigator.pop(context);
                            if (value.statusCode == 200) {
                              setState(() {
                                isDeleted = true;
                              });
                              showSnackBar("Xóa thành công");
                            } else {
                              var jsonResponse = json.decode(value.body);
                              showSnackBar(jsonResponse["message"]);
                            }
                          });
                        },
                        child: const Text(
                          "Chặn người dùng",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )),
                  ],
                ),
              ],
            ));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: whiteColor.withOpacity(1.0),
    );
  }


  void showSnackBar(String content) {
    final snackbar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<http.Response> deletePost(String postId, BuildContext context) async {
    var url = "${urlApi}/posts/delete/${postId}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    return await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
  }

  Future<http.Response> reportPost(String postId) async {
    var url = "${urlApi}/postReport/create/${postId}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    return await http.post(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
  }

  Future<http.Response> likePost(String postId) async {
    var url = "${urlApi}/postLike/action/${postId}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final userId = prefs.getString('userId');
    Map data = {
      'userId': userId
    };
    return await http.post(Uri.parse(url),body: data, headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
  }
}
