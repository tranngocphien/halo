class User {
  static late String userId;
  late String id;
  late String username;
  late String phonenumber;
  late String avatar;
  late String cover_image;

  User(this.id, this.username, this.phonenumber, this.avatar, this.cover_image);

  factory User.fromJson(json) =>
      User(json["_id"], json["username"], "", json["avatar"]["fileName"], "");

  factory User.fromEmpty() => User("", "", "", "", "");
}
