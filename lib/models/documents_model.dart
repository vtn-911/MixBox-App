class DocumentsModel {
  String id;
  String title;
  String? thumbnailUrl;
  int pageCount;
  String category;
  String owner;

  DocumentsModel({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    required this.pageCount,
    required this.category,
    required this.owner,
  });

  factory DocumentsModel.fromJson(Map<String, dynamic> json) {
    String category = '';
    String owner = '';

    if (json['category'] is String) {
      category = json['category'];
    } else if (json['category'] is Map) {
      category = json['category']['name'] ?? '';
    }
    if (json['owner'] is String) {
      owner = json['owner'];
    } else if (json['owner'] is Map) {
      owner = json['owner']['full_name'] ?? '';
    }
    return DocumentsModel(
      id: json['id'],
      title: json['title'],
      pageCount: json['page_count'],
      category: category,
      owner: owner,
    );
  }
}
