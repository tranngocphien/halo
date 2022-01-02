import 'package:flutter/material.dart';
import 'package:halo/api/chat_api.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/chat.dart';
import 'package:halo/models/message_model.dart';
import 'package:halo/models/user_info.dart';
import 'package:halo/utils.dart';

class MessageScreen extends StatefulWidget {
  final Chat chat;
  final int loc;
  const MessageScreen({required this.chat, required this.loc, Key? key})
      : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late List<MessageModel> message;
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    message = [...widget.chat.message];
    _controller = new ScrollController();
  }

  void _goToElement(int index) {
    _controller.animateTo((62.0 * index),
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final contentController = TextEditingController();

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: message.length,
              itemBuilder: (context, index) {
                if (widget.loc != -1) {
                  if (message.length - widget.loc >= 10) {
                    _goToElement(widget.loc);
                  } else if (message.length >= 10) {
                    _goToElement(message.length - 10);
                  }
                } else {
                  if (message.length >= 10) {
                    _goToElement(message.length - 10);
                  }
                }
                return Message(message: message[index]);
              },
            ),
          ),
          const Divider(
            thickness: 3,
          ),
          Container(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: SafeArea(
              child: Row(
                children: [
                  const Icon(
                    Icons.mic,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.sentiment_satisfied_outlined),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: contentController,
                              decoration: const InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const Icon(Icons.attach_file)
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (contentController.text.trim().isNotEmpty) {
                        sendMessage(
                          content: contentController.text,
                          chat: widget.chat,
                        ).then((value) {
                          setState(() {
                            message = [...widget.chat.message];
                          });
                        });
                        contentController.text = '';
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "$urlFiles/${widget.chat.partner is UserInfo ? widget.chat.partner.avatar : widget.chat.partner[0].avatar}")),
                shape: BoxShape.circle),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chat.chatName,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.videocam),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.call))
      ],
    );
  }
}

class Message extends StatelessWidget {
  final MessageModel message;
  const Message({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message.sender.id == UserInfo.userId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          message.sender.id == UserInfo.userId
              ? Container()
              : Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "$urlFiles/${message.sender.avatar}")),
                      shape: BoxShape.circle),
                ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 240,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: message.sender.id == UserInfo.userId
                    ? const Color(0xFFa3cbf7)
                    : const Color(0xFFD6D6D6),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateTimeConverter.durationToNow(message.updatedAt),
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
