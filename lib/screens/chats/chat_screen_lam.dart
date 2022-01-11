import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halo/api/chat_api.dart';
import 'package:halo/data/data.dart';
import 'package:halo/models/chat.dart';
import 'package:halo/constants.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/screens/chats/components/components.dart';
import 'package:http/http.dart' as http;

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
                ? History(textController: _textController)
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
                ? SearchGUI(textController: _textController)
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

  void changeChats() {
    chats.clear();
    chats.addAll([
      ...SearchData.cached_chat
          .where((element) => element.message.isNotEmpty)
          .toList()
    ]);
    chats.sort((chat1, chat2) {
      final lastMessage1 = chat1.message[chat1.message.length - 1];
      final lastMessage2 = chat2.message[chat2.message.length - 1];

      return lastMessage1.createdAt.compareTo(lastMessage2.createdAt);
    });
  }

  void changeState() {
    _textController.text = '';
    if (leadingIcon.icon == Search.search) {
      leadingIcon = activeLeading;
      searchBar = activeSearchBar as Widget;
      if (!isSearchedScroll) {
        isSearchedStart = true;
      }
    } else {
      leadingIcon = const Icon(Search.search, size: 22, color: Colors.white);
      searchBar = const Text('Tìm bạn bè, tin nhắn...',
          style: TextStyle(fontSize: mediumSize, color: Colors.white));
      isSearchedStart = false;
      isSearchedScroll = false;
      changeChats();
    }
  }

  Widget buildChatListView(items) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return index == (items.length)
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: iconslightColor,
                child: Column(children: <Widget>[
                  const Text("Dễ dàng tìm kiếm và trò chuyện với bạn bè",
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: smallSize,
                      )),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/searchFriend');
                    },
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
            : item(index, items[index].id);
      },
      itemCount: items.length + 1,
    );
  }

  Widget buildListView() => RefreshIndicator(
      onRefresh: showSearchBar,
      child: FutureBuilder<List<Chat>>(
          future: fetchChats(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              chats = snapshot.data!;
              return buildChatListView(chats);
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

  Widget item(int index, String id) {
    return Slidable(
      key: Key(id),
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
      child: ListTileCard(chat: chats[index]),
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
        setState(() {
          String chatId = chats[index].id;
          for (var i = 0; i < SearchData.cached_chat.length; i++) {
            if (SearchData.cached_chat[i].id == chatId) {
              SearchData.cached_chat[i].message = [];
            }
          }
          chats.removeAt(index);
          deleteAllMessage(chatId);
        });
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
}
