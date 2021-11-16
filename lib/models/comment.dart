class Comment {
  final String username;
  final String content;
  final String createdAt;

  Comment(
      {required this.username, required this.content, required this.createdAt});

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        username: json["user"]["username"],
        content: json["content"] == null ? "" : json["content"],
        createdAt: json["createdAt"],
      );
}
