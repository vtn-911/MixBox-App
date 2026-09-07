class DocumentPage {
  String id;
  int pageNumber;
  String pageURL;

  DocumentPage({
    required this.id,
    required this.pageNumber,
    required this.pageURL,
  });

  factory DocumentPage.fromJson(Map<String, dynamic> json) {
    return DocumentPage(
      id: json['id'],
      pageNumber: json['page_number'],
      pageURL: json['image_url'],
    );
  }
}
