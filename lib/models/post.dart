import 'package:halo/models/models.dart';

class PostModel {
  final String username;
  final String content;
  final String id;
  final List<ImageModel> image;
  // final List<dynamic> videos;
  final List like;
  final String createAt;
  final String updateAt;
  final bool isLike;
  final int countComments;

  PostModel(
      {required this.username,
      required this.content,
      required this.id,
      required this.image,
      // required this.videos,
      required this.like,
      required this.createAt,
      required this.updateAt,
      required this.isLike,
      required this.countComments});

  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
      username: json["author"]["username"],
      content: json["described"] == null ? "" : json["described"],
      id: json["_id"],
      image: List<ImageModel>.from(
          json["images"].map((x) => ImageModel.fromJson(x))),
      // videos: json["videos"],
      like: json["like"],
      createAt: json["createdAt"],
      updateAt: json["updatedAt"],
      isLike: json["isLike"],
      countComments: json["countComments"]);
}
