import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/models.dart';
import 'package:halo/screens/chats/components/utils.dart';

class MessageMatch extends StatelessWidget {
  final Chat chat;
  final List<int> indexList;
  const MessageMatch({required this.chat, required this.indexList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_arrow_left, size: 30),
        ),
        title: Text(chat.chatName),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: indexList.length,
        itemBuilder: (context, index) {
          Message message = chat.message[indexList[index]];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/message');
            },
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          '$urlFiles/${message.sender.avatar}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 5, bottom: 5, right: 5),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            message.sender.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: textColor,
                                fontSize: mediumSize,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            child: Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 260),
                                    child: Text(
                                      message.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: subtitleColor,
                                          fontSize: smallSize),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Text('•'),
                                  const SizedBox(width: 2),
                                  Text(
                                    formatTime(message.createdAt),
                                    style: const TextStyle(
                                        fontSize: 14, color: subtitleColor),
                                  ),
                                ],
                              ),
                            ),
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
}
