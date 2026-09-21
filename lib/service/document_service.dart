import 'dart:convert';

import 'package:file_picker/file_picker.dart';
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

  static Future<bool> updateDocument(
    String docId,
    String? title,
    String? description,
    String? categoryId,
    String? folderId,
    String? visibility,
  ) async {
    try {
      await ApiService.put('/api/documents/$docId', {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (categoryId != null) 'category_id': categoryId,
        if (folderId != null) 'folder_id': folderId,
        if (visibility != null) 'visibility': visibility,
      });
      return true;
    } catch (e) {
      print('UPDATE DOCUMENT ERROR: $e');
      return false;
    }
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

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }

    if (folderId != null && folderId.isNotEmpty) {
      queryParams['folder_id'] = folderId;
    }

    if (visibility != null && visibility.isNotEmpty) {
      queryParams['visibility'] = visibility;
    }

    final queryString = Uri(queryParameters: queryParams).query;

    final response = await ApiService.get('/api/documents/search?$queryString');

    final data = response['data'];
    final List documentsJson = data['documents'];

    return documentsJson.map((json) => DocumentsModel.fromJson(json)).toList();
  }

  static Future<Map<String, dynamic>> createDocument({
    required String title,
    required String? categoryID,
    required String? folderID,
    required String? description,
    required PlatformFile file,
    required String? visibility,
    PlatformFile? thumbnailFile,
  }) async {
    final response = await ApiService.postMultipart(
      endpoint: '/api/documents',
      fields: {
        'title': title,
        'category_id': ?categoryID,
        'description': ?description,
        'folder_id': ?folderID,
        'visibility': ?visibility,
      },
      file: file,
      fileField: 'document',
      thumbnailFile: thumbnailFile,
    );
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data as Map<String, dynamic>;
    }
    throw Exception(data['message'] ?? 'Create document failed');
  }
}
