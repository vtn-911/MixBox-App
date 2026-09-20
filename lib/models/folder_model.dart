import 'package:mixboxapp/models/dropdown_item_model.dart';

class FolderModel implements DropdownItemModel {
  String idFolder;
  String userId;
  String nameFolder;
  int doucments;
  DateTime updatedAt;

  FolderModel({
    required this.idFolder,
    required this.userId,
    required this.nameFolder,
    required this.doucments,
    required this.updatedAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      idFolder: json['id'],
      userId: json['user_id'],
      nameFolder: json['name'],
      doucments: json['_count']['documents'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String get id => idFolder;

  @override
  String get name => nameFolder;
}
