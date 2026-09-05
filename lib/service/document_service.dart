import 'package:mixboxapp/models/documents_model.dart';
import 'package:mixboxapp/service/api_service.dart';

class DocumentService {
  static Future<List<DocumentsModel>> listallDocuments() async {
    final respone = await ApiService.get('/api/documents/listall');
    final data = respone['data'] as List;
    return data.map((item) {
      return DocumentsModel(
        id: item['id'],
        title: item['title'],
        pageCount: item['page_count'],
        category: item['category'],
        owner: item['owner'],
      );
    }).toList();
  }
}
