import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class PostAPI {
  PostAPI._();

  static PostAPI instance = PostAPI._();

  Future<http.Response> deletePost(String postId) async {
    var url = "${urlApi}/posts/delete/${postId}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    return await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
  }

  Future<http.Response> reportPost(String postId, String subject, String detail) async {
    var url = "${urlApi}/postReport/create/${postId}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    Map data = {
      "subject": subject,
      "details": detail
    };
    return await http.post(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'}, body: data);
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