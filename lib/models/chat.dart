import 'package:halo/models/user_info.dart';

import 'message_model.dart';

class Chat {
  late String id;
  late String chatName;
  late dynamic partner;
  late List<MessageModel> message;
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
      if (member[i] != UserInfo.userId) {
        partner.add(UserInfo(
            id: member[i]['_id'],
            username: member[i]['username'],
            phonenumber: "",
            gender: "",
            description: "",
            avatar: member[i]['avatar']["fileName"],
            blockedInbox: [],
            coverImage: ""));
      }
    }

    return Chat(
      id: chat['_id'],
      chatName: chat['name'],
      partner: partner,
      message: username.toLowerCase() == chat['name'].toLowerCase()
          ? [MessageModel.fromContent("Nhóm chat: $username")]
          : [MessageModel.fromContent("Thành viên: $username")],
      isMuted: false,
      isPined: false,
    );
  }

  factory Chat.fromJson(json, messages) {
    final chat = json;
    String chatName = "";
    dynamic partner;

    final member = chat['member'];

    print(json);

    var mapAvatar = member
        .map((user) => {user['avatar']['_id']: user['avatar']['fileName']});
    mapAvatar = mapAvatar.reduce((map1, map2) => map1..addAll(map2));

    List<MessageModel> message = [];

    for (var i = 0; i < messages.length; i++) {
      final tmp = messages[i];
      DateTime createdAt =
          DateTime.parse(tmp["createdAt"]).add(const Duration(hours: 7));
      DateTime updatedAt =
          DateTime.parse(tmp["createdAt"]).add(const Duration(hours: 7));

      message.add(MessageModel(
        id: tmp["_id"],
        sender: UserInfo(
            id: tmp["user"]["_id"],
            username: tmp["user"]["username"],
            phonenumber: tmp["user"]["phonenumber"],
            description: "",
            gender: "",
            blockedInbox: [],
            avatar: "60c39f54f0b2c4268eb53367",
            coverImage: ""),
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
      final other = UserInfo.userId == member[0]['_id'] ? member[1] : member[0];
      chatName = other['username'];
      partner = UserInfo(
          id: other["_id"],
          username: other['username'],
          phonenumber: "",
          gender: "",
          description: "",
          blockedInbox: [],
          avatar: other['avatar']["fileName"],
          coverImage: "");
    } else {
      chatName = chat["name"];
      partner = member.map((user) {
        if (user["_id"] != UserInfo.userId) {
          return UserInfo(
              id: user["_id"],
              username: user["username"],
              phonenumber: "",
              gender: "",
              description: "",
              blockedInbox: [],
              avatar: user['avatar']["fileName"],
              coverImage: "");
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

  List<String> getMember() {
    List<String> member = [];

    member.add(UserInfo.userId);
    if (partner is UserInfo) {
      member.add(partner.id);
    } else {
      member.addAll(partner
          .map((user) {
            return user.id;
          })
          .toList()
          .cast<String>());
    }

    return member;
  }
}
