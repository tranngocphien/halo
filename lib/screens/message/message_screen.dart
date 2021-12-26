import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:get/get.dart';
import 'package:halo/models/chat_model.dart';
import 'package:halo/models/message_model.dart';
import 'package:halo/screens/message/message_controller.dart';

class MessageScreen extends StatelessWidget {
  final ChatModel chatModel;
  MessageScreen({required this.chatModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageController =
        Get.put(MessageController(chatId: chatModel.id), tag: chatModel.id);
    final contentController = TextEditingController();

    return Scaffold(
      appBar: buildAppBar(),
      body: Obx(() => messageController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    ...messageController.chat
                        .map((element) => Message(message: element))
                  ],
                )),
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
                                SizedBox(width: 10),
                                Expanded(
                                    child: TextField(
                                  controller: contentController,
                                  decoration: const InputDecoration(
                                    hintText: "Type message",
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(fontSize: 18),
                                )),
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
                            messageController.sendMessage(
                                content: contentController.text,
                                chatId: chatModel.id,
                                receivedId: chatModel.userId,
                                name: '');
                            FocusScope.of(context).requestFocus(FocusNode());
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
            )),
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
                    image: NetworkImage("$urlFiles/${chatModel.avatar}")),
                shape: BoxShape.circle),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatModel.username,
                style: TextStyle(fontSize: 14),
              ),
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.videocam),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.call))
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
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          message.isSender
              ? Container()
              : Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "$urlFiles/${message.userInfo.avatar}")),
                      shape: BoxShape.circle),
                ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 240,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: message.isSender ? Color(0xFFa3cbf7) : Color(0xFFD6D6D6),
                borderRadius: BorderRadius.all(Radius.circular(5))),
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
                      message.updatedAt.toString(),
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
