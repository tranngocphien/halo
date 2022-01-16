class UserInfo {
  static late String userId;
  late String username;
  late String phonenumber;
  late String gender;
  late String description;
  late String avatar;
  late String coverImage;
  late List<String> blockedInbox;
  late String id;

  UserInfo({
    required this.username,
    required this.phonenumber,
    required this.gender,
    required this.description,
    required this.avatar,
    required this.coverImage,
    required this.blockedInbox,
    required this.id,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        username: json['username'],
        phonenumber: json['phonenumber'],
        gender: json['gender'],
        description: json['description'] ?? '',
        avatar: json['avatar']['fileName'] ?? '',
        coverImage:
            json['cover_image'] == null ? '' : json['cover_image']['fileName'],
        blockedInbox: (json['blocked_inbox'] as List).map((e) => e.toString()).toList(),
        id: json['_id']);
  }

  factory UserInfo.fromEmpty() => UserInfo(
      username: "",
      phonenumber: "",
      gender: "",
      description: "",
      avatar: "",
      coverImage: "",
      blockedInbox: [],
      id: "");
}
