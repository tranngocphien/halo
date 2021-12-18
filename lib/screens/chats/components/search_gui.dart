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

class SearchGUI extends StatelessWidget {
  late String searchValue;
  late Future<List<User>> friendList = fetchFriends();
  late Future<List<Chat>> groupChatList = fetchGroupChats();

  SearchGUI(this.searchValue, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // length of tabs
      initialIndex: 0,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: whiteColor,
            ),
            child: const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: subtitleColor,
              tabs: [
                Tab(text: 'Tất cả'),
                Tab(text: 'Liên hệ'),
                Tab(text: 'Tin nhắn'),
              ],
            ),
          ),
          Flexible(
            child: Container(
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
                  Container(
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
          )
        ],
      ),
    );
  }

  // Tìm kiếm trong danh sách bạn bè,
  // danh sách thành viên nhóm chat của userID.
  Widget buildContactSearch() {
    // Danh sách bạn khớp.
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, left: 10),
            child: const Text(
              "Liên hệ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: FutureBuilder<List<User>>(
                future: friendList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          User friend = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/message');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        '$urlFiles/$friend.avatar}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            friend.username,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: smallSize),
                                          ),
                                          GestureDetector(
                                            onTap: null,
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  Colors.blue.shade200,
                                              child: const Icon(Call.call,
                                                  color: Colors.blue),
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
                  return const Center(
                      child: Text("Chưa tìm thấy dữ liệu khớp"));
                },
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<Chat>>(
              future: groupChatList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/message');
                          },
                          child: Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      '$urlFiles/${snapshot.data![index].partner[0].avatar}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    snapshot.data![index].chatName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: smallSize),
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
                return const Center(child: Text("Chưa tìm thấy dữ liệu khớp"));
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<User>> fetchFriends() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? "";
    //print(token);
    final response = await http.post(Uri.parse('$urlApi/friends/list'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final result = json
          .decode(response.body)["data"]["friends"]
          .cast<Map<String, dynamic>>();
      ;
      // SearchData.friendList.add(result);
      return parseFriends(result);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  List<User> parseFriends(final respond) {
    List<User> parsedMatch = [];

    List<String> splitedSearchText =
        TiengViet.parse(searchValue.toLowerCase()).split(" ");

    for (var i = 0; i < respond.length; i++) {
      var username = TiengViet.parse(respond[i]["username"].toLowerCase());
      if (username.split(" ").length > splitedSearchText.length)
        continue;
      else {
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

  Future<List<Chat>> fetchGroupChats() async {
    if (SearchData.groupChatList.isEmpty) {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token') ?? "";
      //print(token);
      final response = await http.post(Uri.parse('urlApi/chats/getGroupChats'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      if (response.statusCode == 200) {
        final result =
            json.decode(response.body)["chat"].cast<Map<String, dynamic>>();
        ;
        SearchData.groupChatList = result;
        return parseGroupChats(result);
      } else {
        throw Exception('Unable to fetch products from the REST API');
      }
    }
    return parseGroupChats(SearchData.groupChatList);
  }

  List<Chat> parseGroupChats(final respond) {
    List<Chat> parsedMacth = [];

    List<String> splitedSearchText =
        TiengViet.parse(searchValue.toLowerCase()).split(" ");

    for (var i = 0; i < respond.length; i++) {
      var nameList = respond[i]["member"].map((user) {
        if (user["_id"] == User.userId) {
          return "";
        } else {
          var checkExist = SearchData.friendList
              .where((friend) => friend["_id"] == user["_id"]);
          if (checkExist.isEmpty) return user["username"];
        }
        return "";
      });

      for (var j = 0; j < nameList.length; j++) {
        var username = TiengViet.parse(nameList[i].toLowerCase());
        if (username.split(" ").length > splitedSearchText.length) {
          continue;
        } else {
          var k = 0;
          for (; k < splitedSearchText.length; k++) {
            if (!username.contains(splitedSearchText[j])) break;
          }
          if (k == splitedSearchText.length) {
            parsedMacth.add(Chat.fromGroup(respond[i]));
          }
        }
      }
    }

    return parsedMacth;
  }
}
