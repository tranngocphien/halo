import 'package:halo/models/user_info.dart';

class MessageModel {
  final UserInfo userInfo;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isSender;

  MessageModel(
      {required this.userInfo,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.isSender});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        userInfo: UserInfo.fromJson(json['user']),
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isSender: true);
  }
}
