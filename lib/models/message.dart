class Message {
  final String id;
  final String message;
  final DateTime created;
  final bool unread;

  Message(
      {required this.id,
      required this.message,
      required this.created,
      required this.unread});
}
