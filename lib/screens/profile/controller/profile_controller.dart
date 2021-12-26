import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:halo/models/gender.dart';
import 'package:halo/models/models.dart';
import 'package:halo/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../constants.dart';
import 'package:image_picker/image_picker.dart';


class ProfileController extends GetxController {
  var isLoading = true.obs;
  var userInfo = Rx<UserInfo?>(null);
  var dob = DateTime.now().obs;
  var posts = List<PostModel>.empty(growable: true).obs;
  var gender = Gender.male.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    isLoading.value = true;
    getUserInfo();
    getListUserPost();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> getUserInfo() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    var response = await dio.get('/users/show');
    userInfo.value = UserInfo.fromJson(response.data['data']);

  }

  Future<void> getListUserPost() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    var response = await dio.get('/posts/list');
    if (response.statusCode == 200) {
      posts.value = (response.data['data'] as List).map((e) => PostModel.fromMap(e)).toList();
      for( PostModel postModel in posts.value){
        if(postModel.userId != prefs.getString('userId')){
          posts.value.remove(postModel);
        }
      }
      posts.reversed;
    } else {

    }

  }

  Future<void> updateInfo(String name, String address, Gender gender, String description) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final id = prefs.getString('userId') ?? "";

    Map data = {
      "username": name,
      "gender": gender == Gender.male ? "male": "female",
      "description": description,
      "address": address,
      "birthday": "",
      "city": "",
      "country": "",
    };

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    isLoading.value = true;
    var response = await dio.post("/users/edit", data: data);
    if(response.statusCode == 200){
      userInfo.value = UserInfo.fromJson(response.data['data']);
      print("success");
    }
    else {
      print("fail");
    }

  }

  Future<void> changeAvatar(XFile file, bool isAvatar) async{
    File imgFile = File(file.path);

    Map avatar = {
      "avatar" : "data:image/jpeg;base64," + base64.encode(imgFile.readAsBytesSync())
    };

    Map cover_img = {
      "avatar" : "data:image/jpeg;base64," + base64.encode(imgFile.readAsBytesSync())
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    var response = await dio.post("/users/edit", data: isAvatar ? avatar : cover_img);
    if(response.statusCode == 200){
      userInfo.value = UserInfo.fromJson(response.data['data']);
      print("success");
    }
    else {
      print("fail");
    }

  }



}
