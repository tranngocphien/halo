import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/data/data.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tiengviet/tiengviet.dart';

class SearchGUI extends StatefulWidget {
  late String searchValue;

  SearchGUI(this.searchValue, {Key? key}) : super(key: key);

  @override
  State<SearchGUI> createState() => _SearchGUIState();
}

class _SearchGUIState extends State<SearchGUI> {
  late bool finded_contact = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // length of tabs
      initialIndex: 0,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              color: whiteColor,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: subtitleColor,
                tabs: [
                  Tab(text: 'TẤT CẢ'),
                  Tab(text: 'LIÊN HỆ'),
                  Tab(text: 'TIN NHẮN'),
                ],
              ),
            ),
          ),
          Container(
            height: 500,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              color: whiteColor,
            ),
            child: TabBarView(
              children: [
                buildContactSearch(),
                finded_contact == false
                    ? const Center(
                        child: Text("Không tìm thấy liên hệ nào",
                            style: TextStyle(fontSize: largeSize)))
                    : Container(
                        child: const Center(
                          child: Text(
                            'Display Tab 2',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                Container(
                  child: const Center(
                    child: Text(
                      'Display Tab 3',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== Xây dựng tìm kiếm cho bạn bè, group chat =====================

  Widget buildFriendListTile(final friendList) {
    return friendList.isEmpty
        ? const SizedBox(height: 0)
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: friendList.length,
              itemBuilder: (context, index) {
                User friend = friendList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/message');
                  },
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '$urlFiles/${friend.avatar}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  friend.username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: mediumSize),
                                ),
                                GestureDetector(
                                  onTap: null,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.blue.shade200,
                                    child: const Icon(Call.call,
                                        color: Colors.blue, size: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget buildGroupListTile(final groupList) {
    return groupList.isEmpty
        ? const SizedBox(height: 0)
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                Chat groupChat = groupList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/message');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '$urlFiles/${groupChat.partner[0].avatar}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                groupChat.chatName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: mediumSize),
                              ),
                              Text(
                                groupChat.message.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: mediumSize,
                                    color: subtitleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget buildListTile(final friendList, groupChatList) {
    if (friendList.isEmpty && groupChatList.isEmpty) {
      return Container(height: 0);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, left: 10),
          child: Text(
            "Liên hệ (${friendList.length + groupChatList.length})",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: mediumSize,
            ),
          ),
        ),
        buildFriendListTile(friendList),
        buildGroupListTile(groupChatList),
        const Divider(thickness: 10)
      ],
    );
  }

  // Tìm kiếm trong danh sách bạn bè,
  Widget buildContactSearch() {
    // Danh sách bạn khớp.
    return SearchData.friendList.isNotEmpty &&
            SearchData.groupChatList.isNotEmpty
        ? buildListTile(parseFriends(SearchData.friendList),
            parseGroupChats(SearchData.groupChatList))
        : FutureBuilder<List<List<dynamic>>>(
            future: fetchFriendsAndGroupChats(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const Text(
                        'Something went wrong!',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                    );
                  } else {
                    return buildListTile(snapshot.data![0], snapshot.data![1]);
                  }
              }
            },
          );
  }

  Future<List<List<dynamic>>> fetchFriendsAndGroupChats() async {
    List<List<dynamic>> parsed_result = [];
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? "";
    //print(token);
    final response1 = await http.post(Uri.parse('$urlApi/friends/list'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    final response2 = await http.get(Uri.parse('$urlApi/chats/getGroupChats'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response1.statusCode == 200) {
      final result = json
          .decode(response1.body)["data"]["friends"]
          .cast<Map<String, dynamic>>();
      SearchData.friendList = await result;
      parsed_result.add(parseFriends(result));
    } else {
      throw Exception('Unable to fetch friend list from the REST API');
    }

    if (response2.statusCode == 200) {
      final result =
          json.decode(response2.body)["chat"].cast<Map<String, dynamic>>();
      SearchData.groupChatList = await result;
      parsed_result.add(parseGroupChats(result));
    } else {
      throw Exception('Unable to fetch group chats from the REST API');
    }

    return parsed_result;
  }

  List<User> parseFriends(final respond) {
    List<User> parsedMatch = [];

    List<String> splitedSearchText =
        TiengViet.parse(widget.searchValue.toLowerCase()).split(" ");

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
          parsedMatch.add(User.fromJson(respond[i]));
        }
      }
    }
    return parsedMatch;
  }

  List<Chat> parseGroupChats(final respond) {
    List<Chat> parsedMacth = [];

    List<String> splitedSearchText =
        TiengViet.parse(widget.searchValue.toLowerCase()).split(" ");

    for (var i = 0; i < respond.length; i++) {
      var nameList = respond[i]["member"].map((user) {
        if (user["_id"] == User.userId) {
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

  // ===================== Xây dựng tìm kiếm cho tin nhắn =====================

  Future<List<List<dynamic>>> fetchChatsMessages() async {
    List<List<dynamic>> parsed_result = [];
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? "";

    final List<Chat> chatList = SearchData.cached_chat;

    for (var c = 0; c < chatList.length; c++) {
      var chatId = chatList[c].id;
      var chatUrl = '$urlApi/chats/getMessages/$chatId';
      final response = await http.get(Uri.parse(chatUrl),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

      if (response.statusCode == 200) {
        final result =
            json.decode(response.body)["data"].cast<Map<String, dynamic>>();
        SearchData.friendList = await result;
        parsed_result.add(parseMessages(result));
      } else {
        throw Exception('Unable to fetch chat messages from the REST API');
      }
    }
    return parsed_result;
  }

  List<User> parseMessages(final respond) {
    List<User> parsedMatch = [];

    List<String> splitedSearchText =
        TiengViet.parse(widget.searchValue.toLowerCase()).split(" ");

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
          parsedMatch.add(User.fromJson(respond[i]));
        }
      }
    }
    return parsedMatch;
  }
}
