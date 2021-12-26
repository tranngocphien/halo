import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/data/data.dart';
import 'package:halo/icons/icons.dart';

class HistoryRepair extends StatefulWidget {
  const HistoryRepair({Key? key}) : super(key: key);

  @override
  _HistoryRepairState createState() => _HistoryRepairState();
}

class _HistoryRepairState extends State<HistoryRepair> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left,
                size: 30, color: Colors.black),
          ),
          title: const Text(
            "Tìm kiếm gần đây",
            style: TextStyle(
              color: Colors.black,
              fontSize: mediumSize,
            ),
          ),
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          SearchData.searched_chat.isNotEmpty
              ? searchedChatWidget()
              : Container(),
          SearchData.searched_word.isNotEmpty
              ? searchedWordWidget()
              : Container(),
          SearchData.searched_chat.isEmpty && SearchData.searched_word.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Center(
                    child: Text(
                      "Danh sách tìm kiếm gần đây trống",
                      style: TextStyle(
                        fontSize: smallSize,
                      ),
                    ),
                  ),
                )
              : Container(),
        ]));
  }

  Widget searchedChatWidget() {
    return Flexible(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Liên hệ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: smallSize,
                )),
            TextButton(
              onPressed: () {
                setState(() {
                  SearchData.searched_chat = [];
                });
              },
              child: const Text("Xoá hết",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: smallSize,
                  )),
            )
          ]),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, index) {
              return Container(
                width: double.infinity,
                child: Row(children: [
                  SizedBox(
                    width: 50,
                    child: SearchData.searched_chat[index]['chatType'] ==
                            'PRIVATE_CHAT'
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '$urlFiles/${SearchData.searched_chat[index]['avatar']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Icon(Icons.group,
                            color: subtitleColor, size: mediumSize),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            SearchData.searched_chat[index]['chatName']
                                as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: smallSize,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                SearchData.searched_chat.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.close, color: subtitleColor),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              );
            },
            itemCount: SearchData.searched_chat.length,
          ),
        ),
      ]),
    );
  }

  Widget searchedWordWidget() {
    return Flexible(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Từ khoá",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: smallSize,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          SearchData.searched_word = [];
                        });
                      },
                      child: const Text("Xoá hết",
                          style: TextStyle(fontSize: smallSize)),
                    )
                  ]),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, index) {
                  return Container(
                    child: Row(children: [
                      const SizedBox(
                        width: 50,
                        child: Icon(
                          Search.search,
                          size: smallSize,
                          color: subtitleColor,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  SearchData.searched_word[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: smallSize),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      SearchData.searched_word.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.close,
                                      color: subtitleColor),
                                )
                              ]),
                        ),
                      ),
                    ]),
                  );
                },
                itemCount: SearchData.searched_word.length,
              ),
            ),
          ]),
    );
  }
}
