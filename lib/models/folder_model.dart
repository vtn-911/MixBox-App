class FolderModel {
  String id;
  String userId;
  String nameFolder;
  int doucments;
  DateTime updatedAt;

  FolderModel({
    required this.id,
    required this.userId,
    required this.nameFolder,
    required this.doucments,
    required this.updatedAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'],
      userId: json['user_id'],
      nameFolder: json['name'],
      doucments: json['_count']['documents'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
