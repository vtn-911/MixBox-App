class FolderDocuments {
  String id;
  String title;
  String? thumbnailUrl;
  int pageCount;
  String categoryID;
  String categoryName;
  String owner;
  String description;
  String visibilityDoc;

  FolderDocuments({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    required this.pageCount,
    required this.categoryID,
    required this.categoryName,
    required this.owner,
    required this.description,
    required this.visibilityDoc,
  });

  factory FolderDocuments.fromJson(Map<String, dynamic> json) {
    return FolderDocuments(
      id: json['id'],
      title: json['title'],
      pageCount: json['pageCount'],
      categoryID: json['category']['id'],
      categoryName: json['category']['name'],
      owner: json['owner'],
      description: json['description'],
      visibilityDoc: json['visibility'],
    );
  }
}
