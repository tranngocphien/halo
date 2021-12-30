import 'package:halo/models/user_info.dart';
import 'dart:convert';
import 'dart:io';

class MessageModel {
  late String id;
  late UserInfo sender;
  late String content;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool unread;

  MessageModel(
      {required this.id,
      required this.sender,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.unread});

  factory MessageModel.fromContent(content) => MessageModel(
      id: "",
      sender: UserInfo.fromEmpty(),
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      unread: false);

  factory MessageModel.fromJson(Map<String, dynamic> jsonData) {
    final user = jsonData['user'] as Map<String, dynamic>;
    DateTime createdAt =
        DateTime.parse(jsonData["createdAt"]).add(const Duration(hours: 7));
    DateTime updatedAt =
        DateTime.parse(jsonData["createdAt"]).add(const Duration(hours: 7));
    return MessageModel(
      id: jsonData['_id'],
      sender: UserInfo(
        id: user['_id'],
        username: user['username'],
        phonenumber: user['phonenumber'],
        gender: user['gender'],
        avatar: user['avatar']['fileName'],
        coverImage: "",
      ),
      content: jsonData['content'],
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
      unread: true,
    );
  }
}
