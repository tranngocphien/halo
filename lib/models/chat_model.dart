class ChatModel {
  final String id;
  final String username;
  final String userId;
  final String avatar;
  final String content;

  ChatModel(
      {required this.id,
      required this.username,
        required this.userId,
      required this.avatar,
      required this.content});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        id: json['chat']['_id'],
        username: json['chat']['member'][0]['username'],
        userId: json['chat']['member'][0]['_id'],
        avatar: json['chat']['member'][0]['avatar']['fileName'],
        content: json['content']);
  }
}
