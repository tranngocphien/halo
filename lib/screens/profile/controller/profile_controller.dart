import 'package:get/get.dart';
import 'package:halo/models/models.dart';
import 'package:halo/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import '../../../constants.dart';


class ProfileController extends GetxController {
  var isLoading = true.obs;
  var userInfo = Rx<UserInfo?>(null);
  var posts = List<PostModel>.empty(growable: true).obs;

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



}