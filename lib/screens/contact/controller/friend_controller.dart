import 'package:get/get.dart';
import 'package:halo/models/models.dart';
import 'package:halo/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../constants.dart';

class FriendController extends GetxController {

  var listFriend = List<UserInfo>.empty(growable: true).obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    getListFriend();
    // getListUserPost();
    super.onInit();
  }

  Future<void> getListFriend() async {
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
    var response = await dio.post('/friends/list');
    if (response.statusCode == 200) {
      listFriend.clear();
      listFriend.value = (response.data['data']['friends'] as List).map((e) => UserInfo.fromJson(e)).toList();
    } else {

    }
  }

  bool checkFriend(String userId) {
    for(UserInfo userInfo in listFriend) {
      if (userInfo.id == userId) return true;
    }
    return false;
  }
}
