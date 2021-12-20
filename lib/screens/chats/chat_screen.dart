import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halo/data/data.dart';
import 'package:halo/models/models.dart';
import 'package:halo/constants.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/screens/chats/components/components.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Chat> chats;

  late Icon leadingIcon;
  late Widget searchBar;
  Icon deactivateLeading =
      const Icon(Search.search, size: 22, color: Colors.white);
  Widget deactivateSearchBar = const Text(
    'Tìm bạn bè, tin nhắn...',
    style: TextStyle(
      fontSize: mediumSize,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );
  Icon activeLeading =
      const Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.white);
  Widget? activeSearchBar;

  late TextEditingController _textController;
  late bool isSearchedScroll; // Tìm kiếm khi đã scroll và hiện appBar search
  late bool isSearchedStart; // Tìm kiếm ấn appBar

  @override
  void initState() {
    super.initState();
    leadingIcon = deactivateLeading;
    searchBar = deactivateSearchBar;
    isSearchedScroll = false;
    isSearchedStart = false;
    _textController = TextEditingController();
    activeSearchBar = buildActiveSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(46.0),
          child: AppBar(
              elevation: 0,
              titleSpacing: 0,
              title: InkWell(
                  onTap: () {
                    setState(() {
                      changeState();
                    });
                  },
                  child: searchBar),
              leading: IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: leadingIcon,
                  onPressed: () {
                    setState(() {
                      changeState();
                    });
                  }),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(Qrcode.qrcode,
                            size: 22, color: Colors.white),
                        onPressed: () {})),
                leadingIcon.icon == Search.search
                    ? const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: PopupMenu(),
                      )
                    : Container(),
              ]),
        ),
        body: Stack(
          children: [
            buildListView(),
            isSearchedStart
                ? Container(
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
                        : Column(children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      Navigator.pushNamed(
                                          context, '/historyRepair');
                                      setState(() {});
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
                                    return const Divider();
                                  }
                                  return SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 10),
                                          child: const Icon(Search.search,
                                              size: smallSize),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          SearchData.searched_word[index - 2],
                                          style: const TextStyle(
                                              fontSize: smallSize),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: SearchData.searched_word.length + 2,
                              ),
                            ),
                          ]),
                  )
                : const Text(""),
            isSearchedScroll
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchedScroll = false;
                        changeState();
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                    ),
                  )
                : const Text(""),
            _textController.text.isNotEmpty
                ? SearchGUI(_textController.text)
                : Container(),
          ],
        ));
  }

  Future showSearchBar() async {
    setState(() {
      isSearchedScroll = true;
      changeState();
    });
  }

  void changeState() {
    _textController.text = '';
    if (leadingIcon.icon == Search.search) {
      leadingIcon = activeLeading;
      searchBar = activeSearchBar as Widget;
      isSearchedStart = true;
    } else {
      leadingIcon = const Icon(Search.search, size: 22, color: Colors.white);
      searchBar = const Text('Tìm bạn bè, tin nhắn...',
          style: TextStyle(fontSize: mediumSize, color: Colors.white));
      isSearchedStart = false;
      isSearchedScroll = false;
    }
  }

  Widget buildListView() => RefreshIndicator(
      onRefresh: showSearchBar,
      child: FutureBuilder<List<Chat>>(
          future: fetchChats(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SearchData.cached_chat = chats = snapshot.data!;
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  return index == (snapshot.data!.length)
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: iconslightColor,
                          child: Column(children: <Widget>[
                            const Text(
                                "Dễ dàng tìm kiếm và trò chuyện với bạn bè",
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: smallSize,
                                )),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: Text("Tìm thêm bạn",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: smallSize)),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ]),
                        )
                      : item(index);
                },
                itemCount: snapshot.data!.length + 1,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }));

  dynamic buildAddModal(int index) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.4, color: subtitleColor))),
                        child: const Center(
                            child: Text('Tuỳ chọn',
                                style: TextStyle(
                                    color: subtitleColor, fontSize: 16)))),
                    GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: "Chưa hoàn thiện!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 15.0);

                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: subtitleColor))),
                          child: const Center(
                              child: Text('Ẩn trò chuyện',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  )))),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (chats[index].isMuted) {
                          setState(() {
                            chats[index].isMuted = false;
                          });
                          Navigator.pop(context);
                        } else {
                          buildMuteModal(index);
                        }
                      },
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            chats[index].isMuted
                                ? 'Bật thông báo'
                                : 'Tắt thông báo',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Text('Huỷ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue)),
                    )),
              )
            ]),
          );
        });
  }

  Widget item(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/message');
      },
      child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          secondaryActions: [
            IconSlideAction(
                caption: 'Thêm',
                color: const Color(0xff8f9aa6),
                icon: Icons.more_horiz,
                onTap: () => onDismissed(index, "add")),
            IconSlideAction(
                caption: chats[index].isPined ? 'Bỏ Ghim' : 'Ghim',
                color: const Color(0xff4751bb),
                icon: chats[index].isPined ? Unpin.unpin : Pin.pin,
                onTap: () => onDismissed(index, "pin")),
            IconSlideAction(
                caption: 'Xoá',
                color: const Color(0xffee4e49),
                icon: Icons.delete,
                onTap: () => onDismissed(index, "delete"))
          ],
          child: ListTileCard(chat: chats[index])),
    );
  }

  void onDismissed(int index, String action) {
    switch (action) {
      case "add":
        buildAddModal(index);
        break;

      case "pin":
        setState(() {
          if (chats[index].isPined) {
            chats[index].isPined = false;
            Fluttertoast.showToast(
                msg: "Cập nhật thành công!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15.0);
          } else {
            chats[index].isPined = true;
            Fluttertoast.showToast(
                msg: "Ghim trò chuyện ${chats[index].chatName} thành công",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15.0);
          }
        });
        break;

      case "delete":
        setState(() => chats.removeAt(index));
        break;
    }
  }

  dynamic buildMuteModal(int index) {
    Navigator.pop(context);
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(children: [
                    Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.4, color: subtitleColor))),
                        child: const Center(
                            child: Text(
                                'Không thông báo tin nhắn tới hội thoại này',
                                style: TextStyle(
                                    color: subtitleColor, fontSize: 16)))),
                    GestureDetector(
                      onTap: () {
                        DateTime curTime = DateTime.now();
                        curTime = curTime.add(const Duration(minutes: 15));
                        setState(() {
                          chats[index].isMuted = true;
                          chats[index].mutedTo = curTime;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: subtitleColor))),
                          child: const Center(
                              child: Text('Trong 15 phút',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  )))),
                    ),
                    GestureDetector(
                      onTap: () {
                        DateTime curTime = DateTime.now();
                        curTime = curTime.add(const Duration(hours: 1));
                        setState(() {
                          chats[index].isMuted = true;
                          chats[index].mutedTo = curTime;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: subtitleColor))),
                          child: const Center(
                              child: Text('Trong 1 giờ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  )))),
                    ),
                    GestureDetector(
                      onTap: () {
                        DateTime curTime = DateTime.now();
                        curTime = curTime.add(const Duration(days: 365));
                        setState(() {
                          chats[index].isMuted = true;
                          chats[index].mutedTo = curTime;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: subtitleColor))),
                          child: const Center(
                              child: Text('Đến khi tôi bật lại',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  )))),
                    ),
                  ])),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Text('Huỷ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue)),
                    )),
              )
            ]),
          );
        });
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
              _textController.text = value;
              _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textController.text.length));
            });
          },
          controller: _textController,
          focusNode: FocusNode(),
          autofocus: true,
          style: const TextStyle(fontSize: mediumSize),
          decoration: const InputDecoration(
            isDense: true,
            hintText: "Tìm bạn bè, tin nhắn...",
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: smallSize,
              color: subtitleColor,
            ),
          ),
        ),
      );

  Widget buildUserSearchSlider() => SizedBox(
        height: 110,
        width: double.infinity,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                print('Vào nhắn với ${chats[index].chatName} nè');
                Navigator.pushNamed(context, '/message');
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
                        "$urlFiles/${chats[index].partner is User ? chats[index].partner.avatar : chats[index].partner[0].avatar}",
                        fit: BoxFit.cover,
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(chats[index].chatName,
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
    //print(responseBody);
    final chats =
        json.decode(responseBody)["chat"].cast<Map<String, dynamic>>();
    final lastMessages =
        json.decode(responseBody)["last_message"].cast<Map<String, dynamic>>();

    final parsed = [];
    for (var i = 0; i < chats.length; i++) {
      parsed.add({"chat": chats[i], "last_message": lastMessages[i]});
    }

    List<Chat> result =
        parsed.map<Chat>((json) => Chat.fromJson(json)).toList();
    result.sort((chat1, chat2) =>
        chat1.message.createdAt.compareTo(chat2.message.createdAt));
    return result.reversed.toList();
  }
}
