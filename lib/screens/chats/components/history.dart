import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/data/search_data.dart';
import 'package:halo/icons/search_icons.dart';
import 'package:halo/models/models.dart';
import 'package:halo/models/user_info.dart';
import 'package:halo/screens/chats/chat_screen_lam.dart';
import 'package:halo/screens/message/message_screen.dart';

class History extends StatefulWidget {
  final TextEditingController textController;

  const History({required this.textController, Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SearchData.searched_chat.isEmpty &&
              SearchData.searched_word.isEmpty
          ? Container(
              padding: const EdgeInsets.only(top: 10),
              child: const Center(
                child: Text("Danh sách tìm kiếm gần đây trống"),
              ),
            )
          : Column(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tìm kiếm gần đây",
                        style: TextStyle(
                          fontSize: smallSize,
                          color: textBoldColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/historyRepair')
                              .then((_) => setState(() {}));
                        },
                        child: const Text(
                          "Sửa",
                          style: TextStyle(
                            fontSize: smallSize,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      if (index == 0) {
                        return buildUserSearchSlider();
                      } else if (index == 1) {
                        return SearchData.searched_chat.isNotEmpty &&
                                SearchData.searched_word.isNotEmpty
                            ? const Divider()
                            : const SizedBox(height: 0);
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.textController.text =
                                SearchData.searched_word[index - 2];
                            widget.textController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: widget.textController.text.length));
                          });
                        },
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child:
                                    const Icon(Search.search, size: smallSize),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                SearchData.searched_word[index - 2],
                                style: const TextStyle(fontSize: smallSize),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: SearchData.searched_word.length + 2,
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildUserSearchSlider() => SearchData.searched_chat.isEmpty
      ? const SizedBox(height: 0)
      : SizedBox(
          height: 110,
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              Chat chat = SearchData.searched_chat[index];
              return GestureDetector(
                onTap: () {
                  print('Vào nhắn với ${chat.chatName} nè');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MessageScreen(chat: chat, loc: -1)));
                },
                child: Container(
                  width: 65,
                  margin: const EdgeInsets.all(6),
                  child: Column(children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          "$urlFiles/${chat.partner is UserInfo ? chat.partner.avatar : chat.partner[0].avatar}",
                          fit: BoxFit.cover,
                          width: 60.0,
                          height: 60.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(chat.chatName,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: subtitleColor)),
                  ]),
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: SearchData.searched_chat.length,
          ),
        );
}
