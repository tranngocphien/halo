import 'message.dart';
import 'user_screen.dart';

class Chat {
  late String id;
  late String chatName;
  late dynamic partner;
  late List<Message> message;
  late bool isMuted;
  late DateTime mutedTo;
  late bool isPined;

  Chat(
      {required this.id,
      required this.chatName,
      required this.partner,
      required this.message,
      required this.isMuted,
      required this.isPined});

  factory Chat.fromGroup(username, chat) {
    final member = chat['member'];
    dynamic partner = [];

    for (var i = 0; i < member.length; i++) {
      if (member[i] != User.userId) {
        partner.add(User(member[i]['_id'], member[i]['username'], "",
            member[i]['avatar']["fileName"], ""));
      }
    }

    return Chat(
      id: chat['_id'],
      chatName: chat['name'],
      partner: partner,
      message: [Message.fromContent("Thành viên: $username")],
      isMuted: false,
      isPined: false,
    );
  }

  factory Chat.fromJson(json) {
    final chat = json;
    final messages = chat['message'];
    String chatName = "";
    dynamic partner;

    final member = chat['member'];

    var mapAvatar = member
        .map((user) => {user['avatar']['_id']: user['avatar']['fileName']});
    mapAvatar = mapAvatar.reduce((map1, map2) => map1..addAll(map2));

    List<Message> message = [];

    for (var i = 0; i < messages.length; i++) {
      final tmp = messages[i];
      DateTime createdAt =
          DateTime.parse(tmp["createdAt"]).add(const Duration(hours: 7));
      DateTime updatedAt =
          DateTime.parse(tmp["createdAt"]).add(const Duration(hours: 7));
      message.add(Message(
        id: tmp["_id"],
        sender: User(tmp["user"]["_id"], tmp["user"]["username"], "",
            mapAvatar[tmp["user"]["avatar"]], ""),
        content: tmp["content"],
        createdAt: DateTime(
          createdAt.year,
          createdAt.month,
          createdAt.day,
          createdAt.hour,
          createdAt.minute,
          createdAt.second,
          createdAt.microsecond,
        ),
        updatedAt: DateTime(
          updatedAt.year,
          updatedAt.month,
          updatedAt.day,
          updatedAt.hour,
          updatedAt.minute,
          updatedAt.second,
          updatedAt.microsecond,
        ),
        unread: false,
      ));
    }

    if (chat['type'] == "PRIVATE_CHAT") {
      final other = User.userId == member[0]['_id'] ? member[1] : member[0];
      chatName = other['username'];
      partner = User(
          other["_id"], other['username'], "", other['avatar']["fileName"], "");
    } else {
      chatName = chat["name"];
      partner = member.map((user) {
        if (user["_id"] != User.userId) {
          return User(user["_id"], user["username"], "",
              user['avatar']["fileName"], "");
        }
        return null;
      }).toList();
      partner.removeWhere((user) => user == null);
    }

    return Chat(
      id: chat['_id'],
      chatName: chatName,
      partner: partner,
      message: message,
      isMuted: false,
      isPined: false,
    );
  }
}
