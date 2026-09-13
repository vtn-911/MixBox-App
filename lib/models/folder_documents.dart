class FolderDocuments {
  String id;
  String title;
  String? thumbnailUrl;
  int pageCount;
  String category;
  String owner;

  FolderDocuments({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    required this.pageCount,
    required this.category,
    required this.owner,
  });

  factory FolderDocuments.fromJson(Map<String, dynamic> json) {
    return FolderDocuments(
      id: json['id'],
      title: json['title'],
      pageCount: json['pageCount'],
      category: json['category'],
      owner: json['owner'],
    );
  }
}
