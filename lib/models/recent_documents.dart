class RecentDocuments {
  String imageDoc;
  String nameDoc;
  int timeDoc;

  RecentDocuments({
    required this.imageDoc,
    required this.nameDoc,
    required this.timeDoc,
  });

  static List<RecentDocuments> getrecentitem() {
    List<RecentDocuments> item = [
      RecentDocuments(
        imageDoc: 'https://images2.thanhnien.vn/528068263637045248/2024/1/25/e093e9cfc9027d6a142358d24d2ee350-65a11ac2af785880-17061562929701875684912.jpg',
        nameDoc: 'Tai lieu hoc tap',
        timeDoc: DateTime.now().hour,
      ),
      RecentDocuments(
        imageDoc: 'https://sec-warehouse.vn/wp-content/uploads/2018/02/vi-sao-nen-luu-kho-tai-lieu.jpg',
        nameDoc: 'Cu ly',
        timeDoc: DateTime.now().hour,
      ),
      RecentDocuments(
        imageDoc: 'https://weone.vn/wp-content/uploads/2021/12/top-5-phan-mem-quan-ly-tai-lieu-1.jpg',
        nameDoc: 'Deadline',
        timeDoc: DateTime.now().hour,
      ),
    ];
    return item;
  }
}
