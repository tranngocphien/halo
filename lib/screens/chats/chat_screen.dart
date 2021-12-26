import 'package:flutter/material.dart';
import 'package:halo/components/filled_outline_button.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/chats/chat_controller.dart';
import 'package:get/get.dart';
import 'package:halo/screens/message/message_screen.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: primaryColor,
            child: Row(
              children: [
                FillOutlineButton(press: () {}, text: "Recent Message"),
                const SizedBox(width: kDefaultPadding),
                FillOutlineButton(
                  text: "Active",
                  press: () {},
                  isFilled: false,
                )
              ],
            ),
          ),
          Obx(() => Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: chatController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: chatController.chats.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessageScreen(chatModel: chatController.chats[index],)),
                              );
                            },
                            child: ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Image.network(
                                  '$urlFiles/${chatController.chats[index].avatar}',
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(chatController.chats[index].username),
                              subtitle:
                                  Text(chatController.chats[index].content),
                            ),
                          );
                        }),
              )))
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      title: Text("Chat"),
      elevation: 0,
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
    );
  }
}
