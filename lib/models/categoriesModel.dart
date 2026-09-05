class Categoriesmodel {
  String idCategory;
  String nameCategory;

  Categoriesmodel({required this.idCategory, required this.nameCategory});

  factory Categoriesmodel.fromJson(Map<String, dynamic> json) {
    return Categoriesmodel(idCategory: json['id'], nameCategory: json['name']);
  }
}
