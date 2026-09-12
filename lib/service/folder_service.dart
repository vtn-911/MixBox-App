import 'package:mixboxapp/models/folder_model.dart';
import 'package:mixboxapp/service/api_service.dart';

class FolderService {
  static Future<List<FolderModel>> listFolder(String userID) async {
    final response = await ApiService.get('/api/folders?userId=$userID');
    final data = response['data'] as List;
    return data.map((item) => FolderModel.fromJson(item)).toList();
  }
}
