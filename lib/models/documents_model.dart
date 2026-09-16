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
    return DocumentsModel(
      id: json['id'],
      title: json['title'],
      pageCount: json['page_count'],
      category: json['category'],
      owner: json['owner'],
    );
  }
}
