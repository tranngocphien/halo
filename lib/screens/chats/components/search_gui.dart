import 'package:flutter/material.dart';
import 'package:halo/api/search_api.dart';
import 'package:halo/constants.dart';
import 'package:halo/data/data.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/models/models.dart';
import 'package:halo/screens/chats/components/components.dart';
import 'package:halo/screens/message/message_screen.dart';

class SearchGUI extends StatefulWidget {
  final TextEditingController textController;

  SearchGUI({required this.textController, Key? key}) : super(key: key);

  @override
  State<SearchGUI> createState() => _SearchGUIState();
}

class _SearchGUIState extends State<SearchGUI> {
  late Widget contactWidget;
  late Widget messageWidget;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // length of tabs
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
                ],
              ),
            ),
          ),
          Container(
            height: 600,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActiveSearch() => Container(
        height: 32,
        padding: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                Navigator.pop(context);
              }
              _textController.text = value;
              _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textController.text.length));
            });
          },
          controller: _textController,
          focusNode: FocusNode(),
          autofocus: true,
          style: const TextStyle(fontSize: mediumSize),
          decoration: InputDecoration(
              isDense: true,
              hintText: "Tìm bạn bè, tin nhắn...",
              border: InputBorder.none,
              hintStyle: const TextStyle(
                fontSize: smallSize,
                color: subtitleColor,
              ),
              suffixIcon: _textController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _textController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.cancel, color: Colors.black),
                    )
                  : null),
        ),
      );

  // ===================== Xây dựng tìm kiếm cho bạn bè, group chat =====================

  Widget buildFriendListTile(final friendList) {
    return friendList.isEmpty
        ? const SizedBox(height: 0)
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: friendList.length,
              itemBuilder: (context, index) {
                UserInfo friend = friendList[index];
                return GestureDetector(
                  onTap: () async {
                    Chat chat = await fetchChat(friend.id);
                    updateSearchHistory(chat);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MessageScreen(chat: chat, loc: -1)));
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
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: textColor,
                                  width: 0.08,
                                ),
                              ),
                            ),
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
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                Chat groupChat = groupList[index];
                return GestureDetector(
                  onTap: () {
                    Chat officialChat = SearchData.cached_chat
                        .where((chat) => chat.id == groupChat.id)
                        .toList()[0];
                    updateSearchHistory(officialChat);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MessageScreen(chat: officialChat, loc: -1)));
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
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: textColor,
                                  width: 0.08,
                                ),
                              ),
                            ),
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
                                  groupChat
                                      .message[groupChat.message.length - 1]
                                      .content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: smallSize,
                                      color: subtitleColor),
                                ),
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

  Widget buildMessageListTile(final messageList) {
    return messageList.isEmpty
        ? const SizedBox(height: 0)
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                Chat chat = messageList[index]["chat"];
                List<int> indexList = messageList[index]["index"];
                return GestureDetector(
                  onTap: () {
                    updateSearchHistory(chat);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageMatch(
                                chat: chat, indexList: indexList)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '$urlFiles/${chat.partner is UserInfo ? chat.partner.avatar : chat.partner[0].avatar}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: textColor,
                                  width: 0.08,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.chatName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: mediumSize),
                                ),
                                Text(
                                  '${indexList.length} tin nhắn trùng khớp',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: smallSize,
                                      color: subtitleColor),
                                ),
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

  Widget buildListTile(friendList, groupChatList, messageList) {
    if (friendList.isEmpty && groupChatList.isEmpty && messageList.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 15),
        child: Column(children: [
          const CircleAvatar(
            radius: 20,
            child: Icon(ListIcon.listIcon, color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: const Text("Không tìm thấy kết quả phù hợp",
                style: TextStyle(fontSize: mediumSize)),
          ),
        ]),
      );
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            friendList.isEmpty && groupChatList.isEmpty
                ? Container(height: 0)
                : Container(
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
            ((friendList.isNotEmpty || groupChatList.isNotEmpty) &&
                    messageList.isNotEmpty)
                ? const Divider(thickness: 10)
                : const SizedBox(height: 0),
            messageList.isEmpty
                ? Container(height: 0)
                : Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "Tin nhắn (${messageList.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: mediumSize,
                      ),
                    ),
                  ),
            buildMessageListTile(messageList)
          ],
        ),
      ),
    );
  }

  // Tìm kiếm trong danh sách bạn bè,
  Widget buildContactSearch() {
    // Danh sách bạn khớp.
    return SearchData.friendList.isNotEmpty &&
            SearchData.groupChatList.isNotEmpty &&
            SearchData.cached_chat.isNotEmpty
        ? buildListTile(
            parseFriends(SearchData.friendList, widget.textController.text),
            parseGroupChats(
                SearchData.groupChatList, widget.textController.text),
            parseMessage(SearchData.cached_chat, widget.textController.text))
        : FutureBuilder<List<dynamic>>(
            future: fetchSearchData(widget.textController.text),
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
                        '{Something went wrong}!',
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                    );
                  } else {
                    return buildListTile(snapshot.data![0], snapshot.data![1],
                        snapshot.data![2]);
                  }
              }
            },
          );
  }

  void updateSearchHistory(Chat chat) {
    var i = 0;
    for (; i < SearchData.searched_chat.length; i++) {
      Chat tmp = SearchData.searched_chat[i];
      if (tmp.id == chat.id) {
        SearchData.searched_chat.removeAt(i);
        SearchData.searched_chat.insert(0, chat);
        break;
      }
    }

    var j = 0;
    for (; j < SearchData.searched_word.length; j++) {
      String tmp = SearchData.searched_word[j];
      if (tmp == widget.textController.text) {
        SearchData.searched_word.removeAt(j);
        SearchData.searched_word.insert(0, tmp);
        break;
      }
    }

    if (i == SearchData.searched_chat.length) {
      if (SearchData.searched_chat.length >= 10) {
        SearchData.searched_chat.removeLast();
      }
      SearchData.searched_chat.insert(0, chat);
    }

    if (j == SearchData.searched_word.length) {
      if (SearchData.searched_word.length >= 5) {
        SearchData.searched_word.removeLast();
      }
      SearchData.searched_word.insert(0, widget.textController.text);
    }
  }
}
