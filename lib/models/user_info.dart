class UserInfo {
  final String username;
  final String phonenumber;
  final String gender;
  final String avatar;
  final String coverImage;
  final String id;

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
        coverImage:json['cover_image'] == null? '': json['cover_image']['fileName'],
        id: json['_id']);
  }
}
