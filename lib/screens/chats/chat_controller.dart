import 'package:get/get.dart';
import 'package:halo/models/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../constants.dart';

class ChatController extends GetxController {
  final isLoading = true.obs;
  final chats = List<ChatModel>.empty(growable: true);

  @override
  void onInit() async{
    // TODO: implement onInit
    isLoading.value = true;
    await getChats();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> getChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final id = prefs.getString('userId') ?? "";

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    var response = await dio.get('/chats/getMessaged');

    chats.addAll((response.data['data'] as List)
        .map((e) => ChatModel.fromJson(e))
        .toList());
  }
}
