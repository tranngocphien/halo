import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';
import 'package:halo/screens/post/newfeed/components/post.dart';
import 'package:http/http.dart' as http;
import 'package:halo/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';


class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<PostModel>> futurePost;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    "halo",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2, vertical: kDefaultPadding),
            decoration: const BoxDecoration(color: whiteColor),
            child: Row(
              children: [
                const ProfileAvatar(size: 24,),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/newpost");
                    },
                    child: Text(
                      "B???n ??ang ngh?? g?? th???",
                      style: TextStyle(
                          fontSize: 20, color: Colors.black.withOpacity(0.5)),
                    ),
                  ),
                )),

              ],
            ),
          ),
          FutureBuilder<List<PostModel>>(
              future: futurePost,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return PostItem(post: snapshot.data![snapshot.data!.length - index - 1]);
                        }),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              })
        ],

      ),
    );
  }
}

Future<List<PostModel>> fetchPost() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  var response = await http.get(
      Uri.parse("${urlApi}/posts/list"),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body)["data"].cast<Map<String, dynamic>>();
    return parsed.map<PostModel>((json) => PostModel.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}
