import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/models.dart';
import 'package:halo/icons/icons.dart';

class ListTileCard extends StatelessWidget {
  final Conversation conversation;

  const ListTileCard({required this.conversation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.lightBlue[50],
      contentPadding: const EdgeInsets.all(8),
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/${conversation.partner.avatar}',
                fit: BoxFit.cover,
                width: 60.0,
                height: 60.0,
              ))),
      title: Text(conversation.partner.username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: changeStyle(true, false, false)),
      subtitle: Text(conversation.message.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: changeStyle(false, true, false)),
      trailing: Container(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  conversation.isPined
                      ? const Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Icon(
                            Pin.pin,
                            size: 14,
                            color: iconslightColor,
                          ),
                        )
                      : const Text(""),
                  conversation.isMuted
                      ? const Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.notifications_off,
                            size: 14,
                            color: iconslightColor,
                          ),
                        )
                      : const Text(""),
                  Text(formatTime(conversation.message.created),
                      style: changeStyle(false, false, true)),
                ]),
              ),
              const SizedBox(height: 2),
              conversation.message.unread == true
                  ? Container(
                      width: 24,
                      height: 16,
                      decoration: BoxDecoration(
                        color: conversation.isMuted
                            ? iconslightColor
                            : const Color(0xFFf84a4b),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                      ),
                      child: const Center(
                        child: Text("N",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    )
                  : const Text(""),
            ]),
      ),
      onTap: () {},
    );
  }

  TextStyle changeStyle(bool isTitle, bool isSubtitle, bool isTime) {
    if (isTitle) {
      return TextStyle(
        fontSize: mediumSize,
        color: conversation.message.unread ? textBoldColor : textColor,
        fontWeight:
            conversation.message.unread ? FontWeight.w600 : FontWeight.w500,
      );
    }

    return TextStyle(
      fontSize: smallSize,
      color: conversation.message.unread ? textColor : subtitleColor,
      fontWeight: FontWeight.w500,
    );
  }

  String formatTime(DateTime created) {
    DateTime curTime = DateTime.now();
    String result = "";

    String day = created.day >= 10 ? created.day.toString() : '0${created.day}';
    String month =
        created.month >= 10 ? created.month.toString() : '0${created.month}';
    String year = created.year.toString().substring(2);
    int difHours = curTime.difference(created).inHours;
    int difMinutes = curTime.difference(created).inMinutes;
    int difSeconds = curTime.difference(created).inSeconds;

    if (created.year != curTime.year) {
      result = '$day/$month/$year';
    } else if (created.month != curTime.month) {
      result = '$day/$month';
    } else if (curTime.day - created.day > 7 ||
        (curTime.weekday < created.weekday)) {
      result = '$day/$month';
    } else if (difHours > 24) {
      int weekday = created.weekday + 1;
      result = weekday != 8 ? 'T$weekday' : 'CN';
    } else if (difHours > 1) {
      result = '$difHours giờ';
    } else if (difMinutes > 1) {
      result = '$difMinutes phút';
    } else if (difSeconds > 1) {
      result = '$difSeconds giây';
    }
    return result;
  }
}
