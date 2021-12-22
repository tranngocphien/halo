import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/models.dart';
import 'package:halo/icons/icons.dart';
import 'package:halo/screens/chats/components/utils.dart';

class ListTileCard extends StatefulWidget {
  final Chat chat;

  const ListTileCard({required this.chat, Key? key}) : super(key: key);

  @override
  State<ListTileCard> createState() => _ListTileCardState();
}

class _ListTileCardState extends State<ListTileCard> {
  late Chat chat;
  late Message lastMessage;
  late String content = "";
  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    lastMessage = chat.message[chat.message.length - 1];
    if (chat.partner is User) {
      content = lastMessage.sender.id == User.userId
          ? "You: ${lastMessage.content}"
          : lastMessage.content;
    } else {
      if (lastMessage.sender.id == User.userId) {
        content = "You: ${lastMessage.content}";
      } else {
        content = "${lastMessage.sender.username}: ${lastMessage.content}";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            lastMessage.unread = false;
          });
          Navigator.pushNamed(context, '/message');
        },
        child: SizedBox(
          height: 80,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    '$urlFiles/${chat.partner is User ? chat.partner.avatar : chat.partner[0].avatar}',
                    fit: BoxFit.cover,
                    width: 70.0,
                    height: 70.0,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: textColor,
                      width: 0.08,
                    ),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.chatName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: changeStyle(true, false, false),
                            ),
                            Container(
                              child: Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 210),
                                      child: Text(
                                        content,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: changeStyle(false, true, false),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Text('•'),
                                    const SizedBox(width: 2),
                                    Text(
                                      formatTime(lastMessage.createdAt),
                                      style: const TextStyle(
                                          fontSize: smallSize,
                                          color: subtitleColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 100),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      chat.isPined
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 2),
                                              child: Icon(
                                                Pin.pin,
                                                size: smallSize,
                                                color: iconslightColor,
                                              ),
                                            )
                                          : const Text(""),
                                      const SizedBox(width: 3),
                                      chat.isMuted
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 2),
                                              child: Icon(
                                                Notifications_off
                                                    .bell_slash_fill,
                                                size: smallSize,
                                                color: iconslightColor,
                                              ),
                                            )
                                          : const Text(""),
                                    ]),
                              ),
                              lastMessage.unread == true
                                  ? const CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.blue,
                                    )
                                  : const Text(""),
                            ]),
                      ),
                    ]),
              ),
            ),
          ]),
        ));
  }

  TextStyle changeStyle(bool isTitle, bool isSubtitle, bool isTime) {
    if (isTitle) {
      return TextStyle(
        fontSize: mediumSize,
        color: lastMessage.unread ? textBoldColor : textColor,
        fontWeight: lastMessage.unread ? FontWeight.w600 : FontWeight.w500,
      );
    }

    return TextStyle(
      fontSize: smallSize,
      color: lastMessage.unread ? textColor : subtitleColor,
      fontWeight: FontWeight.w500,
    );
  }
}
