import 'package:get/get.dart';
import 'package:halo/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

class MessageController extends GetxController {
  final String chatId;
  MessageController({required this.chatId});

  final chat = List<MessageModel>.empty(growable: true).obs;
  final isLoading = true.obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    isLoading.value = true;
    await getMessages();
    isLoading.value = false;
    super.onInit();
  }

  Future<void> getMessages() async {
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
    var response = await dio.get('/chats/getMessages/$chatId');
    var messages = (response.data['data'] as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();
    for (var element in messages) {
      element.isSender = (element.userInfo.id == id);
    }
    chat.addAll(messages);
  }

  Future<void> sendMessage({required String content, required String chatId,required String receivedId,required String name,String type = 'PRIVATE_CHAT'}) async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final id = prefs.getString('userId') ?? "";

    Map data = {
      "name": name,
      "chatId": chatId,
      "receivedId": receivedId,
      "member": "",
      "type": type,
      "content": content
    };

    var dio = Dio(BaseOptions(
      baseUrl: urlApi,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    var response = await dio.post("/chats/send", data: data);
    if(response.statusCode == 200){
      chat.add(MessageModel.fromJson(response.data['data']));
    }

  }
}
