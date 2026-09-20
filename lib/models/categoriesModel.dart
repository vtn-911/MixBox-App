import 'package:mixboxapp/models/dropdown_item_model.dart';

class Categoriesmodel implements DropdownItemModel {
  String idCategory;
  String nameCategory;

  Categoriesmodel({required this.idCategory, required this.nameCategory});

  factory Categoriesmodel.fromJson(Map<String, dynamic> json) {
    return Categoriesmodel(idCategory: json['id'], nameCategory: json['name']);
  }

  @override
  String get id => idCategory;

  @override
  String get name => nameCategory;
}
