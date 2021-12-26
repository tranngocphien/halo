import 'dart:convert';
import 'dart:io';

import 'package:halo/constants.dart';
import 'package:halo/data/search_data.dart';
import 'package:halo/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<Chat>> fetchChats() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token') ?? "";

  final response = await http.get(Uri.parse('$urlApi/chats/getChats'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  if (response.statusCode == 200) {
    return parseChats(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<Chat> parseChats(dynamic responseBody) {
  final chats = json.decode(responseBody)["chat"].cast<Map<String, dynamic>>();
  final parsed = [];
  for (var i = 0; i < chats.length; i++) {
    if (chats[i]["message"].isNotEmpty) {
      parsed.add(chats[i]);
    }
  }
  List<Chat> result = parsed.map<Chat>((json) => Chat.fromJson(json)).toList();
  result.sort((chat1, chat2) {
    final lastMessage1 = chat1.message[chat1.message.length - 1];
    final lastMessage2 = chat2.message[chat2.message.length - 1];

    return lastMessage1.createdAt.compareTo(lastMessage2.createdAt);
  });
  return result.reversed.toList();
}

dynamic createGroupChat(info) async {
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
    return SearchData.groupChatList[SearchData.groupChatList.length - 1];
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}
