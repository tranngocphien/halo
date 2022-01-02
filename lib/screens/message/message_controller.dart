// import 'dart:convert';
// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:halo/models/chat.dart';
// import 'package:halo/models/message_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';

// import '../../constants.dart';

// class MessageController extends GetxController {
//   final String chatId;
//   MessageController({required this.chatId});

//   var chat = List<MessageModel>.empty(growable: true).obs;
//   final isLoading = true.obs;

//   @override
//   void onInit() async {
//     // TODO: implement onInit
//     isLoading.value = true;
//     await getMessages();
//     isLoading.value = false;
//     super.onInit();
//   }

//   Future<void> getMessages([chatTmp = null]) async {
//     if (chatTmp == null) {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? "";
//       final id = prefs.getString('userId') ?? "";

//       var dio = Dio(BaseOptions(
//         baseUrl: urlApi,
//         connectTimeout: 30000,
//         receiveTimeout: 30000,
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       ));
//       var response = await dio.get('/chats/getMessages/$chatId');
//       var messages = (response.data['data'] as List)
//           .map((e) => MessageModel.fromJson(e))
//           .toList();

//       chat.clear();
//       chat.addAll(messages.reversed);
//     } else {
//       chat = chatTmp.message;
//     }
//   }

//   Future<void> sendMessage({
//     required String content,
//     required String chatId,
//     required List<String> member,
//     required String name,
//     required String type,
//     required Chat chat,
//   }) async {
//     if (content == '') {
//       return;
//     }
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? "";
//     final id = prefs.getString('userId') ?? "";

//     Map data = {
//       "name": name,
//       "chatId": chatId,
//       "member": member,
//       "type": type,
//       "content": content
//     };

//     var dio = Dio(BaseOptions(
//       baseUrl: urlApi,
//       connectTimeout: 30000,
//       receiveTimeout: 30000,
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     ));
//     isLoading.value = true;
//     var response = await dio.post("/chats/send", data: data);
//     if (response.statusCode == 200) {
//       var message = response.data["message"];
//       chat.message.add(MessageModel.fromJson(message));
//       await getMessages(chat);
//     }
//     isLoading.value = false;
//   }
// }
