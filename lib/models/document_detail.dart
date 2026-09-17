import 'package:mixboxapp/models/document_page.dart';

class DocumentDetail {
  String id;
  String title;
  String description;
  String fileUrl;
  String fileType;
  int fileSize;
  int pageCount;
  String ownerFullName;
  String ownerAvatar;
  String categoryName;
  DateTime createdAt;
  List<DocumentPage> pages;

  DocumentDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.pageCount,
    required this.ownerFullName,
    required this.ownerAvatar,
    required this.categoryName,
    required this.createdAt,
    required this.pages,
  });

  factory DocumentDetail.fromJson(Map<String, dynamic> json) {
    return DocumentDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      fileUrl: json['file_url'],
      fileType: json['file_type'],
      fileSize: json['file_size'],
      pageCount: json['page_count'],
      ownerFullName: json['owner']['full_name'],
      ownerAvatar: json['owner']['avatar_url'],
      categoryName: json['category']['name'],
      createdAt: DateTime.parse(json['created_at']),
      pages: (json['pages'] as List)
          .map((page) => DocumentPage.fromJson(page))
          .toList(),
    );
  }
}
