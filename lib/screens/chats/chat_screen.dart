import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halo/data/data.dart';
import 'package:halo/models/conversation.dart';
import 'package:halo/models/models.dart';
import 'package:halo/constants.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/components/components.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Conversation> conversationList = ConversationData.conversationList;
  List<String> searchKeyword = SearchData.searchKeyword;
  List<Conversation> recentSearchConversation =
      SearchData.recentSearchConversation;

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
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: buildPopupMenu(),
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
                    child: Column(children: [
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Tìm kiếm gần đây",
                              style: TextStyle(
                                fontSize: smallSize,
                                color: textBoldColor,
                              ),
                            ),
                            TextButton(
                              onPressed: null,
                              child: Text(
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
                                    searchKeyword[index - 2],
                                    style: const TextStyle(fontSize: smallSize),
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: searchKeyword.length + 2,
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
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return index == (conversationList.length)
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
          itemCount: conversationList.length + 1,
        ),
      );

  dynamic buildPopupMenu() => PopupMenuButton(
        offset: const Offset(8, 52),
        child: Container(
          height: 30,
          width: 30,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        onSelected: (value) {},
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: Row(children: const [
              Icon(Icons.group_add_outlined, color: subtitleColor),
              SizedBox(width: 15),
              Text('Tạo nhóm'),
            ]),
          ),
          PopupMenuItem(
            child: Row(children: const [
              Icon(Icons.person_add_outlined, color: subtitleColor),
              SizedBox(width: 15),
              Text('Thêm bạn'),
            ]),
          ),
          PopupMenuItem(
            child: Row(children: const [
              Icon(Qrcode.qrcode, color: subtitleColor),
              SizedBox(width: 15),
              Text('Quét mã QR'),
            ]),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            child: Row(children: const [
              Icon(Icons.date_range, color: subtitleColor),
              SizedBox(width: 15),
              Text('Lịch Zalo'),
            ]),
          ),
          PopupMenuItem(
            child: Row(children: const [
              Icon(Icons.desktop_windows, color: subtitleColor),
              SizedBox(width: 15),
              Text('Lịch sử đăng nhập'),
            ]),
          ),
          PopupMenuItem(
            child: Row(children: const [
              Icon(Icons.cloud_queue, color: subtitleColor),
              SizedBox(width: 15),
              Text('Cloud của tôi'),
            ]),
          ),
          PopupMenuItem(
            child: Row(children: const [
              Icon(Icons.videocam_outlined, color: subtitleColor),
              SizedBox(width: 15),
              Text('Tạo cuộc gọi nhóm'),
            ]),
          ),
        ],
      );

  Widget item(int index) {
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        secondaryActions: [
          IconSlideAction(
              caption: 'Thêm',
              color: const Color(0xff8f9aa6),
              icon: Icons.more_horiz,
              onTap: () => onDismissed(index, "add")),
          IconSlideAction(
              caption: conversationList[index].isPined ? 'Bỏ Ghim' : 'Ghim',
              color: const Color(0xff4751bb),
              icon: conversationList[index].isPined ? Unpin.unpin : Pin.pin,
              onTap: () => onDismissed(index, "pin")),
          IconSlideAction(
              caption: 'Xoá',
              color: const Color(0xffee4e49),
              icon: Icons.delete,
              onTap: () => onDismissed(index, "delete"))
        ],
        child: ListTileCard(conversation: conversationList[index]));
  }

  void onDismissed(int index, String action) {
    switch (action) {
      case "add":
        buildAddModal(index);
        break;

      case "pin":
        setState(() {
          if (conversationList[index].isPined) {
            conversationList[index].isPined = false;
            Fluttertoast.showToast(
                msg: "Cập nhật thành công!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15.0);
          } else {
            conversationList[index].isPined = true;
            Fluttertoast.showToast(
                msg:
                    "Ghim trò chuyện ${conversationList[index].partner.username} thành công",
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
        setState(() => conversationList.removeAt(index));
        break;
    }
  }

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
                  child: Column(children: [
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
                        if (ConversationData.conversationList[index].isMuted) {
                          setState(() {
                            ConversationData.conversationList[index].isMuted =
                                false;
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
                                  ConversationData
                                          .conversationList[index].isMuted
                                      ? 'Bật thông báo'
                                      : 'Tắt thông báo',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  )))),
                    )
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
                          ConversationData.conversationList[index].isMuted =
                              true;
                          ConversationData.conversationList[index].mutedTo =
                              curTime;
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
                          ConversationData.conversationList[index].isMuted =
                              true;
                          ConversationData.conversationList[index].mutedTo =
                              curTime;
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
                          ConversationData.conversationList[index].isMuted =
                              true;
                          ConversationData.conversationList[index].mutedTo =
                              curTime;
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
            Conversation conversation = recentSearchConversation[index];
            return GestureDetector(
              onTap: () {
                print('Vào nhắn với ${conversation.partner.username} nè');
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
                      child: Image.asset(
                        'assets/images/${conversation.partner.avatar}',
                        fit: BoxFit.cover,
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(conversation.partner.username,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: subtitleColor)),
                ]),
              ),
            );
          },
          scrollDirection: Axis.horizontal,
          itemCount: recentSearchConversation.length,
        ),
      );
}
