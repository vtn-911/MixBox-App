import 'package:mixboxapp/models/document_detail.dart';
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

  static Future<DocumentDetail> getDocumentById(String documentId) async {
    final response = await ApiService.get('/api/documents/$documentId');
    final data = response['data'];
    return DocumentDetail.fromJson(data);
  }
}
