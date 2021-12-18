import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/models.dart';
import 'package:halo/icons/icons.dart';

class ListTileCard extends StatefulWidget {
  final dynamic chat;

  const ListTileCard({required this.chat, Key? key}) : super(key: key);

  @override
  State<ListTileCard> createState() => _ListTileCardState();
}

class _ListTileCardState extends State<ListTileCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.chat.message.unread = false;
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
                    '$urlFiles/${widget.chat.partner is User ? widget.chat.partner.avatar : widget.chat.partner[0].avatar}',
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
                              widget.chat.chatName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: changeStyle(true, false, false),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 235),
                                    child: Text(
                                      widget.chat.message.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: changeStyle(false, true, false),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Text('•'),
                                  const SizedBox(width: 2),
                                  Text(
                                    formatTime(widget.chat.message.createdAt),
                                    style: const TextStyle(
                                        fontSize: smallSize,
                                        color: subtitleColor),
                                  ),
                                ],
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
                                      widget.chat.isPined
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
                                      widget.chat.isMuted
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
                              widget.chat.message.unread == true
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
        color: widget.chat.message.unread ? textBoldColor : textColor,
        fontWeight:
            widget.chat.message.unread ? FontWeight.w600 : FontWeight.w500,
      );
    }

    return TextStyle(
      fontSize: smallSize,
      color: widget.chat.message.unread ? textColor : subtitleColor,
      fontWeight: FontWeight.w500,
    );
  }

  String formatTime(DateTime created) {
    DateTime curTime = DateTime.now();
    String result = "";

    String day = created.day.toString();
    String month = created.month.toString();
    String hour = created.hour.toString();
    String second = created.second.toString();
    int difHours = curTime.difference(created).inHours;

    if (curTime.day - created.day > 7) {
      result = '$day th $month';
    } else if (difHours > 24 || curTime.day != created.day) {
      int weekday = created.weekday + 1;
      result = weekday != 8 ? 'T$weekday' : 'CN';
    } else {
      result = '$hour:$second';
    }
    return result;
  }
}
