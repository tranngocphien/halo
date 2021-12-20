import 'message.dart';
import 'user_screen.dart';

class Chat {
  late String id;
  late String chatName;
  late dynamic partner;
  late Message message;
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
      message: Message.fromContent("Thành viên: $username"),
      isMuted: false,
      isPined: false,
    );
  }

  factory Chat.fromJson(json) {
    final chat = json['chat'];
    final lastMessage = json['last_message'];
    String chatName = "";
    dynamic partner;
    String content = "";
    DateTime createdAt =
        DateTime.parse(lastMessage["createdAt"]).add(const Duration(hours: 7));
    DateTime updatedAt =
        DateTime.parse(lastMessage["createdAt"]).add(const Duration(hours: 7));

    final member = chat['member'];

    if (chat['type'] == "PRIVATE_CHAT") {
      final other = User.userId == member[0]['_id'] ? member[1] : member[0];
      chatName = other['username'];
      partner =
          User(other["_id"], chatName, "", other['avatar']["fileName"], "");
      content = User.userId == lastMessage["senderId"]
          ? 'You: ${lastMessage['content']}'
          : lastMessage['content'];
    } else {
      chatName = chat["name"];
      partner = member.map((user) {
        if (user["_id"] != User.userId) {
          return User(user["_id"], user["username"], "",
              user['avatar']["fileName"], "");
        }
      }).toList();
      if (lastMessage['senderId'] == User.userId) {
        content = 'You: ${lastMessage['content']}';
      } else {
        partner.removeWhere((value) => value == null);

        User sender = partner
            .where((user) => user.id == lastMessage['senderId'])
            .toList()[0];
        content = '${sender.username}: ${lastMessage['content']}';
      }
    }

    return Chat(
      id: chat['_id'],
      chatName: chatName,
      partner: partner,
      message: Message(
        id: "",
        sender: User.fromEmpty(),
        content: content,
        createdAt: DateTime(
            createdAt.year,
            createdAt.month,
            createdAt.day,
            createdAt.hour,
            createdAt.minute,
            createdAt.second,
            createdAt.microsecond),
        updatedAt: DateTime(
            updatedAt.year,
            updatedAt.month,
            updatedAt.day,
            updatedAt.hour,
            updatedAt.minute,
            updatedAt.second,
            updatedAt.microsecond),
        unread: true,
      ),
      isMuted: false,
      isPined: false,
    );
  }
}
