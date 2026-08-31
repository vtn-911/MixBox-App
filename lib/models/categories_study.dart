class CategoriesStudy {
  String nameCategory;

  CategoriesStudy({required this.nameCategory});

  static List<CategoriesStudy> getlistCategories() {
    List<CategoriesStudy> item = [
      CategoriesStudy(nameCategory: 'All'),
      CategoriesStudy(nameCategory: 'Programming'),
      CategoriesStudy(nameCategory: 'Database'),
      CategoriesStudy(nameCategory: 'Math'),
      CategoriesStudy(nameCategory: 'Software'),
    ];
    return item;
  }
}
