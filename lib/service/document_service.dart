import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mixboxapp/models/document_detail.dart';
import 'package:mixboxapp/models/documents_model.dart';
import 'package:mixboxapp/service/api_service.dart';

class DocumentService {
  static Future<List<DocumentsModel>> listallDocuments() async {
    final respone = await ApiService.get('/api/documents/listall');
    final data = respone['data'] as List;
    return data.map((item) => DocumentsModel.fromJson(item)).toList();
  }

  static Future<DocumentDetail> getDocumentById(String documentId) async {
    final response = await ApiService.get('/api/documents/$documentId');
    final data = response['data'];
    return DocumentDetail.fromJson(data);
  }

  static Future<List<DocumentsModel>> searchDocuments({
    String? query,
    String? categoryId,
    String? folderId,
    String? visibility,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (query != null && query.trim().isNotEmpty) {
      queryParams['query'] = query.trim();
    }

    if (categoryId != null) {
      queryParams['category_id'] = categoryId;
    }

    if (folderId != null) {
      queryParams['folder_id'] = folderId;
    }

    if (visibility != null) {
      queryParams['visibility'] = visibility;
    }

    final uri = Uri.parse('${ApiService.baseUrl}/api/documents/search')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final data = body['data'];

      final List documentsJson = data['documents'];

      return documentsJson
          .map((json) => DocumentsModel.fromJson(json))
          .toList();
    }
    throw Exception('Failed to search documents');
  }
}
