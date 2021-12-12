class CommentModel {
  final String username;
  final String content;
  final String createdAt;

  CommentModel(
      {required this.username, required this.content, required this.createdAt});

  factory CommentModel.fromMap(Map<String, dynamic> json) => CommentModel(
        username: json["user"]["username"],
        content: json["content"] == null ? "" : json["content"],
        createdAt: json["createdAt"],
      );
}
