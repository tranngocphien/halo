import 'dart:convert';
import 'dart:io';

import 'package:halo/constants.dart';
import 'package:halo/data/search_data.dart';
import 'package:halo/models/chat.dart';
import 'package:halo/models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tiengviet/tiengviet.dart';

Future<List<Map<String, dynamic>>> fetchFriends() async {
  if (SearchData.friendList.isEmpty) {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final response = await http.post(Uri.parse('$urlApi/friends/list'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    if (response.statusCode == 200) {
      final result = json
          .decode(response.body)["data"]["friends"]
          .cast<Map<String, dynamic>>();
      SearchData.friendList = await result;
      return result;
    } else {
      throw Exception('Unable to fetch friend list from the REST API');
    }
  }
  return SearchData.friendList;
}

Future<List<Map<String, dynamic>>> fetchGroupChats() async {
  if (SearchData.groupChatList.isEmpty) {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";
    final response = await http.post(Uri.parse('$urlApi/chats/getGroupChats'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)["chat"].cast<Map<String, dynamic>>();
      // SearchData.groupChatList = await result.map((groupChat) {
      //   return Chat.fromJson(result);
      // }).toList();
      SearchData.groupChatList = await result;
      return result;
    } else {
      throw Exception('Unable to fetch group chat list from the REST API');
    }
  }
  return SearchData.groupChatList;
}

Future<List<Chat>> fetchChatsMessages(searchValue) async {
  // Danh sách các index trong các Chat
  final List<Chat> chatList = SearchData.cached_chat;

  return chatList;
}

Future<List<dynamic>> fetchSearchData(searchValue) async {
  List<List<dynamic>> parsed_result = [];

  final friendList = await fetchFriends();
  final groupChatList = await fetchGroupChats();
  final result = await fetchChatsMessages(searchValue);

  parsed_result.add(parseFriends(friendList, searchValue));
  parsed_result.add(parseGroupChats(groupChatList, searchValue));
  parsed_result.add(parseMessage(result, searchValue));

  return parsed_result;
}

List<UserInfo> parseFriends(final respond, searchValue) {
  List<UserInfo> parsedMatch = [];

  List<String> splitedSearchText =
      TiengViet.parse(searchValue.toLowerCase()).split(" ");

  for (var i = 0; i < respond.length; i++) {
    var username = TiengViet.parse(respond[i]["username"].toLowerCase());
    if (username.split(" ").length < splitedSearchText.length) {
      continue;
    } else {
      var j = 0;
      for (; j < splitedSearchText.length; j++) {
        if (!username.contains(splitedSearchText[j])) break;
      }
      if (j == splitedSearchText.length) {
        // print(respond[i]);
        parsedMatch.add(UserInfo.fromJson(respond[i]));
      }
    }
  }
  return parsedMatch;
}

List<Chat> parseGroupChats(final respond, searchValue) {
  List<Chat> parsedMacth = [];

  List<String> splitedSearchText =
      TiengViet.parse(searchValue.toLowerCase()).split(" ");

  for (var i = 0; i < respond.length; i++) {
    var nameList = respond[i]["member"].map((user) {
      if (user["_id"] == UserInfo.userId) {
        return "";
      } else {
        return user["username"];
      }
    }).toList();

    nameList.removeWhere((value) => value == "");

    for (var j = 0; j < nameList.length; j++) {
      var username = TiengViet.parse(nameList[j].toLowerCase());
      if (username.split(" ").length < splitedSearchText.length) {
        continue;
      } else {
        var k = 0;
        for (; k < splitedSearchText.length; k++) {
          if (!username.contains(splitedSearchText[k])) {
            break;
          }
        }
        if (k == splitedSearchText.length) {
          parsedMacth.add(Chat.fromGroup(username, respond[i]));
        }
      }
    }
  }

  return parsedMacth;
}

List<Map<String, dynamic>> parseMessage(chatList, searchValue) {
  List<Map<String, dynamic>> parsed_result = [];
  for (var c = 0; c < chatList.length; c++) {
    Chat chat = chatList[c];
    List<int> tmp = [];
    for (var m = 0; m < chat.message.length; m++) {
      if (checkMessage(chat.message[m].content, searchValue)) {
        tmp.add(m);
      }
    }
    if (tmp.isNotEmpty) {
      parsed_result.add({"chat": chat, "index": tmp});
    }
  }
  return parsed_result;
}

bool checkMessage(message, searchValue) {
  List<String> splitedSearchText =
      TiengViet.parse(searchValue.toLowerCase()).split(" ");

  var content = TiengViet.parse(message.toLowerCase());
  if (content.split(" ").length >= splitedSearchText.length) {
    var j = 0;
    for (; j < splitedSearchText.length; j++) {
      if (!content.contains(splitedSearchText[j])) break;
    }
    if (j == splitedSearchText.length) {
      return true;
    }
  }
  return false;
}

Future<Chat> fetchChat(String friendId) async {
  for (var i = 0; i < SearchData.cached_chat.length; i++) {
    Chat chat = SearchData.cached_chat[i];
    if (chat.partner is UserInfo && chat.partner.id == friendId) {
      return chat;
    }
  }
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  var info = {
    "member": [UserInfo.userId, friendId]
  };
  final infoEncode = json.encode(info);
  final response = await http.post(Uri.parse('$urlApi/chats/createChat'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        "Content-Type": "application/json"
      },
      body: infoEncode);

  if (response.statusCode == 200) {
    final result = await json.decode(response.body)["data"];
    var res = Chat.fromJson(json);
    SearchData.cached_chat.add(res);
    return res;
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}
