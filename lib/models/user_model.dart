class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }
}
