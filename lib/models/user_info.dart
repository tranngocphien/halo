class UserInfo {
  static late String userId;
  late String username;
  late String phonenumber;
  late String gender;
  late String avatar;
  late String coverImage;
  late String id;

  UserInfo({
    required this.username,
    required this.phonenumber,
    required this.gender,
    required this.avatar,
    required this.coverImage,
    required this.id,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        username: json['username'],
        phonenumber: json['phonenumber'],
        gender: json['gender'],
        avatar: json['avatar']['fileName'] ?? '',
        coverImage:
            json['cover_image'] == null ? '' : json['cover_image']['fileName'],
        id: json['_id']);
  }

  factory UserInfo.fromEmpty() => UserInfo(
      username: "",
      phonenumber: "",
      gender: "",
      avatar: "",
      coverImage: "",
      id: "");
}
