class FolderModel {
  String id;
  String userId;
  String nameFolder;

  FolderModel({
    required this.id,
    required this.userId,
    required this.nameFolder,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'],
      userId: json['user_id'],
      nameFolder: json['name'],
    );
  }
}
