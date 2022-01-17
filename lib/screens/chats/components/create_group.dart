import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halo/api/chat_api.dart';
import 'package:halo/api/search_api.dart';
import 'package:halo/constants.dart';
import 'package:halo/data/search_data.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/models/models.dart';
import 'package:halo/screens/message/message_screen.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  // Danh sách bạn bè được chọn.
  late List<String> friendIndex = [];
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Huỷ",
              style: TextStyle(fontSize: mediumSize, color: textColor),
            ),
          ),
          title: Column(
            children: [
              const Text(
                "Nhóm mới",
                style: TextStyle(
                    fontSize: mediumSize,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
              Text(
                "Đã chọn: ${friendIndex.length}",
                style:
                    const TextStyle(fontSize: smallSize, color: subtitleColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {});
                if (friendIndex.length < 2) {
                  Fluttertoast.showToast(
                      msg: "Hãy chọn ít nhất 3 thành viên, cả bạn!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 15.0);
                } else {
                  if (_groupNameController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Điền tên nhóm!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 15.0);
                  } else {
                    friendIndex.add(UserInfo.userId);
                    Chat respond = await createGroupChat({
                      "name": _groupNameController.text,
                      "member": friendIndex
                    });
                    friendIndex.clear();
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MessageScreen(chat: respond, loc: -1)))
                        .then((value) => Navigator.pop(context));
                    setState(() {});
                  }
                }
              },
              child: const Text(
                "Tạo",
                style: TextStyle(
                  fontSize: mediumSize,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
              child: TextField(
                controller: _groupNameController,
                style: const TextStyle(fontSize: mediumSize),
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: "Tên nhóm (bắt buộc)",
                  hintStyle: TextStyle(
                    fontSize: smallSize,
                    color: subtitleColor,
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.only(left: 15, bottom: 4),
              decoration: const BoxDecoration(
                color: iconslightColor,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: TextField(
                onChanged: (text) {
                  setState(() {});
                },
                controller: _searchWordController,
                style: const TextStyle(fontSize: mediumSize),
                decoration: InputDecoration(
                    isDense: true,
                    icon: Container(
                        padding: const EdgeInsets.only(top: 4),
                        child: const Icon(Search.search)),
                    hintText: "Tìm tên hoặc số điện thoại",
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      fontSize: smallSize,
                      color: subtitleColor,
                    ),
                    suffixIcon: _searchWordController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchWordController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.cancel, color: Colors.black))
                        : null),
              ),
            ),
            DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: whiteColor,
                    ),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: subtitleColor,
                      tabs: [
                        SizedBox(
                          width: width / 3,
                          child: const Tab(text: 'GẦN ĐÂY'),
                        ),
                        SizedBox(
                          width: width / 3,
                          child: const Tab(text: 'BẠN BÈ'),
                        ),
                      ],
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
                        Container(height: 0),
                        SearchData.friendList.isNotEmpty
                            ? buildListTile(SearchData.friendList)
                            : FutureBuilder<List<Map<String, dynamic>>>(
                                future: fetchFriends(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    default:
                                      if (snapshot.hasError) {
                                        return Container(
                                          color: Colors.black,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Something went wrong!',
                                            style: TextStyle(
                                                fontSize: 28,
                                                color: Colors.white),
                                          ),
                                        );
                                      } else {
                                        return buildListTile(snapshot.data!);
                                      }
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildListTile(friendList) {
    var width = MediaQuery.of(context).size.width;
    // if (friendList.isNotEmpty) {
    //   friendList.sort((a, b) {
    //     return a["username"].compareTo(b["username"]) == 0;
    //   });
    // }
    return friendList.isEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                const Text("Chưa kết bạn với ai"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/searchFriend');
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Text("Tìm thêm bạn",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: smallSize)),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: friendList.length > 1
                ? friendList.length
                : friendList.length + 1,
            itemBuilder: (context, index) {
              return (index == friendList.length && friendList.length < 2)
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width / 3.6, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/searchFriend');
                          setState(() {});
                        },
                        child: const Text(
                          "Tìm thêm bạn",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: smallSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (friendIndex.contains(friendList[index]["_id"])) {
                          friendIndex.remove(friendList[index]["_id"]);
                        } else {
                          friendIndex.add(friendList[index]["_id"]);
                        }
                        setState(() {});
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: Row(
                            children: [
                              friendIndex.contains(friendList[index]["_id"])
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.blue, size: 30)
                                  : const Icon(Icons.radio_button_unchecked,
                                      color: subtitleColor, size: 30),
                              const SizedBox(width: 15),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    '$urlFiles/${friendList[index]["avatar"]["fileName"]}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                friendList[index]["username"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: mediumSize),
                              ),
                            ],
                          )),
                    );
            });
  }
}
