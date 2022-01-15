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
  var mostLike = Rx<PostModel?>(null);
  var mostComment = Rx<PostModel?>(null);
  var gender = Gender.male.obs;
  var userBlocked = List<UserInfo>.empty(growable: true).obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    isLoading.value = true;
    getUserInfo();
    // getListUserPost();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> updateUsesInfo() async {
    isLoading.value = true;
    await getUserInfo();
    // getListUserPost();
    isLoading.value = false;
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

    userBlocked.clear();

    for( String userId in userInfo.value!.blockedInbox){
      userBlocked.value.add(await getUserInfoById(userId));
    }

    getListUserPost(UserInfo.fromJson(response.data['data']).id);


  }

  Future<UserInfo> getUserInfoById(String userId) async{
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
    var response = await dio.get('/users/show/$userId');
    return UserInfo.fromJson(response.data['data']);

  }

  Future<void> getListUserPost(String userId) async {
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

    print("userId controller : "+userId);
    var response = await dio.get('/posts/list?userId=$userId');

    if (response.statusCode == 200) {
      posts.clear();
      posts.value = (response.data['data'] as List).map((e) => PostModel.fromMap(e)).toList();
      // if(posts.isNotEmpty){
      //   for( PostModel postModel in posts){
      //     if(postModel.userId != prefs.getString('userId')){
      //       posts.remove(postModel);
      //     }
      //   }
      // }
      posts.reversed;
      if(posts.isNotEmpty){
        mostComment.value = posts[0];
        mostLike.value = posts[0];
        for(PostModel postModel in posts){
          if(mostLike.value!.like.length < postModel.like.length){
            mostLike.value = postModel;
          }
          if(mostLike.value!.countComments < postModel.countComments){
            mostComment.value = postModel;
          }
        }

      }
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
      isLoading.value = false;
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
      "cover_img" : "data:image/jpeg;base64," + base64.encode(imgFile.readAsBytesSync())
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

  Future<void> unBlock(int index) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    Map data = {
      "user_id": userBlocked[index].id,
      "type": "0",
    };

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    await dio.post("/users/set-block-user", data: data);
    userBlocked.removeAt(index);

  }

  bool checkBlocked(String userId){
    for(String user in userInfo.value!.blockedInbox){
      if(user == userId){
        return true;
      }
    }
    return false;
  }



}
