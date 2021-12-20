import 'dart:convert';
import 'dart:io';

import 'package:halo/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'package:halo/constants.dart';

class PostDetailController extends GetxController {
  var comments = List<CommentModel>.empty(growable: true).obs;

  @override
  void onInit() {
    // TODO: implement onInit
  }

  void mockComments() async {}
}

Future<List<CommentModel>> fetchComment(String postId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  var response = await http.get(
      Uri.parse("${urlApi}/postComment/list/${postId}"),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});

  if (response.statusCode == 200) {
    final parsed =
        json.decode(response.body)["data"].cast<Map<String, dynamic>>();
    return parsed
        .map<CommentModel>((json) => CommentModel.fromMap(json))
        .toList();
  } else {
    throw Exception('Failed to load post');
  }
}
