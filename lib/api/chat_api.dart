import 'dart:convert';
import 'dart:io';

import 'package:halo/constants.dart';
import 'package:halo/data/search_data.dart';
import 'package:halo/models/chat.dart';
import 'package:halo/models/message_model.dart';
import 'package:halo/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<Chat>> fetchChats() async {
  List<Chat> result, res;
  if (SearchData.cached_chat.isEmpty) {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? "";

    final response = await http.get(Uri.parse('$urlApi/chats/getChats'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      result = parseChats(response.body);
      SearchData.cached_chat = await result;
      res = result.where((element) => element.message.isNotEmpty).toList();
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  } else {
    res = SearchData.cached_chat
        .where((element) => element.message.isNotEmpty)
        .toList();
  }
  res.sort((chat1, chat2) {
    final lastMessage1 = chat1.message[chat1.message.length - 1];
    final lastMessage2 = chat2.message[chat2.message.length - 1];

    return lastMessage1.createdAt.compareTo(lastMessage2.createdAt);
  });
  return res.reversed.toList();
}

List<Chat> parseChats(dynamic responseBody) {
  final chats = json.decode(responseBody)["chat"].cast<Map<String, dynamic>>();

  List<Chat> result = chats.map<Chat>((json) => Chat.fromJson(json)).toList();
  print("Chat ID");
  for(Chat chat in result){
    print(chat.id);
  }
  return result;
}

dynamic createGroupChat(info) async {
  var member = info["member"];
  for (var i = 0; i < SearchData.cached_chat.length; i++) {
    Chat chat = SearchData.cached_chat[i];
    if (chat.partner is UserInfo) {
      continue;
    } else {
      var chatMem = chat.getMember();
      member.sort();
      chatMem.sort();
      var j = 0;
      for (; j < member.length; j++) {
        if (member[j] != chatMem[j]) break;
      }
      if (j == member.length) return chat;
    }
  }
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";
  final infoEncode = json.encode(info);
  final response = await http.post(Uri.parse('$urlApi/chats/createGroupChat'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Content-Type": "application/json"
      },
      body: infoEncode);

  if (response.statusCode == 200) {
    final result = await json.decode(response.body)["data"];
    SearchData.groupChatList.add(result);
    Chat groupChat = Chat.fromJson(result);
    SearchData.cached_chat.add(groupChat);
    // SearchData.cached_chat.add
    return groupChat;
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

Future<void> sendMessage({
  required String content,
  required Chat chat,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";

  var info = {
    "name": chat.chatName,
    "chatId": chat.id,
    "member": "",
    "type": chat.partner is UserInfo ? 'PRIVATE_CHAT' : 'GROUP_CHAT',
    "content": content,
  };
  final infoEncode = json.encode(info);
  final response = await http.post(Uri.parse('$urlApi/chats/send'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Content-Type": "application/json"
      },
      body: infoEncode);

  if (response.statusCode == 200) {
    chat.message.add(MessageModel.fromJson(
        json.decode(response.body)["data"].cast<String, dynamic>()));
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}
