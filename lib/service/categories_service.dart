import 'package:mixboxapp/models/categoriesModel.dart';
import 'package:mixboxapp/service/api_service.dart';

class CategoriesService {
  static Future<List<Categoriesmodel>> listCategories() async {
    final response = await ApiService.get('/api/categories/list');
    final data = response['data'] as List;
    return data.map((item) {
      return Categoriesmodel(
        idCategory: item['id'],
        nameCategory: item['name'],
      );
    }).toList();
  }
}
