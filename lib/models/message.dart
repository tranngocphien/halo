import 'package:halo/models/user_screen.dart';

class Message {
  late String id;
  late User sender;
  late String content;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool unread;

  Message(
      {required this.id,
      required this.sender,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.unread});

  factory Message.fromContent(content) => Message(
      id: "",
      sender: User.fromEmpty(),
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      unread: false);
}
