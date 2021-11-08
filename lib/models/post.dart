import 'package:halo/models/user.dart';

class Post {
  final String username;
  final String content;
  // final List<dynamic> image;
  // final List<dynamic> videos;
  // final String createAt;
  // final String updateAt;
  // final int countComments;

  Post(
      {required this.username, required this.content,
      // required this.image,
      // required this.videos,
      // required this.createAt,
      // required this.updateAt,
      // required this.countComments
  });

  factory Post.fromMap(Map<String, dynamic> json) => Post(
    username: json["author"]["username"],
      // user: User(id: json["author"]["_id"], username: json["author"]["username"], phonenumber: json["author"]["phonenumber"] ),
    content: json["described"] == null? "": json["described"],
      // image: json["images"],
      // videos: json["videos"],
      // createAt: json["createdAt"],
      // updateAt: json["updatedAt"],
      // countComments: json["countComments"]
  );

}
